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

typedef void (^KYSPickerViewHide)();

@interface KYSPickerView : UIView

@property(nonatomic,weak)id<KYSPickerViewDelegate> delegate;
@property(nonatomic,weak)id<KYSPickerViewDataSource> normalDataSource;


//frame 为父视图的frame
- (instancetype)initWithFrame:(CGRect)frame;

- (void)KYSShow;

- (void)KYSShowWithHideBlock:(KYSPickerViewHide)block;

//隐藏后移除
- (void)KYSHide;

//隐藏后是否从父视图移除
- (void)KYSHideNeedRemove:(BOOL)needRemove;

- (void)KYSReloadData;

@end

#pragma mark - KYSPickerViewDelegate

@protocol KYSPickerViewDelegate <NSObject>

@optional

- (void)cancelWithPickerView:(KYSPickerView *)pickerView;

//返回选中的index数组
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedIndexArray:(NSArray *)selectedIndexArray;

- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


#pragma mark - KYSPickerViewNormalDataSource

@protocol KYSPickerViewDataSource <NSObject>

@required
//默认 @[]
- (NSArray *)KYSPickerView:(KYSPickerView *)pickerView dataInComponent:(NSInteger)component;

@optional
//时间pickerView无效，默认是1，可不设置
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView;

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView selectedIndexInComponent:(NSInteger)component;

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView widthForComponent:(NSInteger)component;

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

@end









