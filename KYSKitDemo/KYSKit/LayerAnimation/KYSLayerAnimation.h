//
//  KYSLayerAnimation.h
//  KCoreAnimationDemo
//
//  Created by 康永帅 on 16/2/28.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KYSMediaTiming.h"

/*
 keypath:https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
 transform.rotation.y
 transform.rotation.z = 平面圖的旋轉
 transform.scale = 比例轉換
 transform.scale.x = 宽的比例轉換
 transform.scale.y = 高的比例轉換
 position = 位置
 position.x = 位置
 position.y = 位置
 backgroundColor = 背景色
 opacity = 透明度
 cornerRadius = 角度
 borderWidth = 边框宽度
 contents = 内容
 contentsRect = 内容矩形
 bounds = 大小
 shadowOffset = 阴影偏移
 shadowColor = 阴影颜色
 shadowRadius = 阴影角度
 
 //不可做动画
 frame = 位置
 hidden = 隐藏
 mask = 标记
 zPosition = 平面图的位置
 */

@interface KYSLayerAnimation : NSObject

#pragma mark - implicit animation(隐式动画)
/*
 1.隐式是因为我们并没有指定任何动画的类型。我们仅仅改变了一个属性(包含虚拟属性)，
 然后Core Animation来决定如何并且何时去做动画
 2.与UIView关联的图层禁用了隐式动画
 */
+ (void)implicitAnimateWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations;

+ (void)implicitAnimateWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations
                         completion:(void (^)(void))completion;

//如果action为空不会赋值
+ (void)implicitAnimateWithLayer:(CALayer *)layer
                         actions:(NSDictionary *)actions
                      animations:(void (^)(void))animations;

#pragma mark -  explicit animation(显示动画) CABasicAnimation 提供了对单一动画的实现
//生成CABasicAnimation对象
+ (CABasicAnimation *)basicAnimateWithKeyPath:(NSString *)keyPath
                                     duration:(NSTimeInterval)duration
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                                      byValue:(id)byValue;

+ (CABasicAnimation *)basicAnimateWithKeyPath:(NSString *)keyPath
                                     duration:(NSTimeInterval)duration
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                                      byValue:(id)byValue
                               timingFunction:(CAMediaTimingFunction *)timingFunction
                                  mediaTiming:(KYSMediaTiming *)mediaTiming;

//添加动画
+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      toValue:(id)toValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                   completion:(void (^)(BOOL finished))completion;

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      toValue:(id)toValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                  mediaTiming:(KYSMediaTiming *)mediaTiming
                   completion:(void (^)(BOOL finished))completion;

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      byValue:(id)byValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                   completion:(void (^)(BOOL finished))completion;

+ (void)basicAnimateWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                     duration:(NSTimeInterval)duration
                      byValue:(id)byValue
               timingFunction:(CAMediaTimingFunction *)timingFunction
                  mediaTiming:(KYSMediaTiming *)mediaTiming
                   completion:(void (^)(BOOL finished))completion;

#pragma mark -  explicit animation(显示动画) CAKeyframeAnimation 关键帧动画，包括定义动画路线
/*
 CApropertyAnimation的子类，跟CABasicAnimation的区别是：
 CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值 .
 
 属性解析
 values:
 就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧 .
 path:
 可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略 .
 keyTimes:
 可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的 .
 timeFunctions:
 用过UIKit层动画的同学应该对这个属性不陌生，这个属性用以指定时间函数，类似于运动的加速度，有以下几种类型。上例子的AB段就是用了淡入淡出效果。记住，这是一个数组，你有几个子路径就应该传入几个元素
 kCAMediaTimingFunctionLinear//线性
 kCAMediaTimingFunctionEaseIn//淡入
 kCAMediaTimingFunctionEaseOut//淡出
 kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
 kCAMediaTimingFunctionDefault//默认
 calculationMode属性:
 该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
 const kCAAnimationLinear//线性，默认
 const kCAAnimationDiscrete//离散，无中间过程，但keyTimes设置的时间依旧生效，物体跳跃地出现在各个关键帧上
 const kCAAnimationPaced//平均，keyTimes跟timeFunctions失效
 const kCAAnimationCubic//平均，同上
 const kCAAnimationCubicPaced//平均，同上
 
 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,这里的数学原理是Kochanek–Bartels spline,这里的主要目的是使得运行的轨迹变得圆滑;
 */
//生成CAKeyframeAnimation对象
+ (CAKeyframeAnimation *)keyframeAnimationWithKeyPath:(NSString *)keyPath
                                             duration:(NSTimeInterval)duration
                                               values:(NSArray *)values
                                                 path:(UIBezierPath *)path
                                         rotationMode:(id)rotationMode;

+ (CAKeyframeAnimation *)keyframeAnimationWithKeyPath:(NSString *)keyPath
                                             duration:(NSTimeInterval)duration
                                               values:(NSArray *)values
                                             keyTimes:(NSArray<NSNumber *> *)keyTimes
                                      timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                                       timingFunction:(CAMediaTimingFunction *)timingFunction
                                                 path:(UIBezierPath *)path
                                         rotationMode:(id)rotationMode
                                          mediaTiming:(KYSMediaTiming *)mediaTiming;

