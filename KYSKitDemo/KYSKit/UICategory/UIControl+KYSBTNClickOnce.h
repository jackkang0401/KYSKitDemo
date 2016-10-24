//
//  UIControl+KYSBTNClickOnce.h
//  KYSKitDemo
//
//  Created by 康永帅 on 16/8/6.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮可以在限定时间内响应一次
@interface UIControl (KYSBTNClickOnce)

@property(nonatomic,assign)NSTimeInterval kys_accentEventTimeInterval;

@end
