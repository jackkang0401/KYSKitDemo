//
//  UITextField+KYSDeleteBackwardNotification.m
//  flashServes
//
//  Created by Liu Zhao on 16/5/13.
//  Copyright © 2016年 002. All rights reserved.
//

#import "UITextField+KYSDeleteBackwardNotification.h"
#import <objc/runtime.h>

NSString * const KYSTextFieldDidDeleteBackwardNotification = @"com.whojun.textfield.did.notification";

@implementation UITextField (KYSDeleteBackwardNotification)

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(kys_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)kys_deleteBackward {
    [self kys_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]){
        id <KYSTextFieldDelegate> delegate  = (id<KYSTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KYSTextFieldDidDeleteBackwardNotification object:self];
}

@end
