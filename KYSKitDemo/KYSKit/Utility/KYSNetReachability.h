//
//  KYSNetReachability.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class KYSNetReachability;

typedef NS_ENUM(NSInteger,KYSNetReachabilityStatus){
    KYSNetReachabilityStatusNone = 0,
    KYSNetReachabilityStatusWWAN,
    KYSNetReachabilityStatusWiFi,
};

typedef NS_ENUM(NSInteger,KYSWWANStatus){
    KYSWWANStatusNone = 0,
    KYSWWANStatus2G = 2,
    KYSWWANStatus3G,
    KYSWWANStatus4G,
};

typedef void(^KYSNetCallbackBlock)(KYSNetReachabilityStatus status);

@interface KYSNetReachability : NSObject

@property(nonatomic,assign,readonly)KYSNetReachabilityStatus status;
@property(nonatomic,assign,readonly)KYSWWANStatus wwanStatus;
@property(readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property(readonly, nonatomic, assign, getter = isReachableWWAN) BOOL reachableViaWWAN;
@property(readonly, nonatomic, assign, getter = isReachableWiFi) BOOL reachableViaWiFi;
@property(nonatomic, assign)BOOL shouldContinueWhenAppEntersBackground;//是否开启后台监测 
@property(nonatomic, copy)KYSNetCallbackBlock callbackBlock;//网络变化回调

+ (instancetype)sharedReachability;

+ (instancetype)reachabilityWithAddress:(const void *)address;

+ (instancetype)ReachabilityWithDomain:(NSString *)domain;

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoringWithNetChangeCallBack:(KYSNetCallbackBlock)block;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

@end
