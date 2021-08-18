//
//  UIColor+Extension.h
//  peiwan
//
//  Created by 夏磊 on 2019/6/11.
//  Copyright © 2019 iydzq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

- (CGFloat)getRed;
- (CGFloat)getGreen;
- (CGFloat)getBlue;

+ (UIColor *)colorRatio:(CGFloat)ratio fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

@end


