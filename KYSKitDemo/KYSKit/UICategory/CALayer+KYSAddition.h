//
//  CALayer+KYSAddition.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/25.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UIColor;

@interface CALayer (KYSAddition)

@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGPoint center;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize  size;

@property (nonatomic,assign) CGFloat transformRotation;     //"tranform.rotation"
@property (nonatomic,assign) CGFloat transformRotationX;    //"tranform.rotation.x"
@property (nonatomic,assign) CGFloat transformRotationY;    //"tranform.rotation.y"
@property (nonatomic,assign) CGFloat transformRotationZ;    //"tranform.rotation.z"
@property (nonatomic,assign) CGFloat transformScale;        //"tranform.scale"
@property (nonatomic,assign) CGFloat transformScaleX;       //"tranform.scale.x"
@property (nonatomic,assign) CGFloat transformScaleY;       //"tranform.scale.y"
@property (nonatomic,assign) CGFloat transformScaleZ;       //"tranform.scale.z"
@property (nonatomic,assign) CGFloat transformTranslationX; //"tranform.translation.x"
@property (nonatomic,assign) CGFloat transformTranslationY; //"tranform.translation.y"
@property (nonatomic,assign) CGFloat transformTranslationZ; //"tranform.translation.z"
@property (nonatomic,assign) CGFloat transformDepth;

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

- (void)removeAllSublayers;

@end
