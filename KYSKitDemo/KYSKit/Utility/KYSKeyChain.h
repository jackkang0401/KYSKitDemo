//
//  KYSKeyChain.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

//卸载应用也不会删除数据
@interface KYSKeyChain : NSObject

// 保存数据
+ (void)saveDataWithKey:(NSString *)key data:(id)data;

// 加载数据
+ (id)loadDataWithKey:(NSString *)key;

// 删除数据
+ (void)deleteDataWithKey:(NSString *)key;

@end
