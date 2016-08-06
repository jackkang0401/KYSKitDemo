//
//  KYSTimerViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTimerViewController.h"
#import "KYSGCDTimer.h"

@interface KYSTimerViewController ()

@property(nonatomic,strong)KYSGCDTimer *kTimer;
@property(nonatomic,assign)unsigned long count;

@end

@implementation KYSTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"自定义定时器";
    
    self.view.backgroundColor=[UIColor whiteColor];
    //NSLog(@"%f",CGRectGetMidX(self.view.frame));
    UIButton *startBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, 80, 100, 30)];
    startBtn.backgroundColor=[UIColor blueColor];
    [startBtn setTitle:@"开启定时器" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, 120, 100, 30)];
    stopBtn.backgroundColor=[UIColor redColor];
    [stopBtn setTitle:@"停止定时器" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    _count=0;
}

- (void)startAction{
    NSLog(@"开始定时器");
    if (_kTimer) {
        [_kTimer invalidate];
    }
    _kTimer=[KYSGCDTimer scheduledTmerWithTimeInterval:1.0 queue:nil block:^{
        NSLog(@"KYSGCDTimer：1");
    } repeats:YES];
}

- (void)stopAction{
    NSLog(@"停止定时器");
    [_kTimer invalidate];
}

- (void)testTimer{
    NSLog(@"%lu",_count++);
}

@end
