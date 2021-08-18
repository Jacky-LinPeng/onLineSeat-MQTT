//
//  ZTQLiveMsgView.m
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//


#import "ZTQLiveMsgView.h"
#import "ZTQLiveMsgCell.h"


@interface ZTQLiveMsgView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *msgDataArray;
@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic, strong)CAGradientLayer *chatTopMaskLayer;
@end

@implementation ZTQLiveMsgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
        self.transform = CGAffineTransformMakeScale(1, -1);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}




// 横竖屏将要切换会调用
- (void)OrientationDidChanged {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait ) {
        return;
    }
//    self.frame = CGRectMake(0, 0, MessageMaxWidth, MessageMaxHeight);
    self.msgTableView.bounds = self.bounds;
    [self.msgDataArray enumerateObjectsUsingBlock:^(ZTQLiveMsgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [obj creatMessageContext];
     }];
    
    _chatTopMaskLayer.frame = CGRectMake(0, 0, MessageMaxWidth, MessageMaxHeight);
    self.layer.mask = _chatTopMaskLayer;
    
    [self.msgTableView reloadData];
}

- (void)initUI{
    _msgDataArray = [[NSMutableArray alloc]init];
    _queue = dispatch_queue_create("RWLock", DISPATCH_QUEUE_CONCURRENT);
    CGRect rect = CGRectMake(0, 0, MessageMaxWidth, MessageMaxHeight);
    _msgTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _msgTableView.backgroundColor = [UIColor clearColor];
    _msgTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);//top, left, bottom, right
    _msgTableView.delegate = self;
    _msgTableView.showsVerticalScrollIndicator = NO;
    _msgTableView.dataSource = self;
    [self addSubview:_msgTableView];
    [_msgTableView registerClass:[ZTQLiveMsgCell class] forCellReuseIdentifier:@"msgCell"];
    _msgTableView.estimatedRowHeight = 0;
    _msgTableView.estimatedSectionFooterHeight = 0;
    _msgTableView.estimatedSectionHeaderHeight = 0;
    [_msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMsgList) name:@"reloadMessage" object:nil];
    
    //渐变透明效果
    _chatTopMaskLayer = [CAGradientLayer layer];
    _chatTopMaskLayer.startPoint = CGPointMake(0, 1);
    _chatTopMaskLayer.endPoint   = CGPointMake(0, 0);
    _chatTopMaskLayer.locations  = @[@(0), @(0.03), @(0.1),@(0.97),@(1.0)];
    _chatTopMaskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                                 (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    _chatTopMaskLayer.frame = rect;
    self.layer.mask = _chatTopMaskLayer;
}



//MARK: - Public
- (void)reciveOrigiMsg:(NSDictionary* )messageDic {
    [self reciveOrigiMsgs:@[messageDic]];
}

- (void)reciveOrigiMsgs:(NSArray<NSDictionary *> *)msgDics{
    NSMutableArray *arry = [NSMutableArray array];
    [msgDics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull messageDic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *msgType = [NSString stringWithFormat:@"%@",[messageDic valueForKey:@"type"]];
         if ([msgType isEqualToString:@"TEXT"]) {
             ZTQLiveMsgModel *msg = [[ZTQLiveMsgModel alloc]init];
             msg.msgText = [[messageDic valueForKey:@"content"] valueForKey:@"text"];
             msg.fromUserName = [[messageDic valueForKey:@"operator"] valueForKey:@"chatNickName"]; //nickName
             msg.msgType = RoomMessageTypeText;
             [arry addObject:msg];
         }
    }];
    [self reciveMessages:arry];
}

- (void)reciveMessage:(ZTQLiveMsgModel *)msg{
    if (!msg) {
        return;
    }
    [self reciveMessages:@[msg]];
}

- (void)reciveMessages:(NSArray<ZTQLiveMsgModel *> *)msgs{
    if (!msgs.count) {
        return;
    }
    [msgs enumerateObjectsUsingBlock:^(ZTQLiveMsgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj creatMessageContext];
        dispatch_barrier_sync(_queue, ^{
            [self.msgDataArray insertObject:obj atIndex:0];
        });
    }];

//    [self.msgDataArray insertObjects:msgs atIndex:0];
    NSMutableArray *indexpathAry = [NSMutableArray array];
    for (int i = 0; i < msgs.count; i ++ ) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexpathAry addObject:indexPath];
    }
    [self.msgTableView insertRowsAtIndexPaths:indexpathAry withRowAnimation:UITableViewRowAnimationTop];
}

- (void)clearMessageData{
    [self.msgDataArray removeAllObjects];
    [self.msgTableView reloadData];
}

- (void)reloadMsgList{
    [_msgTableView reloadData];
}


//MARK: - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   __block ZTQLiveMsgModel *msg;
    dispatch_sync(_queue, ^{
        msg = self.msgDataArray[indexPath.row];
    });
    return msg.contextSize.height + 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTQLiveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    __block ZTQLiveMsgModel *msg;
       dispatch_sync(_queue, ^{
           msg = self.msgDataArray[indexPath.row];
       });
    cell.message = msg;
    cell.transform = CGAffineTransformMakeScale(1, -1);
    return cell;
}



@end
