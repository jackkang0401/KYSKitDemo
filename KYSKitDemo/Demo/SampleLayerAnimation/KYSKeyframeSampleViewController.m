//
//  KYSKeyframeSampleViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/3/2.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSKeyframeSampleViewController.h"
#import "UIView+KYSAddition.h"
#import "CALayer+KYSAddition.h"
#import "KYSLayerAnimation.h"

@interface KYSKeyframeSampleViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong)CALayer *testLayer;
@property(nonatomic,strong)UIBezierPath *bezierPath;
@property(nonatomic,strong)UIBezierPath *bezierPath1;

@property(nonatomic,strong)NSArray *keyPathArray;
@property(nonatomic,strong)UILabel *keyPathLabel;
@property(nonatomic,strong)NSDictionary *valueDic;

@end

@implementation KYSKeyframeSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(0, 0, _containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.position = CGPointMake(_containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.backgroundColor=[UIColor greenColor].CGColor;
    [_containerView.layer addSublayer:_testLayer];
    
    _testLayer.shadowColor=[UIColor redColor].CGColor;
    _testLayer.shadowOffset=CGSizeMake(10, 10);
    _testLayer.shadowRadius=10;
    _testLayer.shadowOpacity=1.0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AnimationKeyPath" ofType:@"plist"];
    _keyPathArray = [NSArray arrayWithContentsOfFile:path];
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.frame=CGRectMake(0, self.view.maxY-240, self.view.width, 240);
    pickView.showsSelectionIndicator=YES;
    pickView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    pickView.delegate=self;
    pickView.dataSource=self;
    [self.view addSubview:pickView];
    
    _keyPathLabel=[[UILabel alloc] init];
    _keyPathLabel.frame=CGRectMake(30, pickView.minY-40, pickView.width-2*30, 30);
    _keyPathLabel.backgroundColor=[UIColor lightGrayColor];
    _keyPathLabel.text=_keyPathArray[0];
    [self.view addSubview:_keyPathLabel];
    
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    playBtn.frame=CGRectMake(pickView.width-80, pickView.minY-40, 50, 30);
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    playBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    _bezierPath = [[UIBezierPath alloc] init];
    [_bezierPath moveToPoint:CGPointMake(0, 40)];
    [_bezierPath addCurveToPoint:CGPointMake(248, 40) controlPoint1:CGPointMake(66, -70) controlPoint2:CGPointMake(198, 150)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = _bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    
    _bezierPath1 = [[UIBezierPath alloc] init];
    [_bezierPath1 moveToPoint:_testLayer.position];
    [_bezierPath1 addLineToPoint:CGPointMake(40, 200)];
    [_bezierPath1 addLineToPoint:CGPointMake(200, 200)];
    [_bezierPath1 addLineToPoint:CGPointMake(200, 400)];
    CAShapeLayer *pathLayer1 = [CAShapeLayer layer];
    pathLayer1.path = _bezierPath1.CGPath;
    pathLayer1.fillColor = [UIColor clearColor].CGColor;
    pathLayer1.strokeColor = [UIColor blueColor].CGColor;
    pathLayer1.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer1];
    
    _valueDic=@{@"transform":@[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,0, 1)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,1, 0)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1,0, 0)]],
                @"transform.rotation":@[@(3*M_PI/8),@(-3*M_PI/8),@(5*M_PI/8)],//同transform.rotation.z
                @"transform.rotation.x":@[@(M_PI/8),@(-2*M_PI/8),@(5*M_PI/8)],
                @"transform.rotation.y":@[@(3*M_PI/8),@(-3*M_PI/8),@(5*M_PI/8)],
                @"transform.rotation.z":@[@(3*M_PI/8),@(-3*M_PI/8),@(5*M_PI/8)],
                @"transform.scale":@[@(-1),@(0.5),@(1.5)],
                @"transform.scale.x":@[@(1.5),@(0.5),@(1.5)],
                @"transform.scale.y":@[@(0.75),@(-1.0),@(0.5)],
                @"transform.scale.z":@[@(0.75),@(-0.75),@(2*0.75),@(0.5)],
                @"position":_bezierPath1,
                @"position.x":@[@(_testLayer.centerX),@(20),@(260)],
                @"position.y":@[@(_testLayer.centerY),@(20),@(360)],
                @"backgroundColor":@[(__bridge id)_testLayer.backgroundColor,
                                     (__bridge id)[UIColor redColor].CGColor,
                                     (__bridge id)[UIColor blueColor].CGColor,
                                     (__bridge id)_testLayer.backgroundColor],
                @"opacity":@[@(0),@(0.5),@(1),@(0),@(1)],
                @"cornerRadius":@[@(15),@(0),@(20)],
                @"borderWidth":@[@(10),@(0),@(5)],
                @"contents":@[(__bridge id)[UIImage imageNamed:@"sina_on"].CGImage,
                              (__bridge id)[UIImage imageNamed:@"sina_off"].CGImage],
                @"contentsRect":@[[NSValue valueWithCGRect:CGRectMake(-0.5, -0.5, 2.0, 2.0)],
                                  [NSValue valueWithCGRect:CGRectMake(-0.5, -0.5, 1.0, 1.0)],
                                  [NSValue valueWithCGRect:CGRectMake(0.5, 0.5, 2.0, 2.0)]],
                @"bounds":@[[NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                            [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 25)]],
                @"shadowColor":@[(__bridge id)_testLayer.shadowColor,
                                 (__bridge id)[UIColor blackColor].CGColor,
                                 (__bridge id)[UIColor blueColor].CGColor,
                                 (__bridge id)_testLayer.shadowColor],
                @"shadowOffset":@[[NSValue valueWithCGSize:CGSizeMake(-10, -10)],
                                  [NSValue valueWithCGSize:CGSizeMake(10, 10)]],
                @"shadowRadius":@[@(20),@(0),@(30),@(10)],
                @"shadowOpacity":@[@(0),@(0.5),@(1),@(0),@(1)]};
}

- (void)playAction:(UIButton *)btn{
    if ([_keyPathLabel.text isEqualToString:@"position"]) {
        [KYSLayerAnimation keyframeAnimationWithLayer:_testLayer
                                              keyPath:_keyPathLabel.text
                                             duration:3.0
                                       timingFunction:nil
                                                 path:_valueDic[_keyPathLabel.text]
                                         rotationMode:kCAAnimationRotateAuto
                                           completion:^(BOOL finished) {
                                               
                                           }];
    }else{
        [KYSLayerAnimation keyframeAnimationWithLayer:_testLayer
                                              keyPath:_keyPathLabel.text
                                             duration:3.0
                                               values:_valueDic[_keyPathLabel.text]
                                           completion:^(BOOL finished) {
            
        }];
    }
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_keyPathArray count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_keyPathArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _keyPathLabel.text=_keyPathArray[row];
}

@end
