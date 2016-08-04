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

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)NSInteger selectedIndex;

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
        
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180);
        _selectView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_selectView];
        
        UIButton *btn1=[[UIButton alloc] init];
        btn1.tag=1;
        btn1.frame=CGRectMake(0, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:162/255.0 blue:227/255.0 alpha:1] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
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
        //获取数据列表
        BOOL impDateDataSource=[_normalDataSource respondsToSelector:@selector(dataSourceKYSPickerView:)];
        self.dataArray=impDateDataSource?[_normalDataSource dataSourceKYSPickerView:self]:nil;
        
        //获取选中项Index
        BOOL impNormalDataSource=[_normalDataSource respondsToSelector:@selector(selectedIndexKYSPickerView:)];
        self.selectedIndex=impNormalDataSource?[_normalDataSource selectedIndexKYSPickerView:self]:0;
        
        //刷新数据
        [_pickView reloadAllComponents];
        
        //设置选中Index
        if (self.dataArray.count&&(self.selectedIndex>=0&&self.selectedIndex<self.dataArray.count)) {
            [_pickView selectRow:self.selectedIndex inComponent:0 animated:YES];
        }
    }else if( KYSPickerViewDate==_type){
        NSDate *curentDate = [NSDate date];
        // 默认日期
        BOOL impDateDataSource=[_dateDataSource respondsToSelector:@selector(currentDateKYSPickerView:)];
        NSDate *date=impDateDataSource?[_dateDataSource currentDateKYSPickerView:self]:nil;
        _datePicker.date =date?:[NSDate dateWithString:@"1990-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
        
        // 最小时间
        //[_datePicker setMinimumDate:curentDate];
        _datePicker.minimumDate=[NSDate dateWithString:@"1950-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
        
        // 最大时间
        //        NSDateComponents *maximumComp = [[NSDateComponents alloc]init];
        //        [maximumComp setMonth:curentDate.month];
        //        [maximumComp setDay:curentDate.day];
        //        [maximumComp setYear:curentDate.year+1];
        //        NSCalendar *maximumCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //        NSDate *maximumDate = [maximumCal dateFromComponents:maximumComp];
        //        [_datePicker setMaximumDate:maximumDate];
        _datePicker.maximumDate=curentDate;
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray?self.dataArray.count:0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray?[self.dataArray objectAtIndex:row]:0;
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
//        NSDate *curentDate = [NSDate date];
//        // 默认日期
//        _datePicker.date =[NSDate dateWithString:@"1990-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
//        // 最小时间
//        _datePicker.minimumDate=[NSDate dateWithString:@"1950-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
//        // 最大时间
//        _datePicker.maximumDate=curentDate;
        [_selectView addSubview:self.datePicker];
    }
}

- (void)p_selectedWithType:(KYSPickerViewType)type{
    if ( KYSPickerViewNormal==type) {
        NSLog(@"普通类型");
        NSInteger row=[self.pickView selectedRowInComponent:0];
        //返回选择结果
        if ([_delegate respondsToSelector:@selector(KYSPickerView:selectedObject:)]) {
            [_delegate KYSPickerView:self selectedObject:self.dataArray[row]];
        }
    }else if( KYSPickerViewDate==_type){
        NSLog(@"时间类型");
        if ([_delegate respondsToSelector:@selector(KYSPickerView:selectedObject:)]) {
            [_delegate KYSPickerView:self selectedObject:_datePicker.date];
        }
    }
}



@end
