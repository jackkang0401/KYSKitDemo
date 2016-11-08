//
//  KYSDatePickerView.h
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSDatePickerViewDelegate;
@protocol KYSDatePickerViewDataSource;

@interface KYSDatePickerView : UIView

@property(nonatomic,weak)id<KYSDatePickerViewDelegate> delegate;
@property(nonatomic,weak)id<KYSDatePickerViewDataSource> dateDataSource;


//frame 为父视图的frame
- (instancetype)initWithFrame:(CGRect)frame;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

@end


@protocol KYSDatePickerViewDelegate <NSObject>

@optional
/*
 普通类型：返回对应component的数组
 时间类型：返回NSdate对象
 */
- (void)KYSDatePickerView:(KYSDatePickerView *)pickerView selectedObject:(id)object;

- (void)cancelWithDatePickerView:(KYSDatePickerView *)pickerView;

@end

//KYSPickerViewDate implementation
@protocol KYSDatePickerViewDataSource <NSObject>

@optional
- (NSDate *)currentDateKYSDatePickerView:(KYSDatePickerView *)pickerView;
- (NSDate *)minDateKYSDatePickerView:(KYSDatePickerView *)pickerView;
- (NSDate *)maxDateKYSDatePickerView:(KYSDatePickerView *)pickerView;

@end
