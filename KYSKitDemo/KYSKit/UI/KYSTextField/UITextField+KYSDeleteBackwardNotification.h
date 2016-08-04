//
//  UITextField+KYSDeleteBackwardNotification.h
//  flashServes
//
//  Created by Liu Zhao on 16/5/13.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end

/**
 *  监听删除（回退）按钮
 *  object:UITextField
 */
extern NSString * const KYSTextFieldDidDeleteBackwardNotification;


//监听删除（回退）按钮
//通知 代理都有
@interface UITextField (KYSDeleteBackwardNotification)

@end
