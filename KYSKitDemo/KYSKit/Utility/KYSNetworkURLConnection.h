//
//  KYSNetworkURLConnection.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYSNetworkURLConnection : NSObject

//同步GET请求
+ (NSData *)getSynchronousWithBaseURL:(NSString *)strURL params:(NSDictionary *)params;

//同步POST请求
+ (NSData *)postSynchronousWithBaseURL:(NSString *)strURL params:(NSDictionary *)params;

//异步GET请求
+ (void)getAsynchronousWithBaseURL:(NSString *)strURL
                            params:(NSDictionary *)params
                          complete:(void (^)(id result,NSError *error))complete;

//异步POST请求
+ (void)postAsynchronousWithBaseURL:(NSString *)strURL
                             params:(NSDictionary *)params
                           complete:(void (^)(id result,NSError *error))complete;

@end
