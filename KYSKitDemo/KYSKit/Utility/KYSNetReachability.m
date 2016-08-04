//
//  KYSNetReachability.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNetReachability.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

typedef void(^KYSSCNetworkCallbackBlock)(SCNetworkReachabilityFlags flags);

@interface KYSNetReachability()

//@property (nonatomic, assign) BOOL scheduled;
@property (nonatomic, assign) SCNetworkReachabilityRef networkReachabilityRef;
@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;
@property (nonatomic, assign, readonly) SCNetworkReachabilityFlags flags;

#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

@end

static KYSNetReachabilityStatus KYSNetReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return KYSNetReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return KYSNetReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        return KYSNetReachabilityStatusWWAN;
    }
    
    return KYSNetReachabilityStatusWiFi;
}

//static void KYSNetReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
//    KYSNetReachability *self = ((__bridge KYSNetReachability *)info);
//    if (self.callbackBlock) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.callbackBlock(self.status);
//        });
//    }
//}

static void KYSPostReachabilityStatusChange(SCNetworkReachabilityFlags flags, KYSSCNetworkCallbackBlock block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(flags);
        }
    });
}

//网络变化回调
static void KYSNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    KYSPostReachabilityStatusChange(flags, (__bridge KYSSCNetworkCallbackBlock)info);
}

static const void * KYSNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void KYSNetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

//static SCNetworkReachabilityRef KYSLocalAddressTypeRef(){
//    struct sockaddr_in zero_addr;
//    bzero(&zero_addr, sizeof(zero_addr));
//    zero_addr.sin_len = sizeof(zero_addr);
//    zero_addr.sin_family = AF_INET;
//    zero_addr.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
//    return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
//}

@implementation KYSNetReachability

+ (dispatch_queue_t)sharedQueue{
    static dispatch_queue_t queue;
    static dispatch_once_t queueOnceToken;
    dispatch_once(&queueOnceToken, ^{
        queue = dispatch_queue_create("com.ibireme.yykit.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

+ (instancetype)sharedReachability{
    static KYSNetReachability *sharedReachability=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in zero_addr;
        bzero(&zero_addr, sizeof(zero_addr));
        zero_addr.sin_len = sizeof(zero_addr);
        zero_addr.sin_family = AF_INET;
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
        sharedReachability=[[self alloc] initWithReachabilityRef:reachability];
    });
    return sharedReachability;
}

+ (instancetype)reachabilityWithAddress:(const void *)address{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    return [[self alloc] initWithReachabilityRef:reachability];
}

+ (instancetype)ReachabilityWithDomain:(NSString *)domain{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    return [[self alloc] initWithReachabilityRef:reachability];
}

- (void)dealloc {
    [self stopMonitoring];
    self.callbackBlock = nil;
    //self.scheduled = NO;
    CFRelease(self.networkReachabilityRef);
}

- (SCNetworkReachabilityFlags)flags{
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(_networkReachabilityRef, &flags);
    return flags;
}

- (KYSNetReachabilityStatus)status {
    return KYSNetReachabilityStatusFromFlags(self.flags);
}

- (KYSWWANStatus)wwanStatus {
    if (!self.networkInfo) return KYSWWANStatusNone;
    NSString *status = self.networkInfo.currentRadioAccessTechnology;
    if (!status) return KYSWWANStatusNone;
    static NSDictionary *dic;
    static dispatch_once_t wwanOnceToken;
    dispatch_once(&wwanOnceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS:        @(KYSWWANStatus2G), // 2.5G   171Kbps
                CTRadioAccessTechnologyEdge:        @(KYSWWANStatus2G), // 2.75G  384Kbps
                CTRadioAccessTechnologyWCDMA:       @(KYSWWANStatus3G), // 3G     3.6Mbps/384Kbps
                CTRadioAccessTechnologyHSDPA:       @(KYSWWANStatus3G), // 3.5G   14.4Mbps/384Kbps
                CTRadioAccessTechnologyHSUPA:       @(KYSWWANStatus3G), // 3.75G  14.4Mbps/5.76Mbps
                CTRadioAccessTechnologyCDMA1x:      @(KYSWWANStatus3G), // 2.5G
                CTRadioAccessTechnologyCDMAEVDORev0:@(KYSWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA:@(KYSWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB:@(KYSWWANStatus3G),
                CTRadioAccessTechnologyeHRPD:       @(KYSWWANStatus3G),
                CTRadioAccessTechnologyLTE:         @(KYSWWANStatus4G)}; // LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
    });
    NSNumber *num = dic[status];
    if (num) return num.unsignedIntegerValue;
    else return KYSWWANStatusNone;
}

- (BOOL)isReachable {
    return self.status != KYSNetReachabilityStatusNone;
}

- (BOOL)isReachableViaWiFi{
    return self.status == KYSNetReachabilityStatusWiFi;
}

- (BOOL)isReachableViaWWAN{
    return self.status == KYSNetReachabilityStatusWWAN;
}

//- (void)setScheduled:(BOOL)scheduled {
//    if (_scheduled == scheduled) return;
//    _scheduled = scheduled;
//    if (scheduled) {
//        //开始
//        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
//        SCNetworkReachabilitySetCallback(_networkReachabilityRef, KYSNetReachabilityCallback, &context);
//        SCNetworkReachabilitySetDispatchQueue(_networkReachabilityRef, [[self class] sharedQueue]);
//    } else {
//        //停止
//        SCNetworkReachabilitySetDispatchQueue(_networkReachabilityRef, NULL);
//    }
//}

//开始监控网络
- (void)startMonitoringWithNetChangeCallBack:(KYSNetCallbackBlock)block {
    [self stopMonitoring];
    
    if (!self.networkReachabilityRef) {
        return;
    }
    
    if (block) {
        self.callbackBlock=block;
    }

//开启后台任务
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication && [self shouldContinueWhenAppEntersBackground]) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"后台任务时间到达上限");
            __strong __typeof (wself) sself = wself;
            if (sself) {
                //可以做一些结束操作
                [app endBackgroundTask:sself.backgroundTaskId];
                sself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        }];
    }
