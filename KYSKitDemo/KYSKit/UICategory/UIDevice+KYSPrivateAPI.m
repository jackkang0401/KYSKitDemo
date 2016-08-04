//
//  UIDevice+KYSPrivateAPI.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/8/4.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UIDevice+KYSPrivateAPI.h"
#include <dlfcn.h>

@implementation UIDevice (KYSPrivateAPI)

- (NSArray *)allInstalledApps{

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
        Class c = NSClassFromString(@"LSApplicationWorkspace");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id s = [(id)c performSelector:NSSelectorFromString(@"defaultWorkspace")];
        NSArray *installedApps=[s performSelector:NSSelectorFromString(@"allInstalledApplications")];
        for (id item in installedApps) {
            //item包含的内容可下下面网址中查看
            //https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/MobileCoreServices.framework/LSApplicationProxy.h
            NSLog(@"%@",[item performSelector:NSSelectorFromString(@"applicationIdentifier")]);
            NSLog(@"%@",[item performSelector:NSSelectorFromString(@"bundleVersion")]);
            NSLog(@"%@",[item performSelector:NSSelectorFromString(@"shortVersionString")]);
        }
#pragma clang diagnostic pop
    }else{
        /*
         链接私有库
         我们知道动态链接库都是写在 Mach-O 的头部。然而它最终是经过 unix 的一个系统函数 dlopen 来加载的，
         这货是可以突破沙盒环境的，不信你可以给 dlopen 下个断点看看。所以我们可以手动调用 dlopen 加载想要
         的私有库
         */
        void* libHandle = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation",RTLD_NOW);
        if(libHandle){
            /*
             对于 C 语言函数来说，他在编译时就被换成了对应的函数指针，所以我们想调用上述方法并没有那么容易。而
             如果是 OC 的方法的话，我们直接通过 runtime 就可以拿到对应的结果
             */
            CFDictionaryRef (*func)(CFDictionaryRef)=dlsym(libHandle, "MobileInstallationLookup");
            if (func) {
                CFDictionaryRef dicRef=func(NULL);
                NSLog(@"%@",(__bridge NSDictionary *)dicRef);
            }
        }
    }
    
    return @[];
}

@end
