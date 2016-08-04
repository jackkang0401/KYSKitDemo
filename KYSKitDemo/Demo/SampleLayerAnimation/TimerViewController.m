//
//  TimerViewController.m
//  KCoreAnimationDemo
//
//  Created by 康永帅 on 15/9/5.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@property (nonatomic, strong) UIImageView *ballView;

/*当你设置一个NSTimer，他会被插入到当前任务列表中，然后直到指定时间过去之后才会被执行。
 但是何时启动定时器并没有一个时间上限，而且它只会在列表中上一个任务完成之后开始执行。这通
 常会导致有几毫秒的延迟，但是如果上一个任务过了很久才完成就会导致延迟很长一段时间。*/
//@property (nonatomic, strong) NSTimer *timer;

/*用CADisplayLink而不是NSTimer，会保证帧率足够连续，使得动画看起来更加平滑，但即使
 CADisplayLink也不能保证每一帧都按计划执行，一些失去控制的离散的任务或者事件（例如资源紧张
 的后台程序）可能会导致动画偶尔地丢帧。当使用NSTimer的时候，一旦有机会计时器就会开启，但是
 CADisplayLink却不一样：如果它丢失了帧，就会直接忽略它们，然后在下一次更新的时候接着运行。*/
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval lastStep;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@end

@implementation TimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"sina_on.png"];
    _ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.view addSubview:_ballView];
    //animate
    [self animate];
}

- (float)interpolateFrom:(float)from to:(float) to time:(float)time
{
    return (to - from) * time + from;
}

- (float)bounceEaseOut:(float) t
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [(NSValue *)fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake([self interpolateFrom:from.x to:to.x time:time], [self interpolateFrom:from.y to:to.y time:time]);
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

- (void)animate
{
    //reset ball to top of screen
    _ballView.center = CGPointMake(150, 32);
    //configure the animation
    _duration = 1.0;
    _timeOffset = 0.0;
    _fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    _toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [_timer invalidate];
    //start the timer
    _lastStep = CACurrentMediaTime();
    _timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}

- (void)step:(NSTimer *)step
{
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    _lastStep = thisStep;
    //update time offset
    _timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = [self bounceEaseOut:time];
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    //move ball view to new position
    _ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (_timeOffset >= _duration) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
