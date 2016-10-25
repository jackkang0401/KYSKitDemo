//
//  NSString+KYSCheck.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/9/5.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSString+KYSCheck.h"

//6-16字符，包括英文、数字、下划线组合，区分大小写
NSString *const KYS_CHECK_PASSWORD = @"^[A-Za-z0-9!@#$%^&*()_-]{6,16}$";

//电话号码
NSString *const KYS_CHECK_MOBLIE_NUMBER = @"^[1][34578][0-9]{9}$";

//是否为英文
NSString *const KYS_CHECK_ENGLISH = @"^[A-Za-z]+$";

//是否为中文
NSString *const KYS_CHECK_CHINESE = @"^[\u4E00-\u9FA5]+$";

//是否为中文与英文组合
NSString *const KYS_CHECK_CHINESE_ENGLISH = @"^[A-Za-z\u4E00-\u9FA5]+$";




@implementation NSString (KYSCheck)

//密码合法性
- (BOOL)isValidatePassword{
    return [self p_checkWithString:KYS_CHECK_PASSWORD];
}

//电话号码合法性
- (BOOL)isMobileNumber{
    return [self p_checkWithString:KYS_CHECK_MOBLIE_NUMBER];
}

//英文
- (BOOL)isEnglish{
    return [self p_checkWithString:KYS_CHECK_ENGLISH];
}

//中文
- (BOOL)isChinese{
    return [self p_checkWithString:KYS_CHECK_CHINESE];
}

//中文和英文
- (BOOL)isChineseAndEnglish{
    return [self p_checkWithString:KYS_CHECK_CHINESE_ENGLISH];
}


- (BOOL)p_checkWithString:(NSString *)string{
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
