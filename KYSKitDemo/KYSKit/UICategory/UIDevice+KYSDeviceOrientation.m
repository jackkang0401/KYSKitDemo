//
//  UIDevice+KYSDeviceOrientation.m
//  RealTimeBus
//
//  Created by 康永帅 on 2017/4/12.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "UIDevice+KYSDeviceOrientation.h"
#import <objc/runtime.h>
#import <CoreMotion/CoreMotion.h>

@implementation UIDevice (KYSDeviceOrientation)

#pragma mark - CoreMotion
/*
    1.[UIDevice currentDevice].orientation 可直接获取当前屏幕方向
 
    2.使用 UIDeviceOrientationDidChangeNotification 通知获取屏幕方向。如
 果用户没有开启屏幕旋转，当前设备无法接收到通知。因为锁定屏幕之后，系统会默认当前
 的屏幕状态一直都是锁屏时的状态
 
    3.这里使用螺旋仪和加速器来判断屏幕方向。需要先引入 CoreMotion.frameWork
 */
+ (void)kys_useCoreMotionMonitorOrirntionUsingBlock:(void(^)(UIInterfaceOrientation orientation,NSError *error))callBackBlock{
    //感觉用局部变量有问题
    CMMotionManager *motionManager = [[UIDevice currentDevice] kys_motionManager];
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            UIInterfaceOrientation orientation=UIInterfaceOrientationPortrait;
                                            if (!error) {
                                               orientation = [self kys_outputAccelertionData:accelerometerData.acceleration];
                                            }else{
                                                NSLog(@"%@", error);
                                            }
                                            if (callBackBlock) {
                                                callBackBlock(orientation,error);
                                            }
                                        }];
}

- (CMMotionManager *)kys_motionManager{
    CMMotionManager *motionManager=objc_getAssociatedObject(self, _cmd);
    if (!motionManager) {
        motionManager = [[CMMotionManager alloc] init];
        [self kys_setMotionManage:motionManager];
    }
    return motionManager;
}

- (void)kys_setMotionManage:(CMMotionManager *)motionManage{
    objc_setAssociatedObject(self, @selector(kys_motionManager), motionManage, OBJC_ASSOCIATION_RETAIN);
}

+ (UIInterfaceOrientation )kys_outputAccelertionData:(CMAcceleration)acceleration{
    if (acceleration.x >= 0.75) {
        return UIInterfaceOrientationLandscapeLeft;
    }else if (acceleration.x <= -0.75) {
        return UIInterfaceOrientationLandscapeRight;
    }else if (acceleration.y <= -0.75) {
        return UIInterfaceOrientationPortrait;
    }else if (acceleration.y >= 0.75) {
        return UIInterfaceOrientationPortraitUpsideDown;
    }
    return UIInterfaceOrientationPortrait;
}

@end
