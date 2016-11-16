//
//  KYSLinkagePickerView.m
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSLinkagePickerView.h"
#import "KYSPickerView.h"

@interface KYSLinkagePickerView()<KYSPickerViewDelegate,KYSPickerViewDataSource>

@property(nonatomic,weak) UIWindow *window;
@property(nonatomic,strong) KYSPickerView *pickerView;
@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong)NSArray *componentWidthArray; //每项的宽度
@property(nonatomic,strong)NSArray *componentHeightArray;//每项的高度
@property(nonatomic,strong)NSMutableArray *selectedIndexArray;
@property(nonatomic,copy)KYSLinkagePickerViewCompleteSelected completeBlock;//选择完成回调

@end


@implementation KYSLinkagePickerView

+ (instancetype)KYSShowWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData)analyzeBlock
                          completeBlock:(KYSLinkagePickerViewCompleteSelected)completeBlock{
    KYSLinkagePickerView *linkagePickerView=[[KYSLinkagePickerView alloc] init];
    [linkagePickerView setDataWithSelectedIndexArray:nil analyzeBlock:analyzeBlock];
    linkagePickerView.completeBlock=completeBlock;
    [linkagePickerView KYSShow];
    return linkagePickerView;
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

- (void)setDataWithSelectedIndexArray:(NSArray *)selectedIndexArray
                         analyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block{
    self.dataArray=block();
    //未设置默认选项的，设置成-1
    [self.selectedIndexArray removeAllObjects];
    for (NSUInteger i=0; i<self.dataArray.count; i++) {
        if (i<selectedIndexArray.count) {
            [self.selectedIndexArray addObject:selectedIndexArray[i]];
        }else{
            [self.selectedIndexArray addObject:@(-1)];
        }
    }
}

- (void)setDataWithComponentWidthArray:(NSArray *)array{
    self.componentWidthArray=array;
}

- (void)setDataWithComponentHeightArray:(NSArray *)array{
    self.componentHeightArray=array;
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


//选中动画结束位置
- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"动画停留位置start component：%ld,selected：%ld",(long)component,(long)row);
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        //之前的不变
        if (i < component) {
            continue;
        }
        //刷新后边的
        if (i==component) {
            [self.selectedIndexArray replaceObjectAtIndex:i withObject:@(row)];
        }else{
            [self.selectedIndexArray replaceObjectAtIndex:i withObject:@(-1)];
        }
    }
    //最后一个component不用刷新
    if (component == (self.dataArray.count-1)) {
        return;
    }
    //刷新之后的Component
    //NSLog(@"刷新之后的Component");
    [self.pickerView KYSReloadData];
}

#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return [self.dataArray count];
}

//配置数据源
- (NSArray *)KYSPickerView:(KYSPickerView *)pickerView dataInComponent:(NSInteger)component{
    //NSLog(@"获取数据源0：componentIndex：%ld",(long)component);
    if (component >= self.dataArray.count) {
        return nil;
    }
    
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        if (i == component) {
            if (-1==[self.selectedIndexArray[component] integerValue]) {
                [self.selectedIndexArray replaceObjectAtIndex:component withObject:@(0)];
            }
            break;
        }
    }
    //选择数据源
    NSArray *cArray=self.dataArray[component];
    for (NSInteger i=0; i < component; i++) {
        //NSLog(@"%@",cArray);
        cArray=cArray[[self.selectedIndexArray[i] integerValue]];
    }
    return cArray;
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
        _selectedIndexArray=[[NSMutableArray alloc] init];
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
