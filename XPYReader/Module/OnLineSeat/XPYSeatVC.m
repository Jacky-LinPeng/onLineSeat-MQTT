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
#import "XYPButton.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

#define kXPYSeatTopic       @"kXPYSeatTopic"
#define kTicket             65
#define kRowCount       6


@interface XPYSeatVC ()<XPYMQTTManagerProxy>
{
    UIButton *payBtn;
    UIView *contentView;
}
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) NSMutableArray *mySelectList;
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
    
    // 添加检测app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationWillResignActiveNotification object:nil];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    contentView = [UIView new];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    
    CGFloat offset = 0;//iPhoneBangs ? 80 : 64;
    //屏幕
    UILabel *iMaxView = [UILabel new];
    iMaxView.text = @"IMAX荧幕";
    iMaxView.font = [UIFont systemFontOfSize:13];
    iMaxView.textColor = [UIColor whiteColor];
    iMaxView.textAlignment = NSTextAlignmentCenter;
    iMaxView.backgroundColor = [UIColor colorWithHex:0xd58783];
    [contentView addSubview:iMaxView];
    [iMaxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(offset + 10));
        make.height.equalTo(@(30));
    }];
    
    offset += 50;
    
    //位置
    CGFloat margin = 10;
    int row = kRowCount;
    int cloum = kRowCount;
    CGFloat width = (XPYScreenWidth - margin * (row + 1)) / row;
    //行
    for (int i = 0; i < row; i++ ) {
        //列
        for (int j = 0; j < cloum; j++ ) {
            CGFloat left = margin + i * (width + margin);
            CGFloat top = offset + margin + j * (width + margin);
            //位置
            XYPButton *btn = [XYPButton new];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];
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
            [contentView addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.tag = 10000 + i;
            
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"suo"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd5e6ca]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd58783]] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]] forState:UIControlStateDisabled];
          
            btn.selected = i == 0;
            btn.enabled = i != 2;
            
            btn.userInteractionEnabled = NO;
            
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
    
    offset += 60;
    
    //电影名字
    {
        UILabel *iMaxView = [UILabel new];
        iMaxView.text = @"怒火 * 重案【国语 - 今日20:00】";
        iMaxView.font = [UIFont boldSystemFontOfSize:16];
//        iMaxView.textColor = [UIColor whiteColor];
////        iMaxView.textAlignment = NSTextAlignmentCenter;
//        iMaxView.backgroundColor = [UIColor colorWithHex:0xd58783];
        [scrollView addSubview:iMaxView];
        [iMaxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@(offset));
            make.height.equalTo(@(30));
        }];
    }
    
    offset += 40;
    {
        [contentView addSubview:self.tagView];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
            make.top.equalTo(@(offset));
            make.height.equalTo(@0);
        }];
    }
    
    //购买
    {
        UIButton *btn = [UIButton new];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(44));
            make.top.equalTo(self.tagView.mas_bottom).offset(10);
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
        }];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        
        [btn setTitle:@"购买" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd58783]] forState:UIControlStateNormal];
        
        payBtn = btn;
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_bottom).offset(130);
        }];
        
    }
    offset += 160;
}

-(void)buyAction:(UIButton *)sender {
    [MBProgressHUD xpy_showTips:@"购买成功！"];
}

-(void)clickAction:(XYPButton *)sender {
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (sender.isSelected) {
        if (sender.owner && ![sender.owner isEqualToString:deviceID]) {
            [MBProgressHUD xpy_showTips:@"该位置已被选"];
            return;
        }
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.mySelectList addObject:@(sender.tag)];
    } else {
        if ([self.mySelectList containsObject:@(sender.tag)]) {
            [self.mySelectList removeObject:@(sender.tag)];
        }
    }
    
    NSMutableArray *selectList = [[NSMutableArray alloc] init];
    for (XYPButton *btn in contentView.subviews) {
        if ([btn isKindOfClass:[XYPButton class]] && btn.isSelected && btn.tag > 0) {
            [selectList addObject:@{@"tag": @(btn.tag),@"sender": btn.owner ? btn.owner : deviceID}];
        }
    }
    
    [[XPYMQTTManager sharedInstance] sendTxtMessage:@{@"data": selectList,@"sender":deviceID} topicId:kXPYSeatTopic];
    
    //已选tag更新
    [self addTagViewWithText:self.mySelectList];
    //按钮刷新
    NSString *title = @"购买";
    if (selectList.count > 0) {
        title = [NSString stringWithFormat:@"￥%ld确认选座",kTicket * selectList.count];
    }
    [payBtn setTitle:title forState:UIControlStateNormal];
}

