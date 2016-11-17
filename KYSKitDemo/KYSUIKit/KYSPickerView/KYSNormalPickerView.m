//
//  KYSNormalPickerView.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 2016/11/17.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNormalPickerView.h"
#import "KYSPickerView.h"


@interface KYSNormalPickerView()<KYSPickerViewDelegate,KYSPickerViewDataSource>

@property(nonatomic,weak) UIWindow *window;

@property(nonatomic,strong) KYSPickerView *pickerView;

@end

@implementation KYSNormalPickerView


+ (instancetype)KYSShowWithDataArray:(NSArray *)dataArray
                       completeBlock:(KYSLinkagePickerViewCompleteSelected)completeBlock{
    KYSNormalPickerView *normalPickerView=[[KYSNormalPickerView alloc] init];
    normalPickerView.dataArray=dataArray;
    normalPickerView.completeBlock=completeBlock;
    [normalPickerView KYSShow];
    return normalPickerView;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame=self.window.bounds;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)KYSShow{
    [self.window addSubview:self];
    [self.pickerView KYSReloadData];
    [self.pickerView KYSShowWithHideBlock:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - KYSPickerViewDelegate
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedIndexArray:(NSArray *)selectedIndexArray{
    if (self.completeBlock) {
        self.completeBlock(selectedIndexArray);
    }
}


#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return [self.dataArray count];
}

//配置数据源
- (NSArray *)KYSPickerView:(KYSPickerView *)pickerView dataInComponent:(NSInteger)component{
    return self.dataArray[component];
}

//默认选中哪一项
- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView selectedIndexInComponent:(NSInteger)component{
    //NSLog(@"默认选中哪一项 component：%ld,selected：%ld",(long)component,(long)[self.selectedIndexArray[component] integerValue]);
    return [self.selectedIndexArray[component] integerValue];
}

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component<self.componentWidthArray.count) {
        return [self.componentWidthArray[component] integerValue];
    }
    return CGRectGetWidth(self.frame)/self.dataArray.count;
}

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    if (component<self.componentHeightArray.count) {
        return [self.componentHeightArray[component] integerValue];
    }
    return 30;
}

#pragma mark - lazy load
- (KYSPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[KYSPickerView alloc] initWithFrame:self.bounds];
        //_pickerView.backgroundColor=[UIColor clearColor];
        _pickerView.delegate=self;
        _pickerView.normalDataSource=self;
    }
    return _pickerView;
}

- (NSMutableArray *)selectedIndexArray{
    if (!_selectedIndexArray) {
        _selectedIndexArray=[NSMutableArray arrayWithCapacity:self.dataArray.count];
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            [_selectedIndexArray addObject:@(0)];
        }
    }
    return _selectedIndexArray;
}

#pragma mark - private
// 获取当前处于activity状态的Window
- (UIWindow *)window{
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
    return window;
}

@end
