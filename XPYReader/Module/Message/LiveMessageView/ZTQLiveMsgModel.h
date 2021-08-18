//
//  ZTQLiveMsgModel.h
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "marco.h"

typedef enum {
    RoomMessageTypeSystem,  //系统消息
    RoomMessageTypeComeIn,  //进入房间
    RoomMessageTypeText,    //普通聊天消息
    RoomMessageTypeFollow,  //关注成功消息
    RoomMessageTypeForbid,  //禁言消息
    RoomMessageTypeKickRoom,//踢出房间消息
}RoomMessageType;

NS_ASSUME_NONNULL_BEGIN

@interface ZTQLiveMsgModel : NSObject
 
@property (nonatomic,assign)RoomMessageType  msgType;// 消息类型
@property (nonatomic,strong)NSString *fromUserName;      //发送者
@property (nonatomic,copy)NSString *toUserName;     //接收者昵称
@property (nonatomic,copy)NSString *msgText;        //消息内容
@property (nonatomic,strong)NSMutableAttributedString *attributContext;//图文混排后的富文本
@property (nonatomic,assign)CGSize  contextSize;
@property (nonatomic,assign)CGRect  nameRect;


- (instancetype)initWithMsgType:(RoomMessageType)type;

- (void)creatMessageContext;
@end


NS_ASSUME_NONNULL_END
