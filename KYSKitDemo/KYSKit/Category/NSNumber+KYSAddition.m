//
//  NSNumber+KYSAddition.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSNumber+KYSAddition.h"

#if __has_include("NSString+KYSAddition.h")
#define KYS_HAS_NSString_KYSAddition 1
#import "NSString+KYSAddition.h"
#else
#define KYS_HAS_NSString_KYSAddition 0
#endif

@implementation NSNumber (KYSAddition)

+ (NSNumber *)numberWithString:(NSString *)string {
    
#if KYS_HAS_NSString_KYSAddition
    NSString *str = [string stringByTrim];//去掉空格与换行
#else
    NSString *str = [[self p_trimmingCharactersWithStr:string] lowercaseString];//去掉空格与换行
#endif
    
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

#pragma mark - private
//去掉空格与换行(#import "NSString+KYSAddition.h")
#if 0 == KYS_HAS_NSString_KYSAddition
+ (NSString *)p_trimmingCharactersWithStr:(NSString *)str {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [str stringByTrimmingCharactersInSet:set];
}
#endif

@end
