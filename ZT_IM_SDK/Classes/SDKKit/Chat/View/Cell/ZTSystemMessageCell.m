//
//  ZTSystemMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/4.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTSystemMessageCell.h"
#import "ZTHelper.h"
#import "ZTUIConfiguration.h"

@interface ZTSystemMessageCell()
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;
@property (strong, nonatomic) IBOutlet UIView *msgBgView;

@end

@implementation ZTSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.msgBgView setBackgroundColor:[ZTUIConfiguration appearance].tipsBackgroundColor];
    self.msgLabel.textColor = [ZTUIConfiguration appearance].tipsTextColor;
    self.msgLabel.font = [UIFont systemFontOfSize:[ZTUIConfiguration appearance].tipsTextSize];
    self.msgBgView.layer.cornerRadius = 10;

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    self.msgLabel.text = [NSString stringWithFormat:@" %@ %@",vo.content,[ZTHelper hourStringWithTimeInterval:vo.createTime]];
}

@end
