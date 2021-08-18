//
//  ZTQLiveMsgView.h
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTQLiveMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTQLiveMsgView : UIView

@property (nonatomic,strong)UITableView *msgTableView;

- (void)reciveOrigiMsg:(NSDictionary* )msgDic;
- (void)reciveOrigiMsgs:(NSArray<NSDictionary*>*)msgDics;
- (void)clearMessageData;   //清理消息内容
- (void)reciveMessage:(ZTQLiveMsgModel* )msg;
- (void)reciveMessages:(NSArray<ZTQLiveMsgModel *>*)msgs;

- (void)reloadMsgList;

@end
NS_ASSUME_NONNULL_END
