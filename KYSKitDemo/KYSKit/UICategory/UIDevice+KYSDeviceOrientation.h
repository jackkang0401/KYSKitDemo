//
//  UIDevice+KYSDeviceOrientation.h
//  RealTimeBus
//
//  Created by 康永帅 on 2017/4/12.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (KYSDeviceOrientation)

//使用 CoreMotion 监听屏幕方向
+ (void)kys_useCoreMotionMonitorOrirntionUsingBlock:(void(^)(UIInterfaceOrientation orientation,NSError *error))callBackBlock;

@end
