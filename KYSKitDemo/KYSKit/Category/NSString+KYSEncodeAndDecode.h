//
//  NSString+KYSEncodeAndDecode.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/9/5.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KYSEncodeAndDecode)

+ (NSString *)jsonWebTokenWithHeader:(NSDictionary *)header
                             payload:(NSDictionary *)payload
                      signatureBlock:(NSString *(^)(NSString *base64Header,NSString *base64Paylod))signatureBlock;

#pragma mark - 返回的都是小写的编码
- (NSString *)md2String;

- (NSString *)md4String;

- (NSString *)md5String;

- (NSString *)sha1String;

- (NSString *)sha224String;

- (NSString *)sha256String;

- (NSString *)sha384String;

- (NSString *)sha512String;

- (NSString *)hmacMD5StringWithKey:(NSString *)key;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

- (NSString *)crc32String;


#pragma mark - Encode And Decode
- (NSString *)base64EncodedString;

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

/**
 Escape common HTML to Entity.
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)stringByEscapingHTML;

@end
