//
//  KYSAlertController.m
//  KYSAlertController
//
//  Created by 康永帅 on 2016/10/30.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSAlertController.h"

@interface KYSAlertController()

@property(nonatomic,strong)id alertObject;

@end


@implementation KYSAlertController

+ (instancetype)alertWithType:(UIAlertControllerStyle)type
                        title:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                        block:(KYSAlertControllerActionBlock) block{
    return [[KYSAlertController alloc] initWithType:type title:title message:message buttonTitles:buttonTitles block:block];
}

- (instancetype)initWithType:(UIAlertControllerStyle)type
                       title:(NSString *)title
                     message:(NSString *)message{
    return [self initWithType:type title:title message:message buttonTitles:nil block:nil];
}

- (instancetype)initWithType:(UIAlertControllerStyle)type
                       title:(NSString *)title
                     message:(NSString *)message
                buttonTitles:(NSArray<NSString *> *)buttonTitles
                       block:(KYSAlertControllerActionBlock) block{
    
    self=[super init];
    if (self) {
        self.actionBlock=block;
        self.alertObject=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:type];
        for (int i=0;i<buttonTitles.count;i++) {
            NSString *buttonTitle = buttonTitles[i];
            __weak typeof(self) wSelf=self;
            UIAlertAction *action=[UIAlertAction actionWithTitle:buttonTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             wSelf.actionBlock(i,action);
                                                         }];
            [self.alertObject addAction:action];
        }
    }
    return self;
}


- (void)KYSShow{
    [[self p_activityViewController] presentViewController:self.alertObject animated:YES completion:^{
        
    }];
}

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
