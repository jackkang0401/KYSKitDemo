//
//  NSString+KYSEncodeAndDecode.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/9/5.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "NSString+KYSEncodeAndDecode.h"

#if __has_include("NSData+KYSAddition.h")
#define KYS_HAS_NSData_KYSAddition 1
#import "NSData+KYSAddition.h"
#else
#define KYS_HAS_NSData_KYSAddition 0
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>
#endif

#if __has_include("NSDictionary+KYSAddition.h")
#define KYS_HAS_NSDictionary_KYSAddition 1
#import "NSDictionary+KYSAddition.h"
#else
#define KYS_HAS_NSDictionary_KYSAddition 0
#endif

@implementation NSString (KYSEncodeAndDecode)

+ (NSString *)jsonWebTokenWithHeader:(NSDictionary *)header
                             payload:(NSDictionary *)payload
                      signatureBlock:(NSString *(^)(NSString *base64Header,NSString *base64Paylod))signatureBlock{
    //先转为json，转为base64
#if KYS_HAS_NSDictionary_KYSAddition
    NSString *headerBase64String=[[header jsonStringEncoded] base64EncodedString];
#else
    NSString *headerBase64String=[[self p_jsonStringEncoded:header] base64EncodedString];
#endif
    if (!headerBase64String) {
        //NSLog(@"header 编码出错");
        return nil;
    }
#if KYS_HAS_NSDictionary_KYSAddition
    NSString *payloadBase64String=[[payload jsonStringEncoded] base64EncodedString];
#else
    NSString *payloadBase64String=[[self p_jsonStringEncoded:payload] base64EncodedString];
#endif
    if (!payloadBase64String) {
        //NSLog(@"paylod 编码出错");
        return nil;
    }
    //连接并进行sha1编码
    NSString *signature=signatureBlock(headerBase64String,payloadBase64String);
    if (!signature) {
        //NSLog(@"签名编码出错");
        return nil;
    }
    //生成 json web token
    NSString *jsonWebToken=[@[headerBase64String,payloadBase64String,signature] componentsJoinedByString:@"."];
    return jsonWebToken;
}

- (NSString *)md2String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md2String];
#else
    return [self p_md2StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)md4String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md4String];
#else
    return [self p_md4StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)md5String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
#else
    return [self p_md5StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)sha1String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
#else
    return [self p_sha1StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)sha224String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224String];
#else
    return [self p_sha224StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)sha256String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
#else
    return [self p_sha256StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)sha384String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384String];
#else
    return [self p_sha384StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)sha512String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512String];
#else
    return [self p_sha512StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)crc32String {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] crc32String];
#else
    return [self p_crc32StringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
}

- (NSString *)hmacMD5StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacMD5StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgMD5
                              withKey:key];
#endif
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA1StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgSHA1
                              withKey:key];
#endif
}

- (NSString *)hmacSHA224StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA224StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgSHA224
                              withKey:key];
#endif
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA256StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgSHA256
                              withKey:key];
#endif
}

- (NSString *)hmacSHA384StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA384StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgSHA384
                              withKey:key];
#endif
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA512StringWithKey:key];
#else
    return [self p_hmacStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                  alg:kCCHmacAlgSHA512
                              withKey:key];
#endif
}

- (NSString *)base64EncodedString {
#if KYS_HAS_NSData_KYSAddition
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
#else
    return [self p_base64EncodedStringWithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
#endif
    
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
#if KYS_HAS_NSData_KYSAddition
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
#else
    NSData *data = [self p_dataWithBase64EncodedString:base64EncodedString];
#endif
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

#pragma mark - private

#if 0 == KYS_HAS_NSDictionary_KYSAddition

+ (NSString *)p_jsonStringEncoded:(NSDictionary *)dic {
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

#endif

#if 0 == KYS_HAS_NSData_KYSAddition
- (NSString *)p_md2StringWithData:(NSData *)data {
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)p_md4StringWithData:(NSData *)data {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)p_md5StringWithData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)p_sha1StringWithData:(NSData *)data {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)p_sha224StringWithData:(NSData *)data {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)p_sha256StringWithData:(NSData *)data {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)p_sha384StringWithData:(NSData *)data {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)p_sha512StringWithData:(NSData *)data {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)p_crc32StringWithData:(NSData *)data {
    uLong result = crc32(0, data.bytes, (uInt)data.length);
    return [NSString stringWithFormat:@"%08x", (uint32_t)result];
}

- (NSString *)p_hmacStringWithData:(NSData *)data alg:(CCHmacAlgorithm)alg withKey:(NSString *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), data.bytes, data.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}


static const char base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2,  -1,  -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62,  -2,  -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2,  -2,  -2, -2, -2,
    -2, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2,  -2,  -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2
};

- (NSString *)p_base64EncodedStringWithData:(NSData *)data {
    NSUInteger length = self.length;
    if (length == 0)
        return @"";
    
    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = malloc(((out_length + 2) / 3) * 4);
    if (output == NULL)
        return nil;
    
    const char *input = data.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? base64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? base64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }
    
    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}

+ (NSData *)p_dataWithBase64EncodedString:(NSString *)base64EncodedString {
    NSInteger length = base64EncodedString.length;
    const char *string = [base64EncodedString cStringUsingEncoding:NSASCIIStringEncoding];
    if (string  == NULL)
        return nil;
    
    while (length > 0 && string[length - 1] == '=')
        length--;
    
    NSInteger outputLength = length * 3 / 4;
    NSMutableData *data = [NSMutableData dataWithLength:outputLength];
    if (data == nil)
        return nil;
    if (length == 0)
        return data;
    
    uint8_t *output = data.mutableBytes;
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < length) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < length ? string[inputPoint++] : 'A';
        char i3 = inputPoint < length ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (base64DecodingTable[i0] << 2)
        | (base64DecodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((base64DecodingTable[i1] & 0xf) << 4)
            | (base64DecodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((base64DecodingTable[i2] & 0x3) << 6)
            | base64DecodingTable[i3];
        }
    }
    
    return data;
}

- (id)p_jsonValueDecodedWithData:(NSData *)data {
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}

#endif

@end
