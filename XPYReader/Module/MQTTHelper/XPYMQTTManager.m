//
//  HXMQTTManager.m
//  HXChallengeApp
//
//  Created by mac on 2021/8/10.
//

#import "XPYMQTTManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import <AFNetworking/AFNetworking.h>
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

#define getToken_url        @"https://a1.easemob.com/540933120/look/token"

//区别消息还是操作类型的消息指令
#define kHXMQTTTxtTopic     @"kHXMQTTTxtTopic"
#define kHXMQTTOPTopic      @"kHXMQTTOPTopic"

@interface XPYMQTTManager ()<MQTTSessionManagerDelegate>

@property (nonatomic,strong) MQTTSessionManager *manager;
@property (nonatomic,strong) NSString *appId;
@property (nonatomic,strong) NSString *host;
@property (nonatomic,assign) NSInteger port;
@property (nonatomic,assign) NSInteger tls;
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,assign) NSInteger qos;

@end


@implementation XPYMQTTManager

-(instancetype)init {
    if (self = [super init]) {
        [self loadConfiguation];
    }
    return self;
}

-(void)sendTxtMessage:(NSDictionary *)data topicId:(NSString *)topicId {
    [self.manager sendData:[data yy_modelToJSONData]
                     topic:[NSString stringWithFormat:@"%@/%@",
                            kHXMQTTTxtTopic,
                            topicId]//此处设置多级子topic
                       qos:self.qos
                    retain:FALSE];
}

-(void)sendPageInfo:(NSDictionary *)data topicId:(NSString *)topicId {
    [self.manager sendData:[data yy_modelToJSONData]
                     topic:[NSString stringWithFormat:@"%@/%@",
                            kHXMQTTOPTopic,
                            topicId]//此处设置多级子topic
                       qos:self.qos
                    retain:FALSE];
    
}

-(void)addSubscribeWithTopic:(NSString *)topicId {
    NSDictionary *subscribes = self.manager.subscriptions;
    NSMutableDictionary *desktinations = [[NSMutableDictionary alloc] init];
    if (subscribes) {
        [desktinations addEntriesFromDictionary:subscribes];
    }
    NSDictionary *op = @{[NSString stringWithFormat:@"%@/%@",
                                    kHXMQTTOPTopic,
                          topicId]:@(self.qos)};
    NSDictionary *msg = @{[NSString stringWithFormat:@"%@/%@",
                                    kHXMQTTTxtTopic,
                           topicId]:@(self.qos)};
    [desktinations addEntriesFromDictionary:op];
    [desktinations addEntriesFromDictionary:msg];
    self.manager.subscriptions = desktinations;
}

//MARK: private method

- (void)loadConfiguation {
    self.appId = @"u5hji0";
    self.host = @"u5hji0.cn1.mqtt.chat";
    self.port = 1883;
    self.qos = 0;
    self.tls = 0;
    
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    self.clientId = [NSString stringWithFormat:@"%@@%@",deviceID,self.appId];

    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        //【userName && passWord】需要从后台创建获取
        NSString *userName = @"demo";
        NSString *passWord = @"123456";
        
        //生成token（请求服务器api）
        [self getTokenWithUsername:userName password:passWord completion:^(NSString *token) {
            NSLog(@"=======token:%@==========",token);
            
            [self.manager connectTo:self.host
                               port:self.port
                                tls:self.tls
                          keepalive:60
                              clean:true
                               auth:true
                               user:userName
                               pass:token
                               will:false
                          willTopic:nil
                            willMsg:nil
                            willQos:MQTTQosLevelAtMostOnce
                     willRetainFlag:nil
                       withClientId:self.clientId
                     securityPolicy:nil
                       certificates:nil
                      protocolLevel:MQTTProtocolVersion311
                     connectHandler:^(NSError *error) {
                
            }];
            
//            // 从console管理平台获取连接地址
//           [self.manager connectTo:self.host
//                              port:self.port
//                               tls:self.tls
//                         keepalive:60
//                             clean:true
//                              auth:true
//                              user:userName
//                              pass:token
//                              will:false
//                         willTopic:nil
//                           willMsg:nil
//                           willQos:0
//                    willRetainFlag:FALSE
//                      withClientId:self.clientId];
            
        }];
    } else {
        [self.manager connectToLast:^(NSError *error) {
            
        }];
    }
    
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
}

#pragma mark private method
- (void)getTokenWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSString *token))response {
    

    NSString *urlString = getToken_url;
    //初始化一个AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求体数据为json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应体数据为json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //请求体，参数（NSDictionary 类型）
    
    NSDictionary *parameters = @{@"grant_type":@"password",
                                 @"username":username,
                                 @"password":password
    };
    __block NSString *token  = @"";
    
    [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%s jsonDic:%@",__func__,jsonDic);
        token = jsonDic[@"access_token"];
        
        response(token);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%s error:%@",__func__,error.debugDescription);
            response(token);
    }];
    
}


/*
 * 重新连接
 */
- (void)connect {
    [self.manager connectToLast:^(NSError *error) {
        
    }];
}

/*
 * 断开连接
 */
- (void)disConnect {
    [self.manager disconnectWithDisconnectHandler:^(NSError *error) {
        
    }];
    self.manager.subscriptions = @{};
}
/**
  取消订阅主题
*/
- (void)unSubScribeTopic {
    self.manager.subscriptions = @{};
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
           
            break;
        case MQTTSessionManagerStateClosing:
           
            break;
        case MQTTSessionManagerStateConnected:
           
            break;
        case MQTTSessionManagerStateConnecting:
           
            break;
        case MQTTSessionManagerStateError:
         
            break;
        case MQTTSessionManagerStateStarting:
        default:
//            [self.manager connectToLast:^(NSError *error) {
//
//            }];
            break;
    }
}


#pragma mark MQTTSessionManagerDelegate
/*
 * MQTTSessionManagerDelegate
 */
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    NSArray *subTopics = [topic componentsSeparatedByString:@"/"];
    NSString *topicId = subTopics.firstObject;
    NSString *dataJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];;
    
    if ([topicId isEqualToString:kHXMQTTTxtTopic]) {
        [self notifyObserversWithSelector:@selector(didReciveMessage:topicId:) withObjectOne:dataDict objectTwo:subTopics.lastObject];
    } else if ([topicId isEqualToString:kHXMQTTOPTopic]) {
        [self notifyObserversWithSelector:@selector(didRecivePageChangedWithOrignal:topicId:) withObjectOne:dataDict objectTwo:subTopics.lastObject];
    }
    NSLog(@"rec:%@",dataJson);
}

-(void)messageDelivered:(UInt16)msgID {
    NSLog(@"%s msgId:%@",__func__,@(msgID));
    
}


@end
