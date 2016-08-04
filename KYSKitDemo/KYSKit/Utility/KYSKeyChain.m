//
//  KYSKeyChain.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSKeyChain.h"

@implementation KYSKeyChain

// 获取数据
+ (NSMutableDictionary *)keychainQuery:(NSString *)key
{
    if (key) {
        return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                (__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,
                key, (__bridge_transfer id)kSecAttrService,
                key, (__bridge_transfer id)kSecAttrAccount,
                (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock, (__bridge_transfer id)kSecAttrAccessible,
                nil];
    }
    
    return nil;
}

// 保存数据
+ (void)saveDataWithKey:(NSString *)key data:(id)data
{
    if (key && data != nil) {
        //Get search dictionary
        NSMutableDictionary *keychainQuery = [self keychainQuery:key];
        //Delete old item before add new item
        SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
        //Add new object to search dictionary(Attention:the data format)
        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
        //Add item to keychain with the search dictionary
        SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    }
}

// 加载数据
+ (id)loadDataWithKey:(NSString *)key
{
    id ret = nil;
    
    if (key) {
        NSMutableDictionary *keychainQuery = [self keychainQuery:key];
        //Configure the search setting
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
        [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
            @try {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
            }
            @catch (NSException *e) {
                NSLog(@"Unarchive of %@ failed: %@", key, e);
            }
            @finally {}
        }
    }
    return ret;
}

// 删除数据
+ (void)deleteDataWithKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self keychainQuery:key];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
