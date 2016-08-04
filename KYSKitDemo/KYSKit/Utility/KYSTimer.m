//
//  KYSTimer.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTimer.h"
#import <pthread.h>

#define LOCK(...) \
dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__ \
dispatch_semaphore_signal(_lock);

@interface KYSTimer()

@property(nonatomic,assign) BOOL valid;
@property(nonatomic,assign) NSTimeInterval timeInterval;
@property(nonatomic,assign) BOOL repeats;
@property(nonatomic,weak)id target;
@property(nonatomic,assign) SEL selector;
@property(nonatomic,strong) dispatch_source_t source;
@property(nonatomic,strong) dispatch_semaphore_t lock;

@end

@implementation KYSTimer

+ (KYSTimer *)timerWithTimeInterval:(NSTimeInterval)interval//间距
                             target:(id)target
                           selector:(SEL)selector
                            repeats:(BOOL)repeats{
    
   return [[self alloc] initWithFireTime:interval
                          interval:interval
                            target:target
                          selector:selector
                           repeats:repeats];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"KYSTimer init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithFireTime:0 interval:0 target:nil selector:NULL repeats:NO];
}

- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats {
    
    self=[super init];
    if (self) {
        _timeInterval=interval;
        _target=target;
        _selector=selector;
        _repeats=repeats;
        _valid=YES;
        _lock = dispatch_semaphore_create(1);
        
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                         0,
                                         0,
                                         dispatch_get_main_queue());
        
        dispatch_source_set_timer(_source,
                                  dispatch_time(DISPATCH_TIME_NOW, (start*NSEC_PER_SEC)),
                                  (interval*NSEC_PER_SEC),
                                  0);
        
        __weak typeof(self) weakSelf=self;
        dispatch_source_set_event_handler(_source, ^{
            [weakSelf fire];
        });
        
        dispatch_resume(_source);
    }
    return self;
}

- (void)invalidate{
    LOCK(
         if (_valid) {
             dispatch_source_cancel(_source);
             _source = NULL;
             _target = nil;
             _valid = NO;
         }
    )
}

- (void)fire{
    LOCK(
         [self p_targetPerformSelector];
         if(!_repeats||!_target){
             [self invalidate];
         }
    )
}

- (BOOL)repeats {
    LOCK(BOOL repeat = _repeats;)
    return repeat;
}

- (NSTimeInterval)timeInterval {
    LOCK(NSTimeInterval t = _timeInterval;)
    return t;
}

- (BOOL)isValid {
    LOCK(BOOL valid = _valid;)
    return valid;
}

- (void)dealloc {
    [self invalidate];
}

#pragma mark - private
- (void)p_targetPerformSelector{
    if ([_target respondsToSelector:_selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selector];
#pragma clang diagnostic pop
    }else{
        NSLog(@"KYSTimer:can't responds to selector %@",NSStringFromSelector(_selector));
    }
}

@end
