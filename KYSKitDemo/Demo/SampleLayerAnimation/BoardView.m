//
//  BoardView.m
//  KCoreAnimationDemo
//
//  Created by 康永帅 on 15/9/5.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "BoardView.h"

#define BRUSH_SIZE 32

@interface BoardView ()

@property (nonatomic, strong) NSMutableArray *strokes;

@end

@implementation BoardView

- (void)awakeFromNib
{
    //create array
    _strokes = [NSMutableArray array];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
   [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [_strokes addObject:[NSValue valueWithCGPoint:point]];
//    //needs redraw
//    [self setNeedsDisplay];
    //set dirty rect
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}
/*有时候用CAShapeLayer或者其他矢量图形图层替代Core Graphics并不是那么切实可行。
 比如我们的绘图应用：我们用线条完美地完成了矢量绘制。但是设想一下如果我们能进一步提
 高应用的性能，让它就像一个黑板一样工作，然后用『粉笔』来绘制线条。模拟粉笔最简单的
 方法就是用一个『线刷』图片然后将它粘贴到用户手指碰触的地方，但是这个方法用
 CAShapeLayer没办法实现*/
- (CGRect)brushRectForPoint:(CGPoint)point
{
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        //get brush rect
        CGRect brushRect = [self brushRectForPoint:point];
        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"sina_on.png"] drawInRect:brushRect];
        }
    }
}

@end
