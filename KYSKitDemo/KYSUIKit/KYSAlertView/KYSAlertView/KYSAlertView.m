//
//  KYSAlertView.m
//  KYSAlertView
//
//  Created by Liu Zhao on 16/5/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSAlertView.h"

@interface KYSAlertView()<UIAlertViewDelegate>

@end

@implementation KYSAlertView

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                  buttonTitles:(NSArray<NSString *> *)buttonTitles
                         block:(KYSAlertViewActionBlock) block{
    return [[KYSAlertView alloc] initWithTitle:title message:message buttonTitles:buttonTitles block:block];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message{
    return [self initWithTitle:title message:message buttonTitles:nil block:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                        block:(KYSAlertViewActionBlock) block{
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    //UIAlertController只有类方法
    self=[KYSAlertView alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
#else
    self=[super initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
#endif
    
    if (self) {
        self.actionBlock=block;
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        for (int i=0;i<buttonTitles.count;i++) {
            NSString *buttonTitle = buttonTitles[i];
            __weak typeof(self) wSelf=self;
            UIAlertAction *action=[UIAlertAction actionWithTitle:buttonTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                wSelf.actionBlock(i,action);
            }];
            [self addAction:action];
        }
#else
        self.delegate=self;
        for (NSString *buttonTitle in buttonTitles) {
            [self addButtonWithTitle:buttonTitle];
        }
#endif
        
    }
    return self;
}


- (void)KYSShow{
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    [[self p_activityViewController] presentViewController:self animated:YES completion:^{
        
    }];
#else
    [self show];
#endif
}


#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0



#else
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    __weak typeof (self) wSelf=self;
    self.actionBlock(buttonIndex,wSelf);
}
#endif

#pragma mark - private
// 获取当前处于activity状态的view controller
- (UIViewController *)p_activityViewController{
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows){
            if(tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0){
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            activityViewController = nextResponder;
        }else{
            activityViewController = window.rootViewController;
        }
    }
    return activityViewController;
}


@end
