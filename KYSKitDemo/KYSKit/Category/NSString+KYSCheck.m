//
//  NSString+KYSCheck.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/9/5.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSString+KYSCheck.h"

@implementation NSString (KYSCheck)

//密码合法性
//6-16字符，包括英文、数字、下划线组合，区分大小写
- (BOOL)isValidatePassword{
    NSString *PASSWORD = @"^[A-Za-z0-9!@#$%^&*()_-]{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
