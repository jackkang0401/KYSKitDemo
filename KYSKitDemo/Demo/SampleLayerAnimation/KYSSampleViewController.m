//
//  KYSSampleViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/2/29.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSSampleViewController.h"

@interface KYSSampleViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation KYSSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:path];
    
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"动画样例";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"K"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"K"];
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"name"];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
//    Class cls=NSClassFromString(_dataArray[indexPath.section][@"class"]);
//    UIViewController *viewController=[[cls alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    NSString *identifier=_dataArray[indexPath.row][@"class"];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"KYSSample" bundle:nil];
    UIViewController *viewController=[storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
