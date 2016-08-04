//
//  DrawView.m
//  KCoreAnimationDemo
//
//  Created by 康永帅 on 15/9/5.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawView

+ (Class)layerClass
{
    //this makes our view create a CAShapeLayer
    //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
}

- (void)awakeFromNib
{
    //create a mutable path
    _path = [[UIBezierPath alloc] init];
    //configure the layer
    /*用CAShapeLayer替代Core Graphics，性能就会得到提高（见清单13.2）.
     虽然随着路径复杂性的增加，绘制性能依然会下降，但是只有当非常非常浮躁的
     绘制时才会感到明显的帧率差异。*/
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = 5;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [_path moveToPoint:point];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add a new line segment to our path
    [_path addLineToPoint:point];
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = _path.CGPath;
}

@end
