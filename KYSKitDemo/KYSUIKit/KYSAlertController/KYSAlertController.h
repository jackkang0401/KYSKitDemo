//
//  KYSAlertController.h
//  KYSAlertController
//
//  Created by 康永帅 on 2016/10/30.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KYSAlertControllerActionBlock)(NSInteger index, id object);

//iOS8 以后
@interface KYSAlertController : NSObject

@property(nonatomic,copy) KYSAlertControllerActionBlock actionBlock;

+ (instancetype)alertWithType:(UIAlertControllerStyle)type
                        title:(NSString *)title
                       message:(NSString *)message
                  buttonTitles:(NSArray<NSString *> *)buttonTitles
                         block:(KYSAlertControllerActionBlock) block;

- (instancetype)initWithType:(UIAlertControllerStyle)type
                       title:(NSString *)title
                     message:(NSString *)message;

- (instancetype)initWithType:(UIAlertControllerStyle)type
                       title:(NSString *)title
                     message:(NSString *)message
                buttonTitles:(NSArray<NSString *> *)buttonTitles
                       block:(KYSAlertControllerActionBlock) block;

- (void)KYSShow;


@end
