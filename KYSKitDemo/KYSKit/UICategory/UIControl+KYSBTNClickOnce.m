//
//  UIControl+KYSBTNClickOnce.m
//  KYSKitDemo
//
//  Created by 康永帅 on 16/8/6.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UIControl+KYSBTNClickOnce.h"
#import <objc/runtime.h>


@interface UIControl()

@property(nonatomic,assign)BOOL kys_ignoreEventFlag;

@end


@implementation UIControl (KYSBTNClickOnce)


+ (void)load{
    Method originInstance=class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method myInstance=class_getInstanceMethod(self, @selector(kys_sendAction:to:forEvent:));
    method_exchangeImplementations(originInstance, myInstance);
}

- (void)kys_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.kys_ignoreEventFlag) {
        return;
    }
    if (self.kys_accentEventTimeInterval > 0) {
        self.kys_ignoreEventFlag=YES;
        [self performSelector:@selector(setKys_ignoreEventFlag:) withObject:@(NO) afterDelay:self.kys_accentEventTimeInterval];
    }
    [self kys_sendAction:action to:target forEvent:event];
}

#pragma mark -  GET SET

- (NSTimeInterval)kys_accentEventTimeInterval{
    // _cmd 当前方法的SEL指针
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setKys_accentEventTimeInterval:(NSTimeInterval)accentEventTimeInterval{
    if (self.kys_ignoreEventFlag) {
        //重置，变为可接收点击事件
        self.kys_ignoreEventFlag=NO;
    }
    objc_setAssociatedObject(self, @selector(kys_accentEventTimeInterval), @(accentEventTimeInterval), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)kys_ignoreEventFlag{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setKys_ignoreEventFlag:(BOOL)ignoreEventFlag{
    objc_setAssociatedObject(self, @selector(kys_ignoreEventFlag), @(ignoreEventFlag), OBJC_ASSOCIATION_RETAIN);
}


@end