#endif
    
    //从新包装下网络变化回调
    __weak __typeof(self)weakSelf = self;
    KYSSCNetworkCallbackBlock callback = ^(SCNetworkReachabilityFlags flags) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.callbackBlock) {
            strongSelf.callbackBlock(KYSNetReachabilityStatusFromFlags(flags));
            //strongSelf.callbackBlock(strongSelf.status);//其实是一样的
        }
    };
    
    SCNetworkReachabilityRef networkReachability = self.networkReachabilityRef;
    SCNetworkReachabilityContext context = {0,
                                            (__bridge void *)callback,
                                            KYSNetworkReachabilityRetainCallback,
                                            KYSNetworkReachabilityReleaseCallback,
                                            NULL};
    SCNetworkReachabilitySetCallback(networkReachability, KYSNetworkReachabilityCallback, &context);
    //RunLoop
    //SCNetworkReachabilityScheduleWithRunLoop(networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    //dispatch
    SCNetworkReachabilitySetDispatchQueue(networkReachability, [[self class] sharedQueue]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(networkReachability, &flags)) {
            KYSPostReachabilityStatusChange(flags, callback);
        }
    });
}

//停止监控网络
- (void)stopMonitoring {
    if (!self.networkReachabilityRef) {
        return;
    }
    SCNetworkReachabilityRef networkReachability = self.networkReachabilityRef;
    //RunLoop
    //SCNetworkReachabilityUnscheduleFromRunLoop(networkReachability,CFRunLoopGetMain(),kCFRunLoopCommonModes);
    //dispatch
    SCNetworkReachabilitySetDispatchQueue(networkReachability, NULL);

//结束后台任务
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
#endif
}


#pragma mark - private
- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref {
    self = [super init];
    if (self){
        _networkReachabilityRef = ref;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
            _networkInfo = [CTTelephonyNetworkInfo new];
        }
    }
    return self;
}

@end
