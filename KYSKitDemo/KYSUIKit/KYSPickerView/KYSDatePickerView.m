//
//  KYSDatePickerView.m
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSDatePickerView.h"
#import "NSDate+KYSAddition.h"

@interface KYSDatePickerView()

@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIDatePicker *datePicker;

@end


@implementation KYSDatePickerView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
        //黑色半透明北京
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180);
        _selectView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_selectView];
        
        //左侧取消按钮
        UIButton *btn1=[[UIButton alloc] init];
        btn1.tag=1;
        btn1.frame=CGRectMake(0, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
        //右侧确定按钮
        UIButton *btn2=[[UIButton alloc] init];
        btn2.tag=2;
        btn2.frame=CGRectMake(self.frame.size.width-50, 0, 50, 40);
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        btn2.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn2];
        
        [self p_setPickerView];
        
    }
    return self;
}


- (void)KYSShow{
    self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 180);
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame)-180, CGRectGetWidth(self.frame), 180);
    } completion:^(BOOL finished) {
        //CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180)
    }];
}

- (void)KYSHide{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 180);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)KYSReloadData{
    // 默认日期
    _datePicker.date =[self p_getCurrentDate];
    // 最小时间
    _datePicker.minimumDate=[self p_getMinDate];
    // 最大时间
    _datePicker.maximumDate=[self p_getMaxDate];
}

- (void)setDateDataSource:(id<KYSDatePickerViewDataSource>)dateDataSource{
    _dateDataSource=dateDataSource;
    [self KYSReloadData];
}

#pragma mark - Action
- (void)tap{
    if ([_delegate respondsToSelector:@selector(cancelWithDatePickerView:)]) {
        [_delegate cancelWithDatePickerView:self];
    }
    [self KYSHide];
}

- (void)btnAction:(UIButton *)btn{
    if(2==btn.tag){
        [self p_getSelected];
    }else if(1==btn.tag){
        if ([_delegate respondsToSelector:@selector(cancelWithDatePickerView:)]) {
            [_delegate cancelWithDatePickerView:self];
        }
    }
    [self KYSHide];
}


#pragma mark - private
- (void)p_setPickerView{
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:self.datePicker];
}

- (void)p_getSelected{
    if ([_delegate respondsToSelector:@selector(KYSDatePickerView:selectedObject:)]) {
        [_delegate KYSDatePickerView:self selectedObject:_datePicker.date];
    }
}

//// 获取当前处于activity状态的view controller
//- (UIViewController *)p_activityViewController{
//    UIViewController* activityViewController = nil;
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if(window.windowLevel != UIWindowLevelNormal){
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow *tmpWin in windows){
//            if(tmpWin.windowLevel == UIWindowLevelNormal){
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    NSArray *viewsArray = [window subviews];
//    if([viewsArray count] > 0){
//        UIView *frontView = [viewsArray objectAtIndex:0];
//        id nextResponder = [frontView nextResponder];
//        if([nextResponder isKindOfClass:[UIViewController class]]){
//            activityViewController = nextResponder;
//        }else{
//            activityViewController = window.rootViewController;
//        }
//    }
//    return activityViewController;
//}

#pragma mark - KYSPickerViewDateDataSource
- (NSDate *)p_getCurrentDate{
    if ([_dateDataSource respondsToSelector:@selector(currentDateKYSDatePickerView:)]) {
        return [_dateDataSource currentDateKYSDatePickerView:self];
    }
    return [NSDate date];
}

- (NSDate *)p_getMinDate{
    if ([_dateDataSource respondsToSelector:@selector(minDateKYSDatePickerView:)]) {
        return [_dateDataSource minDateKYSDatePickerView:self];
    }
    return [NSDate dateWithString:@"1990-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
}

- (NSDate *)p_getMaxDate{
    if ([_dateDataSource respondsToSelector:@selector(maxDateKYSDatePickerView:)]) {
        return [_dateDataSource maxDateKYSDatePickerView:self];
    }
    return [NSDate date];
}

@end
