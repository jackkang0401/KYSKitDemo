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

- (instancetype)initWithFrame:(CGRect)frame type:(KYSPickerViewType)type;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

@end


@protocol KYSPickerViewDelegate <NSObject>

@optional
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object;

@end

//KYSPickerViewNormal implementation
@protocol KYSPickerViewNormalDataSource <NSObject>

@required
- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView;

@optional
- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView;

@end


//KYSPickerViewDate implementation
@protocol KYSPickerViewDateDataSource <NSObject>

@optional
- (NSDate *)currentDateKYSPickerView:(KYSPickerView *)pickerView;

@end














