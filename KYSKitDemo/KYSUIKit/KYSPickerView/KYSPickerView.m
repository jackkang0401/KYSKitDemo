//
//  KYSPickerView.m
//  flashServes
//
//  Created by Liu Zhao on 16/5/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import "KYSPickerView.h"

@interface KYSPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger numberOfComponents;//时间pickerView无效
@property(nonatomic,strong)NSArray *widthForComponentsArray;
@property(nonatomic,strong)NSArray *heightForComponentsArray;

@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIPickerView *pickView;

@property(nonatomic,copy) KYSPickerViewHide hideBlock;

@end


@implementation KYSPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        
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
        
        [self p_setPickerView];
    }
    return self;
}

- (void)KYSShow{
    [self KYSShowWithHideBlock:nil];
}

- (void)KYSShowWithHideBlock:(KYSPickerViewHide)block{
    self.hideBlock=block;
    [self.pickView reloadAllComponents];
    self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 180);
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame)-180, CGRectGetWidth(self.frame), 180);
    } completion:^(BOOL finished) {
        //CGRectMake(0, _backView.frame.size.height-180, self.view.frame.size.width, 180)
    }];
}

- (void)KYSHide{
    [self KYSHideNeedRemove:YES];
}

- (void)KYSHideNeedRemove:(BOOL) needRemove{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 180);
    } completion:^(BOOL finished) {
        if (needRemove) {
            [self removeFromSuperview];
        }
        if (self.hideBlock) {
            self.hideBlock();
        }
    }];
}

- (void)KYSReloadData{
    //NSLog(@"KYSReloadData");
    //获取列数
    self.numberOfComponents=[self p_getNumberOfComponents];
        
    //获取数据列表
    [self.dataArray removeAllObjects];
    for (int i=0; i<self.numberOfComponents; i++) {
        NSArray *array=[self p_getDataSourceInComponent:i];
        if (!array) {
            array=@[];
        }
        [self.dataArray addObject:array];
    }
    //NSLog(@"%@,%@",self.delegate,self.normalDataSource);
    //NSLog(@"KYSReloadData：%@",self.dataArray);
        
    //刷新数据
    [_pickView reloadAllComponents];
        
    //设置选中项Index
    for (int i=0; i<self.dataArray.count; i++) {
        NSInteger index=[self p_getSelectedIndexInComponent:i];
        if (index>=0 && index<((NSArray *)self.dataArray[i]).count) {
            [_pickView selectRow:index inComponent:i animated:YES];
        }
    }
}

- (void)setNormalDataSource:(id<KYSPickerViewDataSource>)normalDataSource{
    _normalDataSource=normalDataSource;
    [self KYSReloadData];
}

#pragma mark - Action
- (void)tap{
    if ([_delegate respondsToSelector:@selector(cancelWithPickerView:)]) {
        [_delegate cancelWithPickerView:self];
    }
    [self KYSHide];
}

- (void)btnAction:(UIButton *)btn{
    if(2==btn.tag){
        [self p_getSelectedValue];
    }else if(1==btn.tag){
        if ([_delegate respondsToSelector:@selector(cancelWithPickerView:)]) {
            [_delegate cancelWithPickerView:self];
        }
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

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return [self p_getWidthInComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return [self p_getRowHeightInComponent:component];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray[component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_delegate respondsToSelector:@selector(KYSPickerView:didSelectRow:inComponent:)]) {
        return [_delegate KYSPickerView:self didSelectRow:row inComponent:component];
    }
}

#pragma mark - private
- (void)p_setPickerView{
    //NSLog(@"p_setPickerView");
    _pickView=[[UIPickerView alloc] init];
    _pickView.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
    _pickView.showsSelectionIndicator=YES;
    _pickView.backgroundColor=[UIColor whiteColor];
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [_selectView addSubview:_pickView];
}

- (void)p_getSelectedValue{
    NSMutableArray *mArray=[[NSMutableArray alloc] init];
    for (int i=0; i<self.dataArray.count; i++) {
        NSInteger row=[self.pickView selectedRowInComponent:i];
        [mArray addObject:@(row)];
    }
    //返回选择结果
    if ([_delegate respondsToSelector:@selector(KYSPickerView:selectedIndexArray:)]) {
        [_delegate KYSPickerView:self selectedIndexArray:mArray];
    }
}

#pragma mark - KYSPickerViewNormalDataSource
- (NSArray *)p_getDataSourceInComponent:(NSInteger)component{
    if ([_normalDataSource respondsToSelector:@selector(KYSPickerView:dataInComponent:)]) {
        return [_normalDataSource KYSPickerView:self dataInComponent:component];
    }
    return @[];
}

- (NSInteger)p_getNumberOfComponents{
    if ([_normalDataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_normalDataSource numberOfComponentsInPickerView:self];
    }
    return 1;
}

- (NSInteger)p_getSelectedIndexInComponent:(NSInteger)component{
    if ([_normalDataSource respondsToSelector:@selector(KYSPickerView:selectedIndexInComponent:)]) {
        return [_normalDataSource KYSPickerView:self selectedIndexInComponent:component];
    }
    return 0;
}

- (NSInteger)p_getWidthInComponent:(NSInteger)component{
    if ([_normalDataSource respondsToSelector:@selector(KYSPickerView:widthForComponent:)]) {
        return [_normalDataSource KYSPickerView:self widthForComponent:component];
    }
    return CGRectGetWidth(self.frame)/self.dataArray.count;
}

- (NSInteger)p_getRowHeightInComponent:(NSInteger)component{
    if ([_normalDataSource respondsToSelector:@selector(KYSPickerView:rowHeightForComponent:)]) {
        return [_normalDataSource KYSPickerView:self rowHeightForComponent:component];
    }
    return 30;
}

#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end
