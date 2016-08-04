//
//  KYSTimer.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYSTimer:NSObject

+ (KYSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          selector:(SEL)selector
                           repeats:(BOOL)repeats;

- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats NS_DESIGNATED_INITIALIZER;

@property (nonatomic,readonly) BOOL repeats;
@property (nonatomic,readonly) NSTimeInterval timeInterval;
@property (nonatomic,readonly, getter=isValid) BOOL valid;

- (void)invalidate;

- (void)fire;

@end
