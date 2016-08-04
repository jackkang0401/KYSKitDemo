//
//  BufferViewController.m
//  KCoreAnimationDemo
//
//  Created by Liu Dehua on 15/9/2.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "BufferViewController.h"
#import "KYSLayerAnimation.h"

#define LEFT_SPACE 240

@interface BufferViewController()

@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation BufferViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //create sublayer
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(20, 20, 40, 40);
    _colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [_layerView.layer addSublayer:_colorLayer];
    
    UIImage *ballImage = [UIImage imageNamed:@"qq_on.png"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    self.ballView.layer.position = CGPointMake(LEFT_SPACE, 268);
    [self.view addSubview:self.ballView];
}

- (IBAction)gAction:(id)sender {
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    NSArray *array=@[(__bridge id)[UIColor blueColor].CGColor,
                     (__bridge id)[UIColor redColor].CGColor,
                     (__bridge id)[UIColor greenColor].CGColor,
                     (__bridge id)[UIColor blueColor].CGColor ];
    [KYSLayerAnimation keyframeAnimationWithLayer:_colorLayer
                                     keyPath:@"backgroundColor"
                                    duration:2.0
                                      values:array
                                    keyTimes:nil
                             timingFunctions:@[fn, fn, fn]
                                  completion:^(BOOL finished) {
        NSLog(@"缓冲");
    }];
}

- (IBAction)xialuoAction:(id)sender {
    self.ballView.center = CGPointMake(LEFT_SPACE, 32);
    self.ballView.layer.position = CGPointMake(LEFT_SPACE, 268);
    NSArray *values=@[[NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 32)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 268)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 140)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 268)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 220)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 268)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 250)],
                      [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 268)]];
    
    NSArray *keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    
    NSArray *timingFunctions = @[[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
    
    [KYSLayerAnimation keyframeAnimationWithLayer:self.ballView.layer keyPath:@"position" duration:1.0 values:values keyTimes:keyTimes timingFunctions:timingFunctions completion:^(BOOL finished) {
        NSLog(@"皮球下落");
    }];
}

- (IBAction)czAction:(id)sender {
    [self animate2];
}


//使用插入的值创建一个关键帧动画
float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

- (void)animate2
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(LEFT_SPACE, 32);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(LEFT_SPACE, 268)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1/(float)numFrames * i;
        //apply easing
        time = bounceEaseOut(time);//相当于做一个转换
        //add keyframe
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    //animation.delegate = self;
    animation.values = frames;
    //设置动画结束位置
    self.ballView.layer.position = CGPointMake(LEFT_SPACE, 268);
    //apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}




@end
