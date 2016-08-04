//
//  KYSBasicSampleViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/2/29.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSBasicSampleViewController.h"
#import "UIView+KYSAddition.h"
#import "CALayer+KYSAddition.h"
#import "KYSLayerAnimation.h"

@interface KYSBasicSampleViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong)CALayer *testLayer;
@property(nonatomic,strong)UIBezierPath *bezierPath;

@property(nonatomic,strong)NSArray *keyPathArray;
@property(nonatomic,strong)UILabel *keyPathLabel;
@property(nonatomic,strong)NSDictionary *valueDic;

@property(nonatomic,strong)CAShapeLayer *chartLine;

@end

@implementation KYSBasicSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(0, 0, _containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.position = CGPointMake(_containerView.layer.width/2, _containerView.layer.height/2);
    _testLayer.backgroundColor=[UIColor greenColor].CGColor;
//    _testLayer.borderWidth=3.0;
//    _testLayer.borderColor=[UIColor blackColor].CGColor;
    //_testLayer.contents=(__bridge id)[UIImage imageNamed:@"qq_on"].CGImage;
    //_testLayer.contentsRect=CGRectMake(-0.5, -0.5, 2.0, 2.0);
    [_containerView.layer addSublayer:_testLayer];
    
    _testLayer.shadowColor=[UIColor redColor].CGColor;
    _testLayer.shadowOffset=CGSizeMake(10, 10);
    _testLayer.shadowRadius=10;
    _testLayer.shadowOpacity=1.0;
    
//    CALayer *mask=[CALayer layer];
//    mask.frame=CGRectMake(0, 0, _containerView.layer.width/2, _containerView.layer.height/4);
//    //mask.backgroundColor=[UIColor redColor].CGColor;
//    mask.contents=(__bridge id)[UIImage imageNamed:@"qq_on"].CGImage;
//    _testLayer.mask;
    
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
    
    _chartLine = [CAShapeLayer layer];
    _chartLine.lineCap = kCALineCapRound;
    _chartLine.lineJoin = kCALineJoinBevel;
    _chartLine.strokeColor=[UIColor blueColor].CGColor;
    _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    _chartLine.lineWidth   = 2.0;
    _chartLine.strokeEnd   = 0.0;
    [self.view.layer addSublayer:_chartLine];
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    [progressline moveToPoint:CGPointMake(100,100)];
    [progressline addLineToPoint:CGPointMake(200, 200)];
    [progressline moveToPoint:CGPointMake(200, 200)];
    [progressline addLineToPoint:CGPointMake(100, 300)];
    
    _chartLine.path = progressline.CGPath;
    
    _valueDic=@{@"transform":[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,0, 1)],
                @"transform.rotation":@(4*M_PI),//同transform.rotation.z
                @"transform.rotation.x":@(M_PI),
                @"transform.rotation.y":@(2*M_PI),
                @"transform.rotation.z":@(3*M_PI),
                @"transform.scale":@(-1),
                @"transform.scale.x":@(1.5),
                @"transform.scale.y":@(-1.0),
                @"transform.scale.z":@(0.75),
                @"position.x":@(30),
                @"position.y":@(30),
                @"backgroundColor":(__bridge id)[UIColor redColor].CGColor,
                @"opacity":@(0),
                @"cornerRadius":@(15),
                @"borderWidth":@(10),
                @"contents":(__bridge id)[UIImage imageNamed:@"sina_on"].CGImage,
                @"contentsRect":[NSValue valueWithCGRect:CGRectMake(-0.5, -0.5, 2.0, 2.0)],
                @"bounds":[NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                @"position":[NSValue valueWithCGPoint:CGPointMake(30, 30)],
                @"shadowColor":(__bridge id)[UIColor blackColor].CGColor,
                @"shadowOffset":[NSValue valueWithCGSize:CGSizeMake(-10, -10)],
                @"shadowRadius":@(20),
                @"shadowOpacity":@(0.0),
                @"strokeEnd":[NSNumber numberWithFloat:1.0f]};
}

- (void)playAction:(UIButton *)btn{
    if (!_valueDic[_keyPathLabel.text]) {
        NSLog(@"%@",_keyPathLabel.text);
        return;
    }
    if ([_keyPathLabel.text containsString:@"transform"]) {
        [KYSLayerAnimation basicAnimateWithLayer:_testLayer
                                         keyPath:_keyPathLabel.text
                                        duration:4.0
                                         byValue:_valueDic[_keyPathLabel.text]
                                  timingFunction:nil
                                      completion:^(BOOL finished){
                                          NSLog(@"_testLayer完成");
                                          //_testLayer.transform=CATransform3DRotate(_testLayer.transform, 2*M_PI, 1, 1, 1);
                                      }];
    }else if([_keyPathLabel.text containsString:@"opacity"]||[_keyPathLabel.text isEqualToString:@"shadowOpacity"]){
        KYSMediaTiming *mediaTiming=[[KYSMediaTiming alloc] init];
        mediaTiming.repeatCount=INFINITY;
        mediaTiming.autoreverses=YES;
        //闪烁
        [KYSLayerAnimation basicAnimateWithLayer:_testLayer
                                         keyPath:_keyPathLabel.text
                                        duration:0.5
                                         toValue:_valueDic[_keyPathLabel.text]
                                  timingFunction:nil
                                     mediaTiming:mediaTiming
                                      completion:^(BOOL finished) {
            
        }];
    }else if([_keyPathLabel.text isEqualToString:@"strokeEnd"]){
        [KYSLayerAnimation basicAnimateWithLayer:_chartLine
                                         keyPath:_keyPathLabel.text
                                        duration:2.0
                                         toValue:_valueDic[_keyPathLabel.text]
                                  timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                      completion:^(BOOL finished){
                                          NSLog(@"strokeEnd");                                      }];
    }else{
        [KYSLayerAnimation basicAnimateWithLayer:_testLayer
                                         keyPath:_keyPathLabel.text
                                        duration:2.0
                                         toValue:_valueDic[_keyPathLabel.text]
                                  timingFunction:nil
                                      completion:^(BOOL finished){
                                          NSLog(@"_testLayer完成");
                                          //_testLayer.transform=CATransform3DRotate(_testLayer.transform, 2*M_PI, 1, 1, 1);
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
