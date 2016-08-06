//
//  KYSGCDTimer.m
//  KYSKitDemo
//
//  Created by 康永帅 on 16/8/6.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSGCDTimer.h"

@interface KYSGCDTimer()

@property(nonatomic,strong)dispatch_source_t timer;

@end


@implementation KYSGCDTimer

+ (KYSGCDTimer *)scheduledTmerWithTimeInterval:(NSTimeInterval) interval
                                         queue:(dispatch_queue_t)queue
                                         block:(dispatch_block_t)block
                                       repeats:(BOOL)repeats
{
    
    return [[self alloc] initWithTimeInterval:interval queue:queue block:block repeats:repeats];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval) interval
                               queue:(dispatch_queue_t)queue
                               block:(dispatch_block_t)block
                             repeats:(BOOL)repeats
{
    self=[super init];
    if (self) {
        queue = queue ?: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);//timer精度为0.1秒
        
        //timer精度为0.1秒
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        
        __weak typeof(self) wSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            block();
            if (!repeats) {
                [wSelf invalidate];
            }
        });
        
        dispatch_resume(_timer);
    }
    return self;
}

- (void)fire{
    if (_timer) {
        dispatch_resume(_timer);
    }
}

- (void)suspend{
    if (_timer) {
        dispatch_suspend(_timer);
    }
}

- (void)invalidate{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = NULL;
    }
}

- (void)dealloc{
    NSLog(@"KYSGCDTimer dealloc");
    if (_timer) {
        [self invalidate];
        _timer=nil;
    }
}

@end
