//
//  KYSLayerAnimation.m
//  KCoreAnimationDemo
//
//  Created by 康永帅 on 16/2/28.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSLayerAnimation.h"

@implementation KYSLayerAnimation


#pragma mark - implicit animation(隐式动画)
+ (void)implicitAnimateWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations{
    [self implicitAnimateWithDuration:duration
                           animations:animations
                           completion:nil];
}

+ (void)implicitAnimateWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations
                         completion:(void (^)(void))completion{
    //begin a new transaction
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:duration];
    //add the spin animation on completion
    if (completion) {
        [CATransaction setCompletionBlock:completion];
    }
    //执行动画
    animations();
    //commit the transaction
    [CATransaction commit];
}

/*
 当CALayer的属性被修改时候，它会调用-actionForKey:方法，传递属性的名称。-actionForKey:方法执行过程
 1.图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
 2.如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
 3.如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
 4.最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法
 */
+ (void)implicitAnimateWithLayer:(CALayer *)layer
                         actions:(NSDictionary *)actions
                      animations:(void (^)(void))animations{
    /*
     eg.
     CATransition *transition = [CATransition animation];
     transition.duration=3.0;
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     layer.actions = @{@"backgroundColor": transition};
     */
    if(actions){
        layer.actions=actions;
    }
    animations();
}

#pragma mark -  animation(显示动画) CABasicAnimation
//生成CABasicAnimation对象
+ (CABasicAnimation *)basicAnimateWithKeyPath:(NSString *)keyPath
                                     duration:(NSTimeInterval)duration
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                                      byValue:(id)byValue{
    return [self basicAnimateWithKeyPath:keyPath duration:duration fromValue:fromValue toValue:toValue byValue:byValue timingFunction:nil mediaTiming:nil];
}

+ (CABasicAnimation *)basicAnimateWithKeyPath:(NSString *)keyPath
                                     duration:(NSTimeInterval)duration
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                                      byValue:(id)byValue
                               timingFunction:(CAMediaTimingFunction *)timingFunction
                                  mediaTiming:(KYSMediaTiming *)mediaTiming{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = keyPath;
    animation.duration=duration;
    if (fromValue) {
        animation.fromValue = fromValue;
    }
    if (toValue) {
        animation.toValue = toValue;
    }
    if (byValue) {
        animation.byValue = byValue;
    }
    if (timingFunction) {
        animation.timingFunction=timingFunction;
    }
    
    if (mediaTiming) {
        animation.repeatCount = mediaTiming.repeatCount;
        animation.repeatDuration = mediaTiming.repeatDuration;  //INFINITY 最大值
        animation.timeOffset = mediaTiming.timeOffset;
        animation.beginTime=mediaTiming.beginTime;
        animation.speed=mediaTiming.speed;
        animation.autoreverses = mediaTiming.autoreverses;      //默认NO 在每次间隔交替循环过程中自动回放
        if (mediaTiming.fillMode) {
            animation.fillMode=mediaTiming.fillMode;
        }
    }
    return animation;
}

//添加动画
+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      toValue:(id)toValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                   completion:(void (^)(BOOL finished))completion{
    [self p_BasicAnimateWithLayer:layer keyPath:keyPath duration:duration fromValue:nil toValue:toValue  byValue:nil timingFunction:timingFunction mediaTiming:nil completion:completion];
}

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      toValue:(id)toValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                  mediaTiming:(KYSMediaTiming *)mediaTiming
                   completion:(void (^)(BOOL finished))completion{
    [self p_BasicAnimateWithLayer:layer keyPath:keyPath duration:duration fromValue:nil toValue:toValue byValue:nil timingFunction:timingFunction mediaTiming:mediaTiming completion:completion];
}

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      byValue:(id)byValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                   completion:(void (^)(BOOL finished))completion{
    [self p_BasicAnimateWithLayer:layer keyPath:keyPath duration:duration fromValue:nil toValue:nil byValue:byValue timingFunction:timingFunction mediaTiming:nil completion:completion];
}

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      byValue:(id)byValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                  mediaTiming:(KYSMediaTiming *)mediaTiming
                   completion:(void (^)(BOOL finished))completion{
    [self p_BasicAnimateWithLayer:layer keyPath:keyPath duration:duration fromValue:nil toValue:nil byValue:byValue timingFunction:timingFunction mediaTiming:mediaTiming completion:completion];
}

