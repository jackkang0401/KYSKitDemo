//
//  KYSAlertView.h
//  KYSAlertView
//
//  Created by Liu Zhao on 16/5/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KYSAlertViewActionBlock)(NSInteger index, id object);

#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0 //系统当前版本
@interface KYSAlertView : UIAlertController
#else
@interface KYSAlertView : UIAlertView
#endif

@property(nonatomic,copy) KYSAlertViewActionBlock actionBlock;

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                  buttonTitles:(NSArray<NSString *> *)buttonTitles
                         block:(KYSAlertViewActionBlock) block;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                        block:(KYSAlertViewActionBlock) block;

- (void)KYSShow;

@end
