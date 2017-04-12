//
//  KYSMYUIViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/5/18.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSMYUIViewController.h"
#import "UITextField+KYSDeleteBackwardNotification.h"
#import "KYSNormalPickerView.h"
#import "KYSDatePickerView.h"
#import "KYSAlertView.h"
#import "KYSTextView.h"
#import "KYSLinkagePickerView.h"

@interface KYSMYUIViewController()<KYSTextFieldDelegate,KYSTextViewDelegate>

@property(nonatomic,strong)KYSDatePickerView *datePickerView;
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
    
    UIButton *btn3=[[UIButton alloc] init];
    btn3.tag=4;
    btn3.frame=CGRectMake(20, 350, 150, 30);
    btn3.backgroundColor=[UIColor blueColor];
    [btn3 setTitle:@"封装LinkagePickerView" forState:UIControlStateNormal];
    btn3.titleLabel.font=[UIFont systemFontOfSize:15.];
    [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}


- (void)btnAction:(UIButton *)btn{
    _selectedIndex=btn.tag;
    if(1==btn.tag){
        //注意数据类型是数组包含数组
        [KYSNormalPickerView KYSShowWithDataArray:@[@[@"1",@"2",@"3"]] completeBlock:^(NSArray * selectedArray) {
            NSLog(@"%@",selectedArray);
        }];
        return;
    }else if(2==btn.tag){
        [KYSDatePickerView KYSShowWithCompleteBlock:^(NSDate *date) {
            NSLog(@"%@",date);
        }];
    }else if(3==btn.tag){
        KYSAlertView *alertView=[[KYSAlertView alloc] initWithTitle:@"title"
                                                            message:@"message"
                                                       buttonTitles:@[@"btn1",@"btn2",@"btn1"]
                                                              block:^(NSInteger index, id object) {
                                                                  NSLog(@"%ld, %@",(long)index,object);
        }];
        [alertView KYSShow];
    }else if(4==btn.tag){
        
//        NSArray *newArray=@[@[
//                                @"A0_0",
//                                @"A0_1",
//                                @"A0_2"
//                                ],
//                            @[
//                                @[@"A1_0"],
//                                @[@"B1_0",
//                                  @"B1_1"],
//                                @[@"C1_0"]
//                                ],
//                            @[
//                                @[
//                                    @[@"A2_0",@"A2_1"]
//                                    ],
//                                @[
//                                    @[@"B2_0",@"B2_1",@"B2_2"],
//                                    @[@"B2+0",@"B2+1"]
//                                    ],
//                                @[
//                                    @[@"C2_0",@"C2_1"]
//                                    ]
//                                ]
//                            ];
        
        NSArray *array = @[@{@"name":@"A0_0",
                             @"data":@[@{@"name":@"A1_0",
                                         @"data":@[@{@"id":@"101",
                                                     @"name":@"A2_0"},
                                                   @{@"id":@"102",
                                                     @"name":@"A2_1"}]//2层
                                         }]//1层
                             },
                           @{@"name":@"B0_0",
                             @"data":@[@{@"name":@"B1_0",
                                         @"data":@[@{@"id":@"103",
                                                     @"name":@"B2_0"},
                                                   @{@"id":@"104",
                                                     @"name":@"B2_1"},
                                                   @{@"id":@"105",
                                                     @"name":@"B2_2"}]//2层
                                         },
                                       @{@"name":@"B1_1",
                                         @"data":@[@{@"id":@"106",
                                                     @"name":@"B2+0"},
                                                   @{@"id":@"107",
                                                     @"name":@"B2+1"}]//2层
                                         }]//1层
                             },
                           @{@"name":@"C0_0",
                             @"data":@[@{@"name":@"C1_0",
                                         @"data":@[@{@"id":@"108",
                                                     @"name":@"C2_0"},
                                                   @{@"id":@"109",
                                                     @"name":@"C2_1"}]//2层
                                         }]//1层
                             }];//0层
        NSArray *dataArray = array;
        //NSLog(@"%@",dataArray);
        //注意数据转换
        [KYSLinkagePickerView KYSShowWithAnalyzeBlock:^NSArray *() {
            //获取1层数据
            NSMutableArray *mArray00=[[NSMutableArray alloc] init];
            NSMutableArray *mArray01=[[NSMutableArray alloc] init];
            NSMutableArray *mArray02=[[NSMutableArray alloc] init];
            
            for (NSDictionary *dic0 in dataArray) {
                
                //获取2层数据
                NSMutableArray *mArray10=[[NSMutableArray alloc] init];
                NSMutableArray *mArray11=[[NSMutableArray alloc] init];
                for (NSDictionary *dic1 in dic0[@"data"]) {
                    
                    //获取3层数据
                    NSMutableArray *mArray20=[[NSMutableArray alloc] init];
                    for (NSDictionary *dic2 in dic1[@"data"]) {
                         [mArray20 addObject:dic2[@"name"]];
                    }
                    [mArray10 addObject:dic1[@"name"]];
                    [mArray11 addObject:mArray20];
                    
                }
                
                [mArray00 addObject:dic0[@"name"]];
                [mArray01 addObject:mArray10];
                [mArray02 addObject:mArray11];
            }
            
//            NSLog(@"1：%@",mArray00);
//            NSLog(@"2：%@",mArray01);
//            NSLog(@"3：%@",mArray02);
            //NSLog(@"%@",@[mArray00,mArray01,mArray02]);
            return @[mArray00,mArray01,mArray02];
            //return newArray;
        } completeBlock:^(NSArray * selectedArray) {
            NSLog(@"%@",selectedArray);
        }];
    }
}

#pragma mark - KYSTextViewDelegate
- (void)textView:(UITextView *)textView didTapAtCharactersIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

#pragma mark - KYSDatePickerViewDelegate
- (void)KYSDatePickerView:(KYSDatePickerView *)pickerView selectedObject:(id)object{
    NSLog(@"%@",object);
}

- (void)cancelWithDatePickerView:(KYSDatePickerView *)pickerView{
    NSLog(@"cancelWithDatePickerView:");
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
