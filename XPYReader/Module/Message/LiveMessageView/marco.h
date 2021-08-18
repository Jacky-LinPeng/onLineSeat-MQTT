//
//  marco.h
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//

#ifndef marco_h
#define marco_h

#import "Masonry.h"

//Color
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define MessageMaxWidth ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait ? 220 : 280)
#define MessageMaxHeight    200

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)



#endif /* marco_h */
