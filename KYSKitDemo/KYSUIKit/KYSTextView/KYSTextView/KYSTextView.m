//
//  KYSTextView.m
//  KYSTextView
//
//  Created by 康永帅 on 16/6/2.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSTextView.h"

@implementation KYSTextView

- (instancetype)init{
    self=[super init];
    if(self){
        //self.scrollEnabled=YES; self.editable=NO;//这时才计算contentSize
        [self p_addTapGestureRecogniger];
    }
    return self;
}

- (void)awakeFromNib{
    [self p_addTapGestureRecogniger];
}

- (void)p_addTapGestureRecogniger{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UIGestureRecognizer *)ges{
    
    //给attributedText赋值时，text的内容也会刷新
    
    CGPoint tapPoint=[ges locationInView:ges.view];
    //NSLog(@"tap %@",NSStringFromCGPoint(tapPoint));
    
    CGPoint conOrigin=CGPointMake(self.textContainerInset.left, self.textContainerInset.top);
    //NSLog(@"origin %@",NSStringFromCGPoint(conOrigin));
    
    CGPoint tapConPoint=CGPointMake(tapPoint.x-conOrigin.x, tapPoint.y-conOrigin.y);
    //NSLog(@"tap origin %@",NSStringFromCGPoint(tapConPoint));
    
    CGFloat distance;
    NSInteger index = [self.layoutManager characterIndexForPoint:tapConPoint
                                                      inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:&distance];
    //NSLog(@"%ld   distance:%f",(long)index,distance);
    
    if (!self.text.length&&!self.attributedText.length) {
        return;
    }
    
    //注意0==index&&0==distavce, (text.length-1)==index&&1==distance
    //当满足这2个条件中的一个，需要忽略
    if ((0==index&&0==distance)||((self.text.length-1)==index&&1==distance)) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(textView:didTapAtCharactersIndex:)]){
        id <KYSTextViewDelegate> delegate  = (id<KYSTextViewDelegate>)self.delegate;
        [delegate textView:self didTapAtCharactersIndex:index];
    }
}

@end
