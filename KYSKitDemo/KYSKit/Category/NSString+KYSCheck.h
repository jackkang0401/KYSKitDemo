//
//  NSString+KYSCheck.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/9/5.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KYSCheck)

//密码合法性
//6-16字符，包括英文、数字、下划线组合，区分大小写
- (BOOL)isValidatePassword;

//电话号码合法性
- (BOOL)isMobileNumber;

@end
