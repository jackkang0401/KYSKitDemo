//
//  KYSPickerView.h
//  flashServes
//
//  Created by Liu Zhao on 16/5/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSPickerViewDelegate;
@protocol KYSPickerViewDateDataSource;
@protocol KYSPickerViewNormalDataSource;

typedef NS_ENUM(NSInteger,KYSPickerViewType){
    KYSPickerViewNormal = 0, //普通
    KYSPickerViewDate = 1    //时间
};

@interface KYSPickerView : UIView

@property(nonatomic,weak)id<KYSPickerViewDelegate> delegate;
@property(nonatomic,weak)id<KYSPickerViewDateDataSource> dateDataSource;
@property(nonatomic,weak)id<KYSPickerViewNormalDataSource> normalDataSource;


//frame 为父视图的frame
- (instancetype)initWithFrame:(CGRect)frame type:(KYSPickerViewType)type;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

@end


@protocol KYSPickerViewDelegate <NSObject>

@optional
/*
 普通类型：返回对应component的数组
 时间类型：返回NSdate对象
 */
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object;

@end

//KYSPickerViewNormal implementation
@protocol KYSPickerViewNormalDataSource <NSObject>

@required
//默认 @[]
- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;

@optional
//时间pickerView无效，默认是1，可不设置
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView;

- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;

@end


//KYSPickerViewDate implementation
@protocol KYSPickerViewDateDataSource <NSObject>

@optional
- (NSDate *)currentDateKYSPickerView:(KYSPickerView *)pickerView;
- (NSDate *)minDateKYSPickerView:(KYSPickerView *)pickerView;
- (NSDate *)maxDateKYSPickerView:(KYSPickerView *)pickerView;

@end













