//
//  KYSPathHelper.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSPathHelper.h"

@implementation KYSPathHelper

+ (BOOL)createPathIfNecessary:(NSString*)path {
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    return succeeded;
}

+ (NSString*)documentDirectoryPathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
    NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
    
    [KYSPathHelper createPathIfNecessary:cachesPath];
    [KYSPathHelper createPathIfNecessary:cachePath];
    
    return cachePath;
}

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
    NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
    
    [KYSPathHelper createPathIfNecessary:cachesPath];
    [KYSPathHelper createPathIfNecessary:cachePath];
    
    return cachePath;
}

//存放临时文件
+ (NSString *)downloadTempCachePathWithDirectory:(NSString *)directory name:(NSString*)name
{
    NSString  *tempDoucment = NSTemporaryDirectory();
    //    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    //    NSRange lastCharRange = [paramFilePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    //    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",tempDoucment,[paramFilePath substringFromIndex:lastCharRange.location + 1]];
    
    //NSString *tempFilePath = [NSString stringWithFormat:@"%@pdf/%@.temp",tempDoucment,name];
    
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@",tempDoucment,directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tempFilePath]){
        NSLog(@"创建临时文件目录");
        [fileManager createDirectoryAtPath:tempFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    tempFilePath = [NSString stringWithFormat:@"%@/%@.temp",tempFilePath,name];
    return tempFilePath;
}

//存放最终文件
+ (NSString *)downloadDocumentPathWithDirectoryPathDirectory:(NSString *)directory name:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *documentFilePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",directory]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentFilePath]){
        NSLog(@"创建文件目录");
        [fileManager createDirectoryAtPath:documentFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    documentFilePath = [NSString stringWithFormat:@"%@/%@",documentFilePath,name];
    return documentFilePath;
}

//得到存放临时文件目录
+ (NSString *)downloadTempCachePathWithDirectory:(NSString *)directory
{
    NSString  *tempDoucment = NSTemporaryDirectory();
    //    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    //    NSRange lastCharRange = [paramFilePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    //    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",tempDoucment,[paramFilePath substringFromIndex:lastCharRange.location + 1]];
    
    //NSString *tempFilePath = [NSString stringWithFormat:@"%@pdf/%@.temp",tempDoucment,name];
    
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@",tempDoucment,directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tempFilePath]){
        [fileManager createDirectoryAtPath:tempFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tempFilePath;
}

//得到存放最终文件目录
+ (NSString *)downloadDocumentPathWithDirectoryPathDirectory:(NSString *)directory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *documentFilePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",directory]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentFilePath]){
        [fileManager createDirectoryAtPath:documentFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentFilePath;
}

//删除此目录下的全部文件
+ (void)deleteAllFileWithDirectory:(NSString *)directoryPath
{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    NSString *fileName;
    while (fileName= [dirEnum nextObject]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",directoryPath,fileName] error:nil];
    }
}

@end
