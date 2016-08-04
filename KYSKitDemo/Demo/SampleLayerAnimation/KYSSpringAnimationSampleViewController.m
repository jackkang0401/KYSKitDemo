//
//  KYSSpringAnimationSampleViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/3/3.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSSpringAnimationSampleViewController.h"
#import "KYSLayerAnimation.h"

@interface KYSSpringAnimationSampleViewController ()

@property (weak, nonatomic) IBOutlet UIView *testView;

@property (weak, nonatomic) IBOutlet UISlider *massSlider;
@property (weak, nonatomic) IBOutlet UISlider *stiffnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *dampingSlider;
@property (weak, nonatomic) IBOutlet UISlider *initialVelocitySlider;

@property (weak, nonatomic) IBOutlet UILabel *massLabel;
@property (weak, nonatomic) IBOutlet UILabel *stiffnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *dampingLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialVelocityLabel;


@end

@implementation KYSSpringAnimationSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _massSlider.minimumValue=0.0;
    _massSlider.maximumValue=100.0;
    _massSlider.value=1.0;
    [_massSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    _stiffnessSlider.minimumValue=0.0;
    _stiffnessSlider.maximumValue=1000.0;
    _stiffnessSlider.value=100.0;
    [_stiffnessSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    _dampingSlider.minimumValue=0.0;
    _dampingSlider.maximumValue=100.0;
    _dampingSlider.value=10;
    [_dampingSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    _initialVelocitySlider.minimumValue=0.0;
    _initialVelocitySlider.maximumValue=100.0;
    _initialVelocitySlider.value=0.0;
    [_initialVelocitySlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    _massLabel.text=[NSString stringWithFormat:@"%.2f",_massSlider.value];
    _stiffnessLabel.text=[NSString stringWithFormat:@"%.2f",_stiffnessSlider.value];
    _dampingLabel.text=[NSString stringWithFormat:@"%.2f",_dampingSlider.value];
    _initialVelocityLabel.text=[NSString stringWithFormat:@"%.2f",_initialVelocitySlider.value];
}


- (IBAction)playAction:(id)sender {
    
    [KYSLayerAnimation springAnimateWithLayer:_testView.layer
                                      keyPath:@"position.y"
                                         mass:_massSlider.value
                                    stiffness:_stiffnessSlider.value
                                      damping:_dampingSlider.value
                              initialVelocity:_initialVelocitySlider.value
                                     duration:0
                                    fromValue:@(_testView.layer.position.y)
                                      toValue:@(_testView.layer.position.y + 100)
                                      byValue:nil
                               timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                  mediaTiming:nil
                                   completion:^(BOOL finished) {
                                       
                                   }];
}

- (void)valueChange:(UISlider *)slider{
    if (_massSlider == slider) {
        _massLabel.text=[NSString stringWithFormat:@"%.2f",_massSlider.value];
    }else if(_stiffnessSlider == slider){
        _stiffnessLabel.text=[NSString stringWithFormat:@"%.2f",_stiffnessSlider.value];
    }else if(_dampingSlider == slider){
        _dampingLabel.text=[NSString stringWithFormat:@"%.2f",_dampingSlider.value];
    }else if(_initialVelocitySlider == slider){
        _initialVelocityLabel.text=[NSString stringWithFormat:@"%.2f",_initialVelocitySlider.value];
    }
}

@end
