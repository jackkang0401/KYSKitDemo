//
//  KYSTransitionSampleViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/3/2.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSTransitionSampleViewController.h"
#import "UIView+KYSAddition.h"
#import "CALayer+KYSAddition.h"
#import "KYSLayerAnimation.h"

@interface KYSTransitionSampleViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong)CALayer *testLayer;
@property(nonatomic,strong)UIBezierPath *bezierPath;
@property(nonatomic,strong)UIBezierPath *bezierPath1;

@property(nonatomic,strong)NSDictionary *typeDic;
@property(nonatomic,strong)NSArray *typeArray;
@property(nonatomic,strong)NSArray *subtypeArray;
@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UIPickerView *pickView;

@end

@implementation KYSTransitionSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(0, 0, _containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.position = CGPointMake(_containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.backgroundColor=[UIColor magentaColor].CGColor;
    [_containerView.layer addSublayer:_testLayer];
    
    _testLayer.shadowColor=[UIColor redColor].CGColor;
    _testLayer.shadowOffset=CGSizeMake(10, 10);
    _testLayer.shadowRadius=10;
    _testLayer.shadowOpacity=1.0;
    
    _typeArray=@[kCATransitionFade,
                 kCATransitionMoveIn,
                 kCATransitionPush,
                 kCATransitionReveal,
                 @"pageCurl",
                 @"pageUnCurl",
                 @"rippleEffect",
                 @"suckEffect",
                 @"cube",
                 @"oglFlip",
                 @"cameraIrisHollowOpen",
                 @"cameraIrisHollowClose"];
    _subtypeArray=@[kCATransitionFromLeft,kCATransitionFromRight,kCATransitionFromTop,kCATransitionFromBottom];
    _typeDic=@{kCATransitionFade:@[],
               kCATransitionMoveIn:_subtypeArray,
               kCATransitionPush:_subtypeArray,
               kCATransitionReveal:_subtypeArray,
               @"pageCurl":_subtypeArray,
               @"pageUnCurl":_subtypeArray,
               @"rippleEffect":@[],
               @"suckEffect":@[],
               @"cube":_subtypeArray,
               @"oglFlip":_subtypeArray,
               @"cameraIrisHollowOpen":@[],
               @"cameraIrisHollowClose":@[]};
                 
    
    
    
    
    _pickView=[[UIPickerView alloc] init];
    _pickView.frame=CGRectMake(0, self.view.maxY-240, self.view.width, 240);
    _pickView.showsSelectionIndicator=YES;
    _pickView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [self.view addSubview:_pickView];
    
    _typeLabel=[[UILabel alloc] init];
    _typeLabel.frame=CGRectMake(30, _pickView.minY-40, _pickView.width-2*30, 30);
    _typeLabel.backgroundColor=[UIColor lightGrayColor];
    //_keyPathLabel.text=_keyPathArray[0];
    [self.view addSubview:_typeLabel];
    
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    playBtn.frame=CGRectMake(_pickView.width-80, _pickView.minY-40, 50, 30);
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    playBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

- (void)playAction:(UIButton *)btn{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:2.0];
    __weak typeof(self) weakSelf=self;
    
    NSLog(@"%@  %@",_typeArray[[_pickView selectedRowInComponent:0]],_subtypeArray[[_pickView selectedRowInComponent:1]]);
    
    if ([_typeArray[[_pickView selectedRowInComponent:0]] containsString:@"cameraIrisHollow"]) {
        [KYSLayerAnimation transitionWithLayer:_containerView.layer
                                      duration:3.0
                                          type:_typeArray[[_pickView selectedRowInComponent:0]]
                                       subtype:_subtypeArray[[_pickView selectedRowInComponent:1]]
                                timingFunction:nil
                                    animations:^{
                                        weakSelf.testLayer.backgroundColor=color.CGColor;
                                    } completion:^(BOOL finished) {
                                        
                                    }];
    }else{
        [KYSLayerAnimation transitionWithLayer:_testLayer
                                      duration:3.0
                                          type:_typeArray[[_pickView selectedRowInComponent:0]]
                                       subtype:_subtypeArray[[_pickView selectedRowInComponent:1]]
                                timingFunction:nil
                                    animations:^{
                                        weakSelf.testLayer.backgroundColor=color.CGColor;
                                    } completion:^(BOOL finished) {
                                        
                                    }];
    }
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0==component) {
        return [_typeArray count];
    }else{
        return [_typeDic[_typeArray[[pickerView selectedRowInComponent:0]]] count];
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0==component) {
        return _typeArray[row];
    }else{
        return _typeDic[_typeArray[[pickerView selectedRowInComponent:0]]][row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (0==component) {
        [pickerView reloadComponent:1];
        NSInteger index=[pickerView selectedRowInComponent:1];
        NSUInteger count=[_typeDic[_typeArray[row]] count];
        _typeLabel.text=[NSString stringWithFormat:@"%@ %@",_typeArray[row],count?_typeDic[_typeArray[row]][index]:@""];
    }else{
        NSInteger index=[pickerView selectedRowInComponent:0];
        NSUInteger count=[_typeDic[_typeArray[index]] count];
        _typeLabel.text=[NSString stringWithFormat:@"%@ %@",_typeArray[index],count?_typeDic[_typeArray[index]][row]:@""];
    }
}

@end
