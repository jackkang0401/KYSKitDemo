//
//  MainViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/18.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _dataArray=@[@{@"name":@"Utility",
//                   @"array":@[@{@"value":@"网络监测",@"class":@"KYSNetReachabilityViewController"},
//                              @{@"value":@"自定义定时器",@"class":@"KYSTimerViewController"}]}];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:path];
    
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section][@"array"] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dataArray[section][@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"K"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"K"];
    }
    cell.textLabel.text = _dataArray[indexPath.section][@"array"][indexPath.row][@"value"];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    Class cls=NSClassFromString(_dataArray[indexPath.section][@"array"][indexPath.row][@"class"]);
    UIViewController *viewController=[[cls alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}














@end
