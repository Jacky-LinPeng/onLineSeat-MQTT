//
//  XPYSeatVC.m
//  XPYReader
//
//  Created by mac on 2021/8/17.
//  Copyright © 2021 xiang. All rights reserved.
//

#import "XPYSeatVC.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "XPYMQTTManager.h"

#define kXPYSeatTopic       @"kXPYSeatTopic"

@interface XPYSeatVC ()<XPYMQTTManagerProxy>


@end

@implementation XPYSeatVC

-(void)dealloc {
    [[XPYMQTTManager sharedInstance] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线选座";
    [self setupUI];
    
    [[XPYMQTTManager sharedInstance] addObserver:self];
    
    [[XPYMQTTManager sharedInstance] addSubscribeWithTopic:kXPYSeatTopic];
}

- (void)setupUI {
    CGFloat offset = 100;
    CGFloat margin = 10;
    int row = 6;
    int cloum = 6;
    CGFloat width = (XPYScreenWidth - margin * (row + 1)) / row;
    //行
    for (int i = 0; i < row; i++ ) {
        //列
        for (int j = 0; j < cloum; j++ ) {
            CGFloat left = margin + i * (width + margin);
            CGFloat top = offset + margin + j * (width + margin);
            //位置
            UIButton *btn = [UIButton new];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor grayColor];
            [self.view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@(width));
                make.top.equalTo(@(top));
                make.left.equalTo(@(left));
            }];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            
            btn.tag = i + j * cloum + 1; // 1....36
            
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"suo"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd5e6ca]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd58783]] forState:UIControlStateSelected];
        }
    }
}

-(void)clickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSMutableArray *selectList = [[NSMutableArray alloc] init];
    
    for (UIButton *btn in self.view.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.isSelected) {
            [selectList addObject:@(btn.tag)];
        }
    }
    
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    [[XPYMQTTManager sharedInstance] sendTxtMessage:@{@"data": selectList,@"sender":deviceID} topicId:kXPYSeatTopic];
}

//MARK: MQTT proxy
-(void)didReciveMessage:(NSDictionary *)data topicId:(NSString *)topicId {
    if (![topicId isEqualToString:kXPYSeatTopic]) {
        return;
    }
    NSArray *selectList = data[@"data"];
    
    //过滤自己触发的
    NSString *sender = data[@"sender"];
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if ([deviceID isEqualToString:sender]) {
        return;
    }
    
    for (UIButton *btn in self.view.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.isSelected) {
            btn.selected = NO;
        }
    }
    for (NSNumber *num in selectList) {
        UIButton *btn = [self.view viewWithTag:[num intValue]];
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = YES;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
