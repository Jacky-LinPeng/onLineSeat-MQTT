//
//  ZTQLiveMsgCell.m
//  LiveMessage
//
//  Created by 雷欧 on 2020/3/25.
//  Copyright © 2020 雷欧. All rights reserved.
//

#import "ZTQLiveMsgCell.h"

@interface ZTQLiveMsgCell()


@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *msgLabel;

@end
@implementation ZTQLiveMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatMessageCellSubView];
    }
    return self;
}

- (void)creatMessageCellSubView{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = UIColorFromRGBA(0x0000, 0.4);
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    _msgLabel = [[UILabel alloc]init];
    _msgLabel.numberOfLines = 0;
    [self.contentView addSubview:_msgLabel];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
        make.width.equalTo(@(MessageMaxWidth + 10));
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(2);
        make.bottom.offset(-2);
        make.right.equalTo(_msgLabel).offset(10);
    }];

}
- (void)updateLayout {
    [_msgLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.message.contextSize.width));
    }];
}
- (void)setMessage:(ZTQLiveMsgModel *)message{
    _message = message;
    self.msgLabel.attributedText = _message.attributContext;
    
    [self updateLayout];
}

@end
