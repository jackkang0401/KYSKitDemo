//
//  KYSPickerView.m
//  flashServes
//
//  Created by Liu Zhao on 16/5/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSPickerView.h"
#import "NSDate+KYSAddition.h"

@interface KYSPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger numberOfComponents;//时间pickerView无效

@property (nonatomic,assign) KYSPickerViewType type;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIPickerView *pickView;


@end


@implementation KYSPickerView

- (instancetype)initWithFrame:(CGRect)frame type:(KYSPickerViewType)type{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
        _type=type;
        
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
        
        [self p_setPickerViewWithType:type];
        
    }
    return self;
}

- (void)KYSShow{
    if ( KYSPickerViewNormal==_type) {
        [_pickView reloadAllComponents];
    }else if( KYSPickerViewDate==_type){
        
    }
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
    if ( KYSPickerViewNormal==_type) {
        //获取列数
        self.numberOfComponents=[self p_getNumberOfComponents];
        
        //获取数据列表
        [self.dataArray removeAllObjects];
        for (int i=0; i<self.numberOfComponents; i++) {
            NSArray *array=[self p_getDataSourceWithComponentIndex:i];
            if (!array) {
                array=@[];
            }
            [self.dataArray addObject:array];
        }
        
        //刷新数据
        [_pickView reloadAllComponents];
        
        //设置选中项Index
        for (int i=0; i<self.dataArray.count; i++) {
            NSInteger index=[self p_getSelectedIndexWithComponentIndex:i];
            if (index>=0 && index<((NSArray *)self.dataArray[i]).count) {
                [_pickView selectRow:index inComponent:i animated:YES];
            }
        }
    }else if( KYSPickerViewDate==_type){
        // 默认日期
        _datePicker.date =[self p_getCurrentDate];
        // 最小时间
        _datePicker.minimumDate=[self p_getMinDate];
        // 最大时间
        _datePicker.maximumDate=[self p_getMaxDate];
    }
}

- (void)setNormalDataSource:(id<KYSPickerViewNormalDataSource>)normalDataSource{
    _normalDataSource=normalDataSource;
    [self KYSReloadData];
}

- (void)setDateDataSource:(id<KYSPickerViewDateDataSource>)dateDataSource{
    _dateDataSource=dateDataSource;
    [self KYSReloadData];
}

#pragma mark - Action
- (void)tap{
    [self KYSHide];
}

- (void)btnAction:(UIButton *)btn{
    if(2==btn.tag){
        [self p_selectedWithType:_type];
    }
    [self KYSHide];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ((NSArray *)self.dataArray[component]).count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray[component] objectAtIndex:row];
}


#pragma mark - private
- (void)p_setPickerViewWithType:(KYSPickerViewType)type{
    if ( KYSPickerViewNormal==type) {
        _pickView=[[UIPickerView alloc] init];
        _pickView.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
        _pickView.showsSelectionIndicator=YES;
        _pickView.backgroundColor=[UIColor whiteColor];
        _pickView.delegate=self;
        _pickView.dataSource=self;
        [_selectView addSubview:_pickView];
    }else if( KYSPickerViewDate==type){
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_selectView addSubview:self.datePicker];
    }
}

- (void)p_selectedWithType:(KYSPickerViewType)type{
    if ( KYSPickerViewNormal==type) {
        NSLog(@"普通类型");
        NSMutableArray *mArray=[[NSMutableArray alloc] init];
        for (int i=0; i<self.dataArray.count; i++) {
            NSInteger row=[self.pickView selectedRowInComponent:i];
            //NSLog(@"%ld",(long)row);
            if (((NSArray *)self.dataArray[i]).count<=0) {
                [mArray addObject:@""];
            }else{
                NSObject *object=self.dataArray[i][row];
                [mArray addObject:object];
            }
        }
        //返回选择结果
        if ([_delegate respondsToSelector:@selector(KYSPickerView:selectedObject:)]) {
            [_delegate KYSPickerView:self selectedObject:mArray];
        }
    }else if( KYSPickerViewDate==_type){
        NSLog(@"时间类型");
        if ([_delegate respondsToSelector:@selector(KYSPickerView:selectedObject:)]) {
            [_delegate KYSPickerView:self selectedObject:_datePicker.date];
        }
    }
}

#pragma mark - KYSPickerViewNormalDataSource
- (NSArray *)p_getDataSourceWithComponentIndex:(NSInteger)index{
    if ([_normalDataSource respondsToSelector:@selector(dataSourceKYSPickerView:componentIndex:)]) {
        return [_normalDataSource dataSourceKYSPickerView:self componentIndex:index];
    }
    return @[];
}

- (NSInteger)p_getSelectedIndexWithComponentIndex:(NSInteger)index{
    if ([_normalDataSource respondsToSelector:@selector(selectedIndexKYSPickerView:componentIndex:)]) {
        return [_normalDataSource selectedIndexKYSPickerView:self componentIndex:index];
    }
    return 0;
}

- (NSInteger)p_getNumberOfComponents{
    if ([_normalDataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_normalDataSource numberOfComponentsInPickerView:self];
    }
    return 1;
}

#pragma mark - KYSPickerViewDateDataSource
- (NSDate *)p_getCurrentDate{
    if ([_dateDataSource respondsToSelector:@selector(currentDateKYSPickerView:)]) {
        return [_dateDataSource currentDateKYSPickerView:self];
    }
    return [NSDate date];
}

- (NSDate *)p_getMinDate{
    if ([_dateDataSource respondsToSelector:@selector(minDateKYSPickerView:)]) {
        return [_dateDataSource minDateKYSPickerView:self];
    }
    return [NSDate dateWithString:@"1990-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
}

- (NSDate *)p_getMaxDate{
    if ([_dateDataSource respondsToSelector:@selector(maxDateKYSPickerView:)]) {
        return [_dateDataSource maxDateKYSPickerView:self];
    }
    return [NSDate date];
}

#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end
