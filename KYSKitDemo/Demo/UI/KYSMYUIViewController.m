//
//  KYSMYUIViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/5/18.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSMYUIViewController.h"
#import "UITextField+KYSDeleteBackwardNotification.h"
#import "KYSPickerView.h"
#import "KYSAlertView.h"
#import "KYSTextView.h"

@interface KYSMYUIViewController()<KYSPickerViewDelegate,KYSPickerViewNormalDataSource,KYSPickerViewDateDataSource,KYSTextFieldDelegate,KYSTextViewDelegate>

@property(nonatomic,strong)KYSPickerView *kPickerView;
@property(nonatomic,strong)NSDictionary *pickerDataDic;
@property(nonatomic,assign)NSInteger selectedIndex;

@end


@implementation KYSMYUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UITextField *textField=[[UITextField alloc] init];
    textField.frame=CGRectMake(20, 100, 200, 20);
    textField.font=[UIFont systemFontOfSize:15.0];
    textField.placeholder=@"测试回退按钮";
    textField.delegate=self;
    [self.view addSubview:textField];
    
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=1;
    btn.frame=CGRectMake(20, 150, 150, 30);
    btn.backgroundColor=[UIColor greenColor];
    [btn setTitle:@"封装pickerView" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15.];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1=[[UIButton alloc] init];
    btn1.tag=2;
    btn1.frame=CGRectMake(20, 200, 150, 30);
    btn1.backgroundColor=[UIColor blueColor];
    [btn1 setTitle:@"封装pickerView1" forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont systemFontOfSize:15.];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2=[[UIButton alloc] init];
    btn2.tag=3;
    btn2.frame=CGRectMake(20, 250, 150, 30);
    btn2.backgroundColor=[UIColor blueColor];
    [btn2 setTitle:@"封装alertViewView" forState:UIControlStateNormal];
    btn2.titleLabel.font=[UIFont systemFontOfSize:15.];
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    KYSTextView *textView=[[KYSTextView alloc] init];
    textView.scrollEnabled=YES; textView.editable=NO;//这时才计算contentSize
    textView.text=@"0123456789ABCDEF";
    textView.delegate=self;
    textView.frame=CGRectMake(20, 300, 150, 30);
    [self.view addSubview:textView];
    
    
//    UIButton *btn3=[[UIButton alloc] init];
//    btn3.tag=4;
//    btn3.frame=CGRectMake(20, 300, 150, 30);
//    btn3.backgroundColor=[UIColor blueColor];
//    [btn3 setTitle:@"封装alertViewView" forState:UIControlStateNormal];
//    btn3.titleLabel.font=[UIFont systemFontOfSize:15.];
//    [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn3];
}


- (void)btnAction:(UIButton *)btn{
    _selectedIndex=btn.tag;
    if(1==btn.tag){
        _kPickerView = [[KYSPickerView alloc] initWithFrame:self.view.superview.bounds type:KYSPickerViewNormal];
        _kPickerView.delegate=self;
        _kPickerView.normalDataSource=self;
        [self.view.superview addSubview:_kPickerView];
        [_kPickerView KYSShow];
        return;
    }else if(2==btn.tag){
        _kPickerView = [[KYSPickerView alloc] initWithFrame:self.view.superview.bounds type:KYSPickerViewDate];
        _kPickerView.delegate=self;
        //_kPickerView.currentDate=;
        _kPickerView.dateDataSource=self;
        [self.view.superview addSubview:_kPickerView];
        [_kPickerView KYSShow];
    }else if(3==btn.tag){
        
        KYSAlertView *alertView=[[KYSAlertView alloc] initWithTitle:@"title"
                                                            message:@"message"
                                                       buttonTitles:@[@"btn1",@"btn2",@"btn1"]
                                                              block:^(NSInteger index, id object) {
                                                                  NSLog(@"%ld, %@",(long)index,object);
        }];
        [alertView KYSShow];
    }
}

#pragma mark - KYSTextViewDelegate
- (void)textView:(UITextView *)textView didTapAtCharactersIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

#pragma mark - KYSPickerViewDelegate
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object{
    NSLog(@"%@",object);
}

#pragma mark - KYSPickerViewDateDataSource
//- (NSDate *)currentDateKYSPickerView:(KYSPickerView *)pickerView{
//    return _selectedAgeDate;
//}

#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return self.pickerDataDic.allKeys.count+1;
}

- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index{
    return self.pickerDataDic[@(index)];
}

- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index{
    NSString *str = 0==index?@"硕士":@"1-3年";
    NSArray *array=self.pickerDataDic[@(index)];
    return [array indexOfObject:str];
}


- (NSDictionary *)pickerDataDic{
    if (!_pickerDataDic) {
        _pickerDataDic=@{@(0):@[@"大专以下",@"大专",@"本科",@"硕士",@"硕士以上"],
                         @(1):@[@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"]};
    }
    return _pickerDataDic;
}

#pragma mark - KYSTextFieldDelegate
- (void)textFieldDidDeleteBackward:(UITextField *)textField{
    NSLog(@"点击回退按钮");
}

@end