//添加动画，并禁用隐式动画
+ (void)p_applyBasicAnimation:(CAAnimation *)animation toLayer:(CALayer *)layer
{
    if ([animation isMemberOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnimation=(CABasicAnimation *)animation;
        //如果这里已经正在进行一段动画，我们需要从呈现图层那里去获得fromValue，而不是模型图层
        basicAnimation.fromValue = [layer.presentationLayer valueForKeyPath:basicAnimation.keyPath];
    }
    //禁用隐式动画(实际上，显式动画通常会覆盖隐式动画，所以为了安全最好这么做)
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if ([animation isMemberOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnimation=(CABasicAnimation *)animation;
        if (basicAnimation.toValue) {
            //修改图层最终值
            [layer setValue:basicAnimation.toValue forKeyPath:basicAnimation.keyPath];
        }
    }
    [CATransaction commit];
    
    [layer addAnimation:animation forKey:nil];
}

+ (void)p_BasicAnimateWithLayer:(CALayer *)layer
                        keyPath:(NSString *)keyPath
                       duration:(NSTimeInterval)duration
                      fromValue:(id)fromValue
                        toValue:(id)toValue
                        byValue:(id)byValue
                 timingFunction:(CAMediaTimingFunction *)timingFunction
                    mediaTiming:(KYSMediaTiming *)mediaTiming
                     completion:(void (^)(BOOL finished))completion{
    CABasicAnimation *animation = [self basicAnimateWithKeyPath:keyPath duration:duration fromValue:fromValue toValue:toValue byValue:byValue timingFunction:timingFunction mediaTiming:mediaTiming];
    animation.delegate=[self p_delegateAnimation];
    //可以通过KVC（键-值-编码）协议，来判断是哪个视图上的哪个动画
    NSMutableDictionary *dic=[@{@"layer":layer} mutableCopy];
    if (completion) {
        [dic setObject:[completion copy] forKey:@"block"];
    }
    [animation setValue:dic forKey:@"identifier"];
    //apply animation without snap-back
    [self p_applyBasicAnimation:animation toLayer:layer];
}

#pragma mark -  animation(显示动画) CAKeyframeAnimation
//生成CAKeyframeAnimation对象
+ (CAKeyframeAnimation *)keyframeAnimationWithKeyPath:(NSString *)keyPath
                                             duration:(NSTimeInterval)duration
                                               values:(NSArray *)values
                                                 path:(UIBezierPath *)path
                                         rotationMode:(id)rotationMode{
    return [self keyframeAnimationWithKeyPath:keyPath duration:duration values:values keyTimes:nil timingFunctions:nil timingFunction:nil path:path rotationMode:rotationMode mediaTiming:nil];
}

+ (CAKeyframeAnimation *)keyframeAnimationWithKeyPath:(NSString *)keyPath
                                             duration:(NSTimeInterval)duration
                                               values:(NSArray *)values
                                             keyTimes:(NSArray<NSNumber *> *)keyTimes
                                      timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                                       timingFunction:(CAMediaTimingFunction *)timingFunction
                                                 path:(UIBezierPath *)path
                                         rotationMode:(id)rotationMode
                                          mediaTiming:(KYSMediaTiming *)mediaTiming{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = keyPath;
    animation.duration=duration;
    if (values && values.count) {
        animation.values=values;
    }
    if (keyTimes && keyTimes.count) {
        animation.keyTimes=keyTimes;
    }
    if (timingFunctions && timingFunctions.count) {
        animation.timingFunctions=timingFunctions;
    }
    if(timingFunction){
        animation.timingFunction=timingFunction;
    }
    if (path) {
        animation.path = path.CGPath;
    }
    if (rotationMode) {
        animation.rotationMode = rotationMode;//图层将会根据曲线的切线自动旋转
    }
    if (mediaTiming) {
        animation.repeatCount = mediaTiming.repeatCount;
        animation.repeatDuration = mediaTiming.repeatDuration;  //INFINITY 最大值
        animation.timeOffset = mediaTiming.timeOffset;
        animation.beginTime=mediaTiming.beginTime;
        animation.speed=mediaTiming.speed;
        animation.autoreverses = mediaTiming.autoreverses;      //默认NO 在每次间隔交替循环过程中自动回放
        if (mediaTiming.fillMode) {
            animation.fillMode=mediaTiming.fillMode;
        }
    }
    return animation;
}

//添加动画
+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                              path:(UIBezierPath *)path
                      rotationMode:(id)rotationMode
                        completion:(void (^)(BOOL finished))completion{
    [self keyframeAnimationWithLayer:layer keyPath:keyPath duration:duration timingFunction:timingFunction path:path rotationMode:rotationMode mediaTiming:nil completion:completion];
}

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                              path:(UIBezierPath *)path
                      rotationMode:(id)rotationMode
                       mediaTiming:(KYSMediaTiming *)mediaTiming
                        completion:(void (^)(BOOL finished))completion{
    [self p_KeyframeAnimationWithLayer:layer keyPath:keyPath duration:duration values:nil keyTimes:nil timingFunctions:nil timingFunction:timingFunction path:path rotationMode:rotationMode mediaTiming:mediaTiming completion:completion];
}

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                        completion:(void (^)(BOOL finished))completion{
    [self keyframeAnimationWithLayer:layer keyPath:keyPath duration:duration values:values keyTimes:nil timingFunctions:nil timingFunction:nil mediaTiming:nil completion:completion];
}

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                          keyTimes:(NSArray<NSNumber *> *)keyTimes
                   timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                        completion:(void (^)(BOOL finished))completion{
    [self p_KeyframeAnimationWithLayer:layer keyPath:keyPath duration:duration values:values keyTimes:keyTimes timingFunctions:timingFunctions timingFunction:nil path:nil rotationMode:nil mediaTiming:nil completion:completion];
}

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                          keyTimes:(NSArray<NSNumber *> *)keyTimes
                   timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                       mediaTiming:(KYSMediaTiming *)mediaTiming
                        completion:(void (^)(BOOL finished))completion{
    [self p_KeyframeAnimationWithLayer:layer keyPath:keyPath duration:duration values:values keyTimes:keyTimes timingFunctions:timingFunctions timingFunction:timingFunction path:nil rotationMode:nil mediaTiming:mediaTiming completion:completion];
}

+ (void)p_KeyframeAnimationWithLayer:(CALayer *)layer
                             keyPath:(NSString *)keyPath
                            duration:(NSTimeInterval)duration
                              values:(NSArray *)values
                            keyTimes:(NSArray<NSNumber *> *)keyTimes
                     timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                      timingFunction:(CAMediaTimingFunction *)timingFunction
                                path:(UIBezierPath *)path
                        rotationMode:(id)rotationMode
                         mediaTiming:(KYSMediaTiming *)mediaTiming
                          completion:(void (^)(BOOL finished))completion{
    CAKeyframeAnimation *animation=[self keyframeAnimationWithKeyPath:keyPath duration:duration values:values keyTimes:keyTimes timingFunctions:timingFunctions timingFunction:timingFunction path:path rotationMode:rotationMode mediaTiming:mediaTiming];
    animation.delegate=[self p_delegateAnimation];
    //可以通过KVC（键-值-编码）协议，来判断是哪个视图上的哪个动画
    NSMutableDictionary *dic=[@{@"layer":layer} mutableCopy];
    if (completion) {
        [dic setObject:[completion copy] forKey:@"block"];
    }
    [animation setValue:dic forKey:@"identifier"];
    //apply animation without snap-back
    [layer addAnimation:animation forKey:nil];
}

#pragma mark -  animation(显示动画) CATransition
//生成CATransition对象
+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction{
    return [self transitionWithDuration:duration type:type subtype:subtype timingFunction:timingFunction startProgress:0.0 endProgress:1.0 mediaTiming:nil];
}

+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction
                             mediaTiming:(KYSMediaTiming *)mediaTiming{
    return [self transitionWithDuration:duration type:type subtype:subtype timingFunction:timingFunction startProgress:0.0 endProgress:1.0 mediaTiming:mediaTiming];
}

+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction
                           startProgress:(float)startProgress
                             endProgress:(float)endProgress
                             mediaTiming:(KYSMediaTiming *)mediaTiming{
    CATransition *transition = [CATransition animation];
    transition.duration=duration;
    /*
     kCATransitionFade   fade     交叉淡化过渡(不支持过渡方向)
     kCATransitionMoveIn moveIn   新视图移到旧视图上面
     kCATransitionPush   push     新视图把旧视图推出去
     kCATransitionReveal reveal   将旧视图移开,显示下面的新视图
     默认 fade 无常量定义
     2.用字符串表示
     //注意：私有API效果，使用的时候要小心，可能会导致app审核不被通过
     pageCurl            向上翻一页
     pageUnCurl          向下翻一页
     rippleEffect        滴水效果(不支持过渡方向)
     suckEffect          收缩效果，如一块布被抽走(不支持过渡方向)
     cube                立方体效果
     oglFlip             上下翻转效果
     cameraIrisHollowOpen  //相机打开
     cameraIrisHollowClose //相机关闭
     */
    transition.type = type;
    transition.subtype = subtype;
    if (timingFunction) {
        transition.timingFunction=timingFunction;
    }
    transition.startProgress=startProgress;
    transition.endProgress=endProgress;
    if (mediaTiming) {
        transition.repeatCount = mediaTiming.repeatCount;
        transition.repeatDuration = mediaTiming.repeatDuration;  //INFINITY 最大值
        transition.timeOffset = mediaTiming.timeOffset;
        transition.beginTime=mediaTiming.beginTime;
        transition.speed=mediaTiming.speed;
        transition.autoreverses = mediaTiming.autoreverses;      //默认NO 在每次间隔交替循环过程中自动回放
        if (mediaTiming.fillMode) {
            transition.fillMode=mediaTiming.fillMode;
        }
    }
    return transition;
}

//添加动画
+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion{
    [self transitionWithLayer:layer duration:duration type:type subtype:subtype timingFunction:timingFunction startProgress:0.0 endProgress:1.0 mediaTiming:nil animations:animations completion:completion];
}

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
                mediaTiming:(KYSMediaTiming *)mediaTiming
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion{
    [self transitionWithLayer:layer duration:duration type:type subtype:subtype
               timingFunction:timingFunction startProgress:0.0 endProgress:1.0 mediaTiming:mediaTiming animations:animations completion:completion];
}

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
              startProgress:(float)startProgress
                endProgress:(float)endProgress
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion{
    [self transitionWithLayer:layer duration:duration type:type subtype:subtype timingFunction:timingFunction startProgress:startProgress endProgress:endProgress mediaTiming:nil animations:animations completion:completion];
}

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
              startProgress:(float)startProgress
                endProgress:(float)endProgress
                mediaTiming:(KYSMediaTiming *)mediaTiming
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion{
    CATransition *transition = [self transitionWithDuration:duration type:type subtype:subtype timingFunction:timingFunction startProgress:startProgress endProgress:endProgress mediaTiming:mediaTiming];
    transition.delegate=[self p_delegateAnimation];
    NSMutableDictionary *dic=[@{@"layer":layer} mutableCopy];
    if (completion) {
        [dic setObject:[completion copy] forKey:@"block"];
    }
    [transition setValue:dic forKey:@"identifier"];
    
    animations();
    [layer addAnimation:transition forKey:nil];
}

#pragma mark -  animation(显示动画) CAAnimationGroup
//生成CAAnimationGroup对象
+ (CAAnimationGroup *)animationGroupWithDuration:(NSTimeInterval)duration
                                      animations:(NSArray *)animations
                                  timingFunction:(CAMediaTimingFunction *)timingFunction{
    return [self animationGroupWithDuration:duration animations:animations timingFunction:timingFunction mediaTiming:nil];;
}
+ (CAAnimationGroup *)animationGroupWithDuration:(NSTimeInterval)duration
                                      animations:(NSArray *)animations
                                  timingFunction:(CAMediaTimingFunction *)timingFunction
                                     mediaTiming:(KYSMediaTiming *)mediaTiming{
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = duration;
    groupAnimation.animations = animations;
    if (timingFunction) {
        groupAnimation.timingFunction=timingFunction;
    }
    if (mediaTiming) {
        groupAnimation.repeatCount = mediaTiming.repeatCount;
        groupAnimation.repeatDuration = mediaTiming.repeatDuration;  //INFINITY 最大值
        groupAnimation.timeOffset = mediaTiming.timeOffset;
        groupAnimation.beginTime=mediaTiming.beginTime;
        groupAnimation.speed=mediaTiming.speed;
        groupAnimation.autoreverses = mediaTiming.autoreverses;      //默认NO 在每次间隔交替循环过程中自动回放
        if (mediaTiming.fillMode) {
            groupAnimation.fillMode=mediaTiming.fillMode;
        }
    }
    return groupAnimation;
}

//添加动画
+ (void)animationGroupWithLayer:(CALayer *)layer
                       duration:(NSTimeInterval)duration
                     animations:(NSArray *)animations
                 timingFunction:(CAMediaTimingFunction *)timingFunction
                     completion:(void (^)(BOOL finished))completion{
    [self animationGroupWithLayer:layer duration:duration animations:animations timingFunction:timingFunction mediaTiming:nil completion:completion];
}

+ (void)animationGroupWithLayer:(CALayer *)layer
                       duration:(NSTimeInterval)duration
                     animations:(NSArray *)animations
                 timingFunction:(CAMediaTimingFunction *)timingFunction
                    mediaTiming:(KYSMediaTiming *)mediaTiming
                     completion:(void (^)(BOOL finished))completion{
    CAAnimationGroup *groupAnimation = [self animationGroupWithDuration:duration animations:animations timingFunction:timingFunction mediaTiming:mediaTiming];
    NSMutableDictionary *dic=[@{@"layer":layer} mutableCopy];
    if (completion) {
        [dic setObject:[completion copy] forKey:@"block"];
    }
    [groupAnimation setValue:dic forKey:@"identifier"];
    groupAnimation.delegate=[self p_delegateAnimation];
    [layer addAnimation:groupAnimation forKey:nil];
}

#pragma mark -  explicit animation(显示动画) CASpringAnimation(继承于CABasicAnimation) 提供弹簧效果
//生成CASpringAnimation对象
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
+ (CASpringAnimation *)spingAnimateWithKeyPath:(NSString *)keyPath
                                          mass:(CGFloat)mass
                                     stiffness:(CGFloat)stiffness
                                       damping:(CGFloat)damping
                               initialVelocity:(CGFloat)initialVelocity
                                      duration:(NSTimeInterval)duration
                                     fromValue:(id)fromValue
                                       toValue:(id)toValue
                                       byValue:(id)byValue
                                timingFunction:(CAMediaTimingFunction *)timingFunction{
    return [self springAnimateWithKeyPath:keyPath mass:mass stiffness:stiffness damping:damping initialVelocity:initialVelocity duration:duration fromValue:fromValue toValue:toValue byValue:byValue timingFunction:timingFunction mediaTiming:nil];
}

+ (CASpringAnimation *)springAnimateWithKeyPath:(NSString *)keyPath
                                           mass:(CGFloat)mass
                                      stiffness:(CGFloat)stiffness
                                        damping:(CGFloat)damping
                                initialVelocity:(CGFloat)initialVelocity
                                       duration:(NSTimeInterval)duration
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue
                                        byValue:(id)byValue
                                 timingFunction:(CAMediaTimingFunction *)timingFunction
                                    mediaTiming:(KYSMediaTiming *)mediaTiming{
    CASpringAnimation *animation = [CASpringAnimation animation];
    animation.keyPath = keyPath;
    animation.mass=mass;
    animation.stiffness=stiffness;
    animation.damping=damping;
    animation.initialVelocity=initialVelocity;
    if (fromValue) {
        animation.fromValue = fromValue;
    }
    if (toValue) {
        animation.toValue = toValue;
    }
    if (byValue) {
        animation.byValue = byValue;
    }
    if (timingFunction) {
        animation.timingFunction=timingFunction;
    }
    if (mediaTiming) {
        animation.repeatCount = mediaTiming.repeatCount;
        animation.repeatDuration = mediaTiming.repeatDuration;  //INFINITY 最大值
        animation.timeOffset = mediaTiming.timeOffset;
        animation.beginTime=mediaTiming.beginTime;
        animation.speed=mediaTiming.speed;
        animation.autoreverses = mediaTiming.autoreverses;      //默认NO 在每次间隔交替循环过程中自动回放
        if (mediaTiming.fillMode) {
            animation.fillMode=mediaTiming.fillMode;
        }
    }
    animation.duration=duration?duration:animation.settlingDuration;
    return animation;
}

//添加动画
+ (void)springAnimateWithLayer:(CALayer *)layer
                       keyPath:(NSString *)keyPath
                          mass:(CGFloat)mass
                     stiffness:(CGFloat)stiffness
                       damping:(CGFloat)damping
               initialVelocity:(CGFloat)initialVelocity
                      duration:(NSTimeInterval)duration
                     fromValue:(id)fromValue
                       toValue:(id)toValue
                       byValue:(id)byValue
                timingFunction:(CAMediaTimingFunction *)timingFunction
                    completion:(void (^)(BOOL finished))completion{
    [self springAnimateWithLayer:(CALayer *)layer keyPath:keyPath mass:mass stiffness:stiffness damping:damping initialVelocity:initialVelocity duration:duration fromValue:fromValue toValue:toValue byValue:byValue timingFunction:timingFunction mediaTiming:nil completion:completion];
}

+ (void)springAnimateWithLayer:(CALayer *)layer
                       keyPath:(NSString *)keyPath
                          mass:(CGFloat)mass
                     stiffness:(CGFloat)stiffness
                       damping:(CGFloat)damping
               initialVelocity:(CGFloat)initialVelocity
                      duration:(NSTimeInterval)duration
                     fromValue:(id)fromValue
                       toValue:(id)toValue
                       byValue:(id)byValue
                timingFunction:(CAMediaTimingFunction *)timingFunction
                   mediaTiming:(KYSMediaTiming *)mediaTiming
                    completion:(void (^)(BOOL finished))completion{
    CASpringAnimation *animation=[self springAnimateWithKeyPath:keyPath mass:mass stiffness:stiffness damping:damping initialVelocity:initialVelocity duration:duration fromValue:fromValue toValue:toValue byValue:byValue timingFunction:timingFunction mediaTiming:mediaTiming];
    animation.delegate=[self p_delegateAnimation];
    //可以通过KVC（键-值-编码）协议，来判断是哪个视图上的哪个动画
    NSMutableDictionary *dic=[@{@"layer":layer} mutableCopy];
    if (completion) {
        [dic setObject:[completion copy] forKey:@"block"];
    }
    [animation setValue:dic forKey:@"identifier"];
    //apply animation without snap-back
    [layer addAnimation:animation forKey:nil];
}
#endif


#pragma mark CAAnimationDelegate
//委托传入的动画参数是原始值的一个深拷贝，不是同一个值
- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag
{
//    NSLog(@"动画结束");
//    NSLog(@"%@",[animation valueForKey:@"identifier"]);
    NSDictionary *dic=[animation valueForKey:@"identifier"];
    id block = dic[@"block"];
    if (block) {
        ((void (^)(BOOL))block)(flag);
    }
}

+ (KYSLayerAnimation *)p_delegateAnimation{
    static KYSLayerAnimation *delegateAnimation=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        delegateAnimation=[[[self class] alloc] init];
    });
    return delegateAnimation;
}

@end
