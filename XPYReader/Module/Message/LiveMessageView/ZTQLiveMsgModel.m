//
//  ZTQLiveMsgModel.m
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//
#import "ZTQLiveMsgModel.h"


@implementation ZTQLiveMsgModel

- (instancetype)initWithMsgType:(RoomMessageType)type{
    if (self = [super init]) {
        _msgType = type;
    }
    return self;
}


- (void)creatMessageContext{
    switch (_msgType) {
        case RoomMessageTypeSystem:
            [self creatSystemMessage];
            break;
        case RoomMessageTypeComeIn:
            [self creatComeInMessage];
            break;
        case RoomMessageTypeText:
            [self creatChatTextMessage];
            break;
        case RoomMessageTypeFollow:
            [self creatFollowMessage];
            break;
        case RoomMessageTypeForbid:
        case RoomMessageTypeKickRoom:
            [self creatForbidMessage];
            break;

        default:
            break;
    }
    [self addParagra];
    [self creatContextSize];
}

- (void)creatSystemMessage{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:self.msgText];
    [aString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFF9600),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, aString.length)];
    self.attributContext = aString;
}

- (void)creatComeInMessage{
    self.attributContext = [self creatNameAttributWithColon:NO];
    NSAttributedString *aString = [[NSAttributedString alloc]initWithString:@" 来了" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [_attributContext insertAttributedString:aString atIndex:_attributContext.length];
}

- (void)creatChatTextMessage{
    self.attributContext = [self creatNameAttributWithColon:YES];
    NSAttributedString *contextStr = [[NSAttributedString alloc]initWithString:self.msgText attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [_attributContext insertAttributedString:contextStr atIndex:_attributContext.length];
}

- (void)creatFollowMessage{
    self.attributContext = [self creatNameAttributWithColon:YES];
    NSAttributedString *contextStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" 关注了%@",self.toUserName ? self.toUserName : @"主播"] attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFF9600),NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [_attributContext insertAttributedString:contextStr atIndex:_attributContext.length];
}


- (void)creatForbidMessage{
    self.attributContext = [self creatNameAttributWithColon:NO];
    NSAttributedString *contxtStr = [[NSAttributedString alloc]initWithString:self.msgText attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    [_attributContext insertAttributedString:contxtStr atIndex:_attributContext.length];
}
//MARK: - 公共部分
- (NSMutableAttributedString*)creatNameAttributWithColon:(BOOL)colon{
    if (!self.fromUserName) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    NSMutableAttributedString *nameAtr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@%@",self.fromUserName,colon ? @"：" : @""]attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF9600),NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    [self creatNameRectWithAttributText:nameAtr];
    return nameAtr;
}

- (void)creatNameRectWithAttributText:(NSAttributedString*)aString{
    self.nameRect = CGRectMake(5, 5, aString.size.width, 20);
}

//添加段落信息
- (void)addParagra{
    [self.attributContext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, self.attributContext.length)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [self.attributContext addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.attributContext.length)];
}

- (void)creatContextSize{
    CGSize size;
    CGSize textSize = [self.attributContext boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  context:nil].size;
    if (textSize.width < MessageMaxWidth - 20) {
        size = textSize;
    }else{
        size = [self.attributContext boundingRectWithSize:CGSizeMake(MessageMaxWidth - 20, 100000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
    self.contextSize = CGSizeMake(ceil(size.width), ceil(size.height));
}

@end
