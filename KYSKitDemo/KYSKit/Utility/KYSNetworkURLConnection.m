//
//  KYSNetworkURLConnection.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNetworkURLConnection.h"

@implementation KYSNetworkURLConnection

+ (NSString *)getParamsStringWithParams:(NSDictionary *)params
{
    NSLog(@"getParamsString");
    NSString *paramsStr = @"";
    //    NSLog(@"%@",params);
    //    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //        NSString *str = [NSString stringWithFormat:@"%@=%@&",key,obj];
    //        NSLog(@"%@",str);
    //        paramsStr = [paramsStr stringByAppendingString:str];
    //    }];
    
    NSArray *keyArray=[params allKeys];
    for (NSString *key in keyArray) {
        NSString *str = [NSString stringWithFormat:@"%@=%@&",key,params[key]];
        //NSLog(@"%@",str);
        paramsStr = [paramsStr stringByAppendingString:str];
    }
    return paramsStr.length?[paramsStr substringToIndex:paramsStr.length-1]:paramsStr;
}

+ (NSURL *)getGETUrlWithStr:(NSString *)baseStr param:(NSDictionary *)params
{
    NSLog(@"getGETUrl");
    NSString *paramsStr = [self getParamsStringWithParams:params];
    if (paramsStr.length) {
        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[baseStr stringByAppendingFormat:@"?%@",paramsStr],NULL,NULL,kCFStringEncodingUTF8));
        return [NSURL URLWithString:encodedString];
    }
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,NULL,kCFStringEncodingUTF8));
    return [NSURL URLWithString:encodedString];
}

+ (NSURL *)getPOSTUrlWithStr:(NSString *)baseStr
{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,NULL,kCFStringEncodingUTF8));
    return [NSURL URLWithString:encodedString];
}

//同步GET请求
+ (NSData *)getSynchronousWithBaseURL:(NSString *)strURL params:(NSDictionary *)params
{
    NSURL *url=[self getGETUrlWithStr:strURL param:params];
    //NSLog(@"Start synchronous request:%@",url);
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    //创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(@"%@ ,Result:%@",url.absoluteString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return data;
}

//同步POST请求
+ (NSData *)postSynchronousWithBaseURL:(NSString *)strURL params:(NSDictionary *)params
{
    NSURL *url=[self getPOSTUrlWithStr:strURL];
    //NSLog(@"Start synchronous request:%@",url);
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //将字符串转为NSData对象
    NSData *pramData = [[self getParamsStringWithParams:params] dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求体
    [request setHTTPBody:pramData];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    // 创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"%@ ,Result:%@",url.absoluteString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return data;
}

//异步GET请求
+ (void)getAsynchronousWithBaseURL:(NSString *)strURL
                            params:(NSDictionary *)params
                          complete:(void (^)(id result,NSError *error))complete
{
    NSURL *url=[self getGETUrlWithStr:strURL param:params];
    //NSLog(@"Start asynchronous request:%@",url);
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //创建异步链接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@: Error",url.absoluteString);
            complete(nil,connectionError);
            return;
        }
        if (response && [(NSHTTPURLResponse *)response statusCode] == 200) {
            //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //NSLog(@"%@ ,Result:%@",url.absoluteString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            complete(data,nil);
            return;
        }
        complete(nil,nil);
    }];
}

//异步POST请求
+ (void)postAsynchronousWithBaseURL:(NSString *)strURL
                             params:(NSDictionary *)params
                           complete:(void (^)(id result,NSError *error))complete
{
    NSURL *url=[self getPOSTUrlWithStr:strURL];
    //NSLog(@"Start asynchronous request:%@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSData *pramData = [[self getParamsStringWithParams:params] dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求体
    [request setHTTPBody:pramData];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //创建异步链接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@: Error",url.absoluteString);
            complete(nil,connectionError);
            return;
        }
        if (response && [(NSHTTPURLResponse *)response statusCode] == 200) {
            //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //NSLog(@"%@ ,Result:%@",url.absoluteString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            complete(data,nil);
            return;
        }
        complete(nil,nil);
    }];
}

@end
