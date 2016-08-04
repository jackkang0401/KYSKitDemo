//
//  NSTimer+KYSBlocksSupport.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (KYSBlocksSupport)

+ (NSTimer *)scheduledTmerWithTimeInterval:(NSTimeInterval) interval
                                     block:(void(^)())block
                                   repeats:(BOOL)repeats;

@end