//添加动画
+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                              path:(UIBezierPath *)path
                      rotationMode:(id)rotationMode
                        completion:(void (^)(BOOL finished))completion;

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                              path:(UIBezierPath *)path
                      rotationMode:(id)rotationMode
                       mediaTiming:(KYSMediaTiming *)mediaTiming
                        completion:(void (^)(BOOL finished))completion;

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                        completion:(void (^)(BOOL finished))completion;

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                          keyTimes:(NSArray<NSNumber *> *)keyTimes
                   timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                        completion:(void (^)(BOOL finished))completion;

+ (void)keyframeAnimationWithLayer:(CALayer *)layer
                           keyPath:(NSString *)keyPath
                          duration:(NSTimeInterval)duration
                            values:(NSArray *)values
                          keyTimes:(NSArray<NSNumber *> *)keyTimes
                   timingFunctions:(NSArray<CAMediaTimingFunction *> *)timingFunctions
                    timingFunction:(CAMediaTimingFunction *)timingFunction
                       mediaTiming:(KYSMediaTiming *)mediaTiming
                        completion:(void (^)(BOOL finished))completion;

#pragma mark -  explicit animation(显示动画) CATransition 提供渐变效果
/* 过渡效果类型:
 fade           //交叉淡化过渡(不支持过渡方向)     kCATransitionFade
 push           //新视图把旧视图推出去            kCATransitionPush
 moveIn         //新视图移到旧视图上面            kCATransitionMoveIn
 reveal         //将旧视图移开,显示下面的新视图     kCATransitionReveal
 cube           //立方体翻滚效果
 oglFlip        //上下左右翻转效果
 suckEffect     //收缩效果，如一块布被抽走(不支持过渡方向)
 rippleEffect   //滴水效果(不支持过渡方向)
 pageCurl       //向上翻页效果
 pageUnCurl     //向下翻页效果
 cameraIrisHollowOpen  //相机镜
 */
//生成CATransition对象
+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction;

+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction
                             mediaTiming:(KYSMediaTiming *)mediaTiming;

+ (CATransition *)transitionWithDuration:(NSTimeInterval)duration
                                    type:(NSString *)type
                                 subtype:(NSString *)subtype
                          timingFunction:(CAMediaTimingFunction *)timingFunction
                           startProgress:(float)startProgress
                             endProgress:(float)endProgress
                             mediaTiming:(KYSMediaTiming *)mediaTiming;


//添加动画
+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
                mediaTiming:(KYSMediaTiming *)mediaTiming
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
              startProgress:(float)startProgress
                endProgress:(float)endProgress
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

+ (void)transitionWithLayer:(CALayer *)layer
                   duration:(NSTimeInterval)duration
                       type:(NSString *)type
                    subtype:(NSString *)subtype
             timingFunction:(CAMediaTimingFunction *)timingFunction
              startProgress:(float)startProgress
                endProgress:(float)endProgress
                mediaTiming:(KYSMediaTiming *)mediaTiming
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

#pragma mark -  explicit animation(显示动画) CAAnimationGroup
//生成CAAnimationGroup对象
+ (CAAnimationGroup *)animationGroupWithDuration:(NSTimeInterval)duration
                                      animations:(NSArray *)animations
                                  timingFunction:(CAMediaTimingFunction *)timingFunction;
+ (CAAnimationGroup *)animationGroupWithDuration:(NSTimeInterval)duration
                                      animations:(NSArray *)animations
                                  timingFunction:(CAMediaTimingFunction *)timingFunction
                                     mediaTiming:(KYSMediaTiming *)mediaTiming;

//添加动画
+ (void)animationGroupWithLayer:(CALayer *)layer
                       duration:(NSTimeInterval)duration
                     animations:(NSArray *)animations
                 timingFunction:(CAMediaTimingFunction *)timingFunction
                     completion:(void (^)(BOOL finished))completion;

+ (void)animationGroupWithLayer:(CALayer *)layer
                       duration:(NSTimeInterval)duration
                     animations:(NSArray *)animations
                 timingFunction:(CAMediaTimingFunction *)timingFunction
                    mediaTiming:(KYSMediaTiming *)mediaTiming
                     completion:(void (^)(BOOL finished))completion;

#pragma mark -  explicit animation(显示动画) CASpringAnimation(继承于CABasicAnimation) 提供弹簧效果
/*
 iOS9才引入的动画类，它继承于CABaseAnimation，用于制作弹簧动画，先演示个例子
 1. 参数说明
 mass:质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大.
 stiffness:刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
 damping:阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
 initialVelocity:初始速率，动画视图的初始速度大小速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
 settlingDuration:结算时间返回弹簧动画到停止时的估算时间，根据当前的动画参数估算通常弹簧动画的时间使用结算时间比较准确
 */
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
                                timingFunction:(CAMediaTimingFunction *)timingFunction;

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
                                    mediaTiming:(KYSMediaTiming *)mediaTiming;

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
                    completion:(void (^)(BOOL finished))completion;

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
                    completion:(void (^)(BOOL finished))completion;
#endif




@end
