//
//  NSTimer+KYSBlocksSupport.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSTimer+KYSBlocksSupport.h"

@implementation NSTimer (KYSBlocksSupport)

+ (NSTimer *)scheduledTmerWithTimeInterval:(NSTimeInterval) interval
                                     block:(void(^)())block
                                   repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
    
}

+ (void)blockInvoke:(NSTimer *)timer
{
    void(^block)()=timer.userInfo;
    if (block) {
        block();
    }
}

@end
