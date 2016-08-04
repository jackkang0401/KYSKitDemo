//
//  UIDevice+KYSCPU.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/8/4.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (KYSCPU)

@property (nonatomic, readonly) NSUInteger cpuCount;

//当前CPU使用率（0.0~1.0）
@property (nonatomic, readonly) float cpuUsage;

//当前CPU每个处理器的使用率
@property (nonatomic, readonly) NSArray *cpuUsagePerProcessor;

@end
