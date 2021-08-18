//
//  UIView+Extension.h
//  peiwan
//
//  Created by 夏磊 on 2019/6/11.
//  Copyright © 2019 iydzq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//渐变
typedef enum : NSUInteger {
    GradientColorPointLeftToRight = 0,
    GradientColorPointTopToBottom,
} GradientColorPoint;

//边框
typedef enum : NSUInteger {
    UIViewBorderTypeAll = 0,
    UIViewBorderTypeLeft,
    UIViewBorderTypeRight,
    UIViewBorderTypeTop,
    UIViewBorderTypeBottom,
} UIViewBorderType;

@interface UIView (Extension)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

- (UIViewController *)fatherViewController;

- (UITableView *)fatherTableView;

- (UIViewController *)getCurrentVC;

- (void)removeAllSubviews;

///背景渐变
- (void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors;

///背景渐变
- (void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors style:(GradientColorPoint)style;

/// 添加边框
- (void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth type:(UIViewBorderType)type;

//抖动效果
- (void)addShakeAnimation;

///指定位置添加圆角
- (void)addLayerCornerRadiusByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii;

@end


