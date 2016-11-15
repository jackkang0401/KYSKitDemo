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

@property(nonatomic,strong)KYSPickerView *cityPickerView;
@property(nonatomic,strong)KYSPickerView *centerPickerView;

@property(nonatomic,strong)NSArray *centerArray;

@property(nonatomic,strong)NSMutableArray *currentProvinceArray;
@property(nonatomic,strong)NSMutableArray *currentCityArray;

@property(nonatomic,assign)NSInteger selectedProvinceIndex;
@property(nonatomic,assign)NSInteger selectedCityIndex;
@property(nonatomic,assign)NSInteger selectedCenterIndex;

@property(nonatomic,assign)NSInteger oldSelectedProvinceIndex;
@property(nonatomic,assign)NSInteger oldSelectedCityIndex;
@property(nonatomic,assign)NSInteger oldSelectedCenterIndex;



//
@property(nonatomic,strong)KYSPickerView *pickerView;
@property(nonatomic,strong)NSArray *dataArray;

@end


@implementation KYSLinkagePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        self.selectedProvinceIndex = -1;
        self.selectedCityIndex = -1;
        self.selectedCenterIndex = -1;
        
        self.pickerView=[[KYSPickerView alloc] initWithFrame:self.bounds];
    }
    return self;
}

- (void)setDataWithArray:(NSArray *) originArray analyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block{
    self.dataArray=block(originArray);
}

