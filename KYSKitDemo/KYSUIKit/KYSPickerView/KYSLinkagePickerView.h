//
//  KYSLinkagePickerView.h
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray* (^KYSLinkagePickerViewAnalyzeOriginData)();

typedef void (^KYSLinkagePickerViewCompleteSelected)(NSArray *);

@interface KYSLinkagePickerView : UIView

//类方法直接显示
+ (instancetype)KYSShowWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData)analyzeBlock
                          completeBlock:(KYSLinkagePickerViewCompleteSelected)completeBlock;

//设置默认选中项，转换并设置数据源
- (void)setDataWithSelectedIndexArray:(NSArray *)selectedIndexArray
                         analyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block;

- (void)setDataWithComponentWidthArray:(NSArray *)array;

- (void)setDataWithComponentHeightArray:(NSArray *)array;

//显示
- (void)KYSShow;

@end
