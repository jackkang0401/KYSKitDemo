//
//  KYSPathHelper.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYSPathHelper : NSObject

+ (BOOL)createPathIfNecessary:(NSString*)path;

+ (NSString*)documentDirectoryPathWithName:(NSString*)name;

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name;

//存放临时文件
+ (NSString *)downloadTempCachePathWithDirectory:(NSString *)directory name:(NSString*)name;

//存放最终文件
+ (NSString *)downloadDocumentPathWithDirectoryPathDirectory:(NSString *)directory name:(NSString*)name;

//得到存放临时文件
+ (NSString *)downloadTempCachePathWithDirectory:(NSString *)directory;

//得到存放最终文件目录
+ (NSString *)downloadDocumentPathWithDirectoryPathDirectory:(NSString *)directory;

//删除此目录下的全部文件
+ (void)deleteAllFileWithDirectory:(NSString *)directoryPath;

@end
