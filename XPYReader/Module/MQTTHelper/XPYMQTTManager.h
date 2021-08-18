//
//  HXMQTTManager.h
//  HXChallengeApp
//
//  Created by mac on 2021/8/10.
//

#import "BaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XPYMQTTManagerProxy <NSObject>

@optional
- (void)didReciveMessage:(NSDictionary *)data topicId:(NSString *)topicId;

- (void)didRecivePageChangedWithOrignal:(NSDictionary *)orignal topicId:(NSString *)topicId;

@end

@interface XPYMQTTManager : BaseManager

//发送消息（某文章里面聊天）
-(void)sendTxtMessage:(NSDictionary *)data topicId:(NSString *)topicId;

//发送操作翻页指令
-(void)sendPageInfo:(NSDictionary *)data topicId:(NSString *)topicId;

//添加文章订阅
-(void)addSubscribeWithTopic:(NSString *)topicId;

@end

NS_ASSUME_NONNULL_END
