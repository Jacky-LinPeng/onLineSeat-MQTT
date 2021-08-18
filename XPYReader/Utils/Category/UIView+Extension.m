//
//  UIView+Extension.m
//  peiwan
//
//  Created by 夏磊 on 2019/6/11.
//  Copyright © 2019 iydzq.com. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)fatherViewController {
    UIResponder *nextResponder = self.nextResponder;
    
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}

- (UITableView *)fatherTableView {
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UITableView class]]) {
            return (UITableView *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
        //        <span style="font-family: Arial, Helvetica, sans-serif;">//  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

-(void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors {
    [self addGradientLayerWithColors:colors style:GradientColorPointLeftToRight];
}

///背景渐变
- (void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors style:(GradientColorPoint)style {
    CAGradientLayer *layer = [CAGradientLayer new];
    NSMutableArray *colorList = [[NSMutableArray alloc] initWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [colorList addObject:(__bridge id)color.CGColor];
    }
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (style) {
        case GradientColorPointLeftToRight:
        {
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 0);
        }
            break;
        case GradientColorPointTopToBottom:
        {
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(0, 1);
        }
            break;
            
        default:
            break;
    }
    
    layer.colors = colorList;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    //按钮的image被遮挡兼容
    if([self isKindOfClass:[UIButton class]]) {
        [self bringSubviewToFront:((UIButton *)self).imageView];
    }
}

//MARK: 添加边框
-(void)addBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth type:(UIViewBorderType)type {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    switch (type) {
        case UIViewBorderTypeLeft: {
            border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
        }
            break;
        case UIViewBorderTypeRight: {
            border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
        }
            break;
        case UIViewBorderTypeTop: {
            border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
        }
            break;
        case UIViewBorderTypeBottom: {
            border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
        }
            break;
        default:{
            self.layer.borderColor = color.CGColor;
            self.layer.borderWidth = borderWidth;
        }
            break;
    }
    if (type != UIViewBorderTypeAll) {    
        [self.layer addSublayer:border];
    }
}

//抖动效果
- (void)addShakeAnimation {
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 3, position.y);
    CGPoint y = CGPointMake(position.x - 3, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

///指定位置添加圆角
- (void)addLayerCornerRadiusByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

@end
