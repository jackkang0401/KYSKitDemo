//
//  UIDevice+KYSDeviceInformation.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/8/4.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

//XCode7 iOS9以后的宏未定义
#ifndef NSFoundationVersionNumber_iOS_9_0
#define NSFoundationVersionNumber_iOS_9_0 1240.1
#endif

#ifndef KYSiOS6Later
#define KYSiOS6Later (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0)
#endif

#ifndef KYSiOS7Later
#define KYSiOS7Later (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
#endif

#ifndef KYSiOS8Later
#define KYSiOS8Later (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0)
#endif

#ifndef KYSiOS9Later
#define KYSiOS9Later (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0)
#endif

@interface UIDevice (KYSDeviceInformation)

+ (float)systemVersion;

@property (nonatomic, readonly) BOOL isPad;

@property (nonatomic, readonly) BOOL isSimulator;

@property (nonatomic, readonly) BOOL isJailbroken;//越狱

@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

@property (nonatomic, readonly) NSString *machineModel;

@property (nonatomic, readonly) NSString *machineModelName;

@property (nonatomic, readonly) NSDate *systemUptime;

@end
