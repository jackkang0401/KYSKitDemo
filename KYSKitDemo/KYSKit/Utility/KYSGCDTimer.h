//
//  KYSGCDTimer.h
//  KYSKitDemo
//
//  Created by 康永帅 on 16/8/6.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

//需要被强引用，释放定时器也会失效
@interface KYSGCDTimer : NSObject

+ (KYSGCDTimer *)scheduledTmerWithTimeInterval:(NSTimeInterval) interval
                                         queue:(dispatch_queue_t)queue
                                         block:(dispatch_block_t)block
                                       repeats:(BOOL)repeats;

- (void)fire;

- (void)suspend;

- (void)invalidate;

@end
