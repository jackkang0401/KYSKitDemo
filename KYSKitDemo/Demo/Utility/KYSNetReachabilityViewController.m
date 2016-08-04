//
//  KYSNetReachabilityViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/18.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNetReachabilityViewController.h"
#import "KYSNetReachability.h"

@interface KYSNetReachabilityViewController ()

@end

@implementation KYSNetReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"网络监测";
    
    self.view.backgroundColor=[UIColor whiteColor];
    //NSLog(@"%f",CGRectGetMidX(self.view.frame));
    UIButton *startBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, 80, 100, 30)];
    startBtn.backgroundColor=[UIColor blueColor];
    [startBtn setTitle:@"开始监测" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, 120, 100, 30)];
    stopBtn.backgroundColor=[UIColor redColor];
    [stopBtn setTitle:@"停止监测" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)startAction{
    NSLog(@"开始监测");
    [KYSNetReachability sharedReachability].shouldContinueWhenAppEntersBackground=YES;
    [[KYSNetReachability sharedReachability] startMonitoringWithNetChangeCallBack:^(KYSNetReachabilityStatus status) {
        switch (status) {
            case KYSNetReachabilityStatusNone: {
                NSLog(@"KYSNetReachabilityStatusNone");
                break;
            }
            case KYSNetReachabilityStatusWWAN: {
                NSLog(@"KYSNetReachabilityStatusWWAN");
                break;
            }
            case KYSNetReachabilityStatusWiFi: {
                NSLog(@"KYSNetReachabilityStatusWiFi");
                break;
            }
        }
    }];
}

- (void)stopAction{
    NSLog(@"停止监测");
    [[KYSNetReachability sharedReachability] stopMonitoring];
}

@end
