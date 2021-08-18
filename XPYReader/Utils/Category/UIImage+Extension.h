//
//  UIImage+Extension.h
//  peiwan
//
//  Created by 夏磊 on 2019/6/11.
//  Copyright © 2019 iydzq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)imageWithAlpha:(CGFloat)alpha;

- (UIImage *)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
- (UIImage *)fixOrientation;

/**
 *  通过颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 返回指定颜色尺寸为1*1的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  通过颜色生成图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return 返回指定颜色和尺寸的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/** image切圆角 */
- (UIImage*)imageWithCornerRadius:(CGFloat)radius;

/// 返回rtl Image
- (UIImage *)RTLImg;


@end