- (void)KYSShow{
    
    [[self p_activityWindow] addSubview:self];
    
    [self.pickerView KYSReloadData];
    self.pickerView.frame=self.bounds;
    __weak typeof (self) wSelf=self;
    [UIView animateWithDuration:0.5 animations:^{
        typeof(wSelf) sSelf=wSelf;
        sSelf.pickerView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        typeof(wSelf) sSelf=wSelf;
        sSelf.pickerView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
}

- (void)KYSHide{
    __weak typeof (self) wSelf=self;
    [UIView animateWithDuration:0.5 animations:^{
        typeof(wSelf) sSelf=wSelf;
        sSelf.pickerView.frame=CGRectMake(0, 180, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        typeof(wSelf) sSelf=wSelf;
        [sSelf removeFromSuperview];
    }];
}

- (void)KYSReloadData{
    [self.pickerView KYSReloadData];
}

- (IBAction)pickerAction:(UIButton *)btn {
    if(1==btn.tag){
        //取消时需要恢复
        self.oldSelectedProvinceIndex=self.selectedProvinceIndex;
        self.oldSelectedCityIndex=self.selectedCityIndex;
        self.oldSelectedCenterIndex=self.selectedCenterIndex;
        
        NSLog(@"保存：%ld, %ld, %ld",(long)self.selectedProvinceIndex,(long)self.selectedCityIndex,(long)self.selectedCenterIndex);
        
        [self.cityPickerView KYSShow];
    }else if(2==btn.tag){
        if (-1 != self.selectedCityIndex) {
            //取消时需要恢复
            self.oldSelectedCenterIndex=self.selectedCenterIndex;
            NSLog(@"保存：%ld, %ld, %ld",(long)self.selectedProvinceIndex,(long)self.selectedCityIndex,(long)self.selectedCenterIndex);
            [self.centerPickerView KYSShow];
        }else{
            NSLog(@"请选择城市");
        }
    }
}


#pragma mark - KYSPickerViewDelegate
- (void)cancelWithPickerView:(KYSPickerView *)pickerView{
    
    NSLog(@"cancelWithPickerView:");
    
    if (pickerView==_cityPickerView) {
        self.selectedProvinceIndex=self.oldSelectedProvinceIndex;
        self.selectedCityIndex=self.oldSelectedCityIndex;
        self.selectedCenterIndex=self.oldSelectedCenterIndex;
        NSLog(@"恢复：%ld, %ld, %ld",(long)self.selectedProvinceIndex,(long)self.selectedCityIndex,(long)self.selectedCenterIndex);
    }else if(pickerView == _centerPickerView){
        self.selectedCenterIndex=self.oldSelectedCenterIndex;
        NSLog(@"恢复：%ld, %ld, %ld",(long)self.selectedProvinceIndex,(long)self.selectedCityIndex,(long)self.selectedCenterIndex);
    }
}

- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object{
    NSLog(@"KYSPickerView selected: %@",object);
    if(_cityPickerView == pickerView){
        //self.centerArray[self.selectedProvinceIndex][@"data"][self.selectedCityIndex][@"name"];
    }else if(_centerPickerView == pickerView){
        //self.centerArray[self.selectedProvinceIndex][@"data"][self.selectedCityIndex][@"data"][self.selectedCenterIndex][@"name"];
    }
}


//
- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *str=@"";
    NSLog(@"动画停留位置start：%@,%ld,%ld",str,(long)component,(long)row);
    if(_cityPickerView == pickerView){
        str=@"cityPickerView";
        if (0==component) {
            self.selectedProvinceIndex = row;
            self.selectedCityIndex = -1;
            self.selectedCenterIndex = -1;
            //用self调用会创建新对象
            [_cityPickerView KYSReloadData];
        }else if (1==component) {
            //self.selectedProvinceIndex = row;
            self.selectedCityIndex = row;
            self.selectedCenterIndex = -1;
            //最后一项不需要刷新,以为会在刷新之前获取获取默认选项，还会回到原来选中的项
            //[_cityPickerView KYSReloadData];
        }
    }
    NSLog(@"动画停留位置end：%@,%ld,%ld",str,(long)component,(long)row);
}

#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return [self.dataArray count];
}

//数据源
- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index{
    NSLog(@"获取数据源:componentIndex：%ld",(long)index);
    
    if (0==index) {
            if (-1 == self.selectedProvinceIndex) {
                self.selectedProvinceIndex=0;
                return self.dataArray[index];
            }
            return self.currentProvinceArray;
    }else if(1 == index){
            if (-1 != self.selectedProvinceIndex) {
                self.selectedCityIndex=0;
                return self.dataArray[index][0];
            }
    }
    return nil;
}

//默认选中哪一项
- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index{
    NSInteger row=0;
    NSString *str=@"";
    if (pickerView==_centerPickerView) {
        str=@"centerPickerView";
        if (0==index) {
            row = self.selectedCenterIndex;
        }
    }else if (_cityPickerView==pickerView) {
        str=@"cityPickerView";
        if (0==index) {
            row = self.selectedProvinceIndex;
        }else if (1==index) {
            row = self.selectedCityIndex;
        }else if (2==index) {
            row = self.selectedCenterIndex;
        }
    }
    NSLog(@"默认选中哪一项：%@,%ld,%ld",str,(long)index,(long)row);
    return row;
}

#pragma mark - 城市选择
- (KYSPickerView *)cityPickerView{
    //if (!_cityPickerView) {
    //父视图的frame
    CGRect frame=CGRectMake(0, 0, self.frame.size.width , self.frame.size.width);
    _cityPickerView=[[KYSPickerView alloc] initWithFrame:frame];
    _cityPickerView.delegate=self;
    _cityPickerView.normalDataSource=self;
    [self addSubview:_cityPickerView];
    //}
    return _cityPickerView;
}

#pragma mark - 中心选择
- (KYSPickerView *)centerPickerView{
    //if (!_centerPickerView) {
    //父视图的frame
    CGRect frame=CGRectMake(0, 0, self.frame.size.width , self.frame.size.width);
    _centerPickerView=[[KYSPickerView alloc] initWithFrame:frame];
    _centerPickerView.delegate=self;
    _centerPickerView.normalDataSource=self;
    [self addSubview:_centerPickerView];
    //}
    
    return _cityPickerView;
}

#pragma mark - lazy load
- (NSMutableArray *)currentProvinceArray{
    if (!_currentProvinceArray) {
        _currentProvinceArray=[[NSMutableArray alloc] init];
    }
    return _currentProvinceArray;
}

- (NSMutableArray *)currentCityArray{
    if (!_currentCityArray) {
        _currentCityArray=[[NSMutableArray alloc] init];
    }
    return _currentCityArray;
}

- (KYSPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[KYSPickerView alloc] initWithFrame:self.bounds];
        _pickerView.backgroundColor=[UIColor clearColor];
        _pickerView.delegate=self;
        _pickerView.normalDataSource=self;
    }
    return _pickerView;
}

#pragma mark - private
// 获取当前处于activity状态的Window
- (UIWindow *)p_activityWindow{
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
