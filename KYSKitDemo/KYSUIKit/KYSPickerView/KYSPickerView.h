//
//  KYSPickerView.h
//  flashServes
//
//  Created by Liu Zhao on 16/5/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSPickerViewDelegate;
@protocol KYSPickerViewDataSource;

@interface KYSPickerView : UIView

@property(nonatomic,weak)id<KYSPickerViewDelegate> delegate;
@property(nonatomic,weak)id<KYSPickerViewDataSource> normalDataSource;


//frame 为父视图的frame
- (instancetype)initWithFrame:(CGRect)frame;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

@end

#pragma mark - KYSPickerViewDelegate

@protocol KYSPickerViewDelegate <NSObject>

@optional
/*
 普通类型：返回对应component的数组
 时间类型：返回NSdate对象
 */
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object;

- (void)cancelWithPickerView:(KYSPickerView *)pickerView;

- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


#pragma mark - KYSPickerViewNormalDataSource

@protocol KYSPickerViewDataSource <NSObject>

@required
//默认 @[]
- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;

@optional
//时间pickerView无效，默认是1，可不设置
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView;

- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;

@end









