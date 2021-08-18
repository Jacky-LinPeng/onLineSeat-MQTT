//
//  XPYMessageInputView.h
//  XPYReader
//
//  Created by mac on 2021/8/16.
//  Copyright © 2021 xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSTIBDefaultHeight 44
#define kSTLeftButtonWidth 15//50
#define kSTLeftButtonHeight 30
#define kSTRightButtonWidth 34
#define kSTTextviewDefaultHeight 44
#define kSTTextviewMaxHeight 80

@interface XPYMessageInputView : UIView

+ (instancetype)inputBar;

@property (copy, nonatomic) NSString *placeHolder;

@property (assign, nonatomic) BOOL fitWhenKeyboardShowOrHide;

- (void)setDidSendClicked:(void(^)(XPYMessageInputView *view,NSString *text))handler;

- (void)setInputBarSizeChangedHandle:(void(^)())handler;

@end

NS_ASSUME_NONNULL_END
