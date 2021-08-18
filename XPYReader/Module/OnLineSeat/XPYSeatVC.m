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
    CGFloat offset = iPhoneBangs ? 80 : 64;
    //屏幕
    UILabel *iMaxView = [UILabel new];
    iMaxView.text = @"IMAX荧幕";
    iMaxView.font = [UIFont systemFontOfSize:13];
    iMaxView.textColor = [UIColor whiteColor];
    iMaxView.textAlignment = NSTextAlignmentCenter;
    iMaxView.backgroundColor = [UIColor colorWithHex:0xd58783];
    [self.view addSubview:iMaxView];
    [iMaxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(@(offset + 10));
        make.height.equalTo(@(30));
    }];
    
    offset += 50;
    
    //位置
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
            [btn setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]] forState:UIControlStateDisabled];
            
            btn.enabled = !(btn.tag == 15 || btn.tag == 16 || btn.tag == 23);
        }
    }
    
    offset += cloum * (width + margin) + 15;
    
    //底部
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton new];
            [self.view addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"suo"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd5e6ca]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd58783]] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]] forState:UIControlStateDisabled];
          
            btn.selected = i == 0;
            btn.enabled = i != 2;
            
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [btn setTitle:@"可选 " forState:UIControlStateNormal];
            [btn setTitle:@"已选 " forState:UIControlStateSelected];
            [btn setTitle:@"不可售" forState:UIControlStateDisabled];
            
            [arr addObject:btn];
        }
        [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:80 tailSpacing:80];
        // 设置array的垂直方向的约束
        [arr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(offset));
            make.height.equalTo(@30);
            make.width.equalTo(@60);
        }];
    }
    
    //电影名字
    {
        UILabel *iMaxView = [UILabel new];
        iMaxView.text = @"怒火 * 重案【国语 - 今日20:00】";
        iMaxView.font = [UIFont boldSystemFontOfSize:16];
//        iMaxView.textColor = [UIColor whiteColor];
////        iMaxView.textAlignment = NSTextAlignmentCenter;
//        iMaxView.backgroundColor = [UIColor colorWithHex:0xd58783];
        [self.view addSubview:iMaxView];
        [iMaxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.bottom.equalTo(@(-55));
            make.height.equalTo(@(30));
        }];
    }
    //购买
    {
        //位置
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(44));
            make.bottom.equalTo(@(0));
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
        }];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        
        [btn setTitle:@"购买" forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd58783]] forState:UIControlStateNormal];
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