-(void)addTagViewWithText:(NSArray *)list {
    // Style1
    TTGTextTagStringContent *content = [TTGTextTagStringContent new];
    TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent new];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
    
    content.textFont = [UIFont systemFontOfSize:14];
    selectedContent.textFont = content.textFont;
    
    content.textColor = [UIColor whiteColor];
    selectedContent.textColor = [UIColor whiteColor];
    
    style.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    selectedStyle.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    style.shadowColor = [UIColor grayColor];
    style.shadowOffset = CGSizeMake(0, 0);
    style.shadowOpacity = 0.0f;
    style.shadowRadius = 0;

    selectedStyle.shadowColor = [UIColor grayColor];
    selectedStyle.shadowOffset = CGSizeMake(0, 0);
    selectedStyle.shadowOpacity = 0.0f;
    selectedStyle.shadowRadius = 0;
    

    style.cornerRadius = 8;
    selectedStyle.cornerRadius = 8;
    
    style.extraSpace = CGSizeMake(14, 14);
    selectedStyle.extraSpace = style.extraSpace;

    [self.tagView removeAllTags];
    NSMutableArray *tags = [NSMutableArray new];
    for (NSNumber *value in list) {
        int temp = [value intValue];
        int row = temp / kRowCount + 1;
        int clo = temp % kRowCount;
        NSString *string = [NSString stringWithFormat:@" %d排%d座(￥%d) ",row,clo,kTicket];
        TTGTextTagStringContent *stringContent = [content copy];
        TTGTextTagStringContent *selectedStringContent = [selectedContent copy];
        stringContent.text = string;
        selectedStringContent.text = string;
        TTGTextTag *tag = [TTGTextTag new];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        
        [tags addObject:tag];
       
    }
    [self.tagView addTags:tags];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tagView.contentSize.height));
        }];
        [self.view layoutIfNeeded];
    }];
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
    
    for (XYPButton *btn in contentView.subviews) {
        if ([btn isKindOfClass:[XYPButton class]] && btn.isSelected && btn.tag > 0) {
            btn.selected = NO;
            btn.owner = nil;
        }
    }
    for (NSDictionary *dict in selectList) {
        NSNumber *num = dict[@"tag"];
        NSString *owner = dict[@"sender"];
        XYPButton *btn = [contentView viewWithTag:[num intValue]];
        if ([btn isKindOfClass:[XYPButton class]]) {
            btn.selected = YES;
            btn.owner = owner;
        }
    }
}

-(void)applicationEnterBackground {
    for (NSNumber *num in self.mySelectList) {
        XYPButton *btn = [contentView viewWithTag:[num intValue]];
        if ([btn isKindOfClass:[XYPButton class]]) {
            btn.selected = NO;
            btn.owner = nil;
        }
    }
    [self.mySelectList removeAllObjects];
    [self addTagViewWithText:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(TTGTextTagCollectionView *)tagView {
    if (!_tagView) {
        // Create TTGTextTagCollectionView view
        TTGTextTagCollectionView *tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
        _tagView = tagCollectionView;
        _tagView.alignment = TTGTagCollectionAlignmentLeft;
        _tagView.translatesAutoresizingMaskIntoConstraints = NO;
        _tagView.onTapBlankArea = ^(CGPoint location) {
            NSLog(@"Blank: %@", NSStringFromCGPoint(location));
        };
        _tagView.onTapAllArea = ^(CGPoint location) {
            NSLog(@"All: %@", NSStringFromCGPoint(location));
        };
    }
    return _tagView;
}

-(NSMutableArray *)mySelectList {
    if (!_mySelectList) {
        _mySelectList = [[NSMutableArray alloc] init];
    }
    return _mySelectList;;
}

@end
