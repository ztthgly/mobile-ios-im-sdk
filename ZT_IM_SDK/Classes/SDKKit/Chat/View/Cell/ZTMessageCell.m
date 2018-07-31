//
//  ZTMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/28.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTMessageCell.h"
#import "ZTIM.h"

@import YYWebImage;

@interface ZTMessageCell()
@property(nonatomic, strong) ZTSendMessageV0 *vo;;
@end

@implementation ZTMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [self.vo removeObserver:self forKeyPath:@"status"];
    self.vo = vo;
    if (vo.isMe) {
        if ([ZTUIConfiguration appearance].hideRightAvatar || ![ZTIM sharedInstance].user.avatar) {
            self.avatarView.hidden = [ZTUIConfiguration appearance].hideRightAvatar;
        } else {
            [self.avatar setImageWithUrlString:[ZTIM sharedInstance].user.avatar placeholder:UIImageMake(@"icon_yonghu")];
            self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
            self.avatar.clipsToBounds = YES;
        }
    } else {
        self.avatarView.hidden = [ZTUIConfiguration appearance].hideLeftAvatar;
        if (vo.avatar) {
            [self.avatar setImageWithUrlString:vo.avatar placeholder:UIImageMake(@"icon_kefu") avatarShape:[ZTUIConfiguration appearance].avatarShape];
        } else {
            [self.avatar setImageWithUrlString:[ZTIM sharedInstance].conversationManager.currentAgent.agentAvatar placeholder:UIImageMake(@"icon_kefu") avatarShape:[ZTUIConfiguration appearance].avatarShape];
        }
    }
    if (self.activityIndicatorView) {
        switch (vo.status) {
            case ZTSendMessageStatusSuccess:
                self.activityIndicatorView.hidden = YES;
                break;
            case ZTSendMessageStatusError:
            case ZTSendMessageStatusSending:
                [self.activityIndicatorView startAnimating];
                break;
        }
    }
    self.dateTimeLbl.text = [ZTHelper stringWithTimeInterval:vo.createTime];
    [self.vo addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        [self updateCellWithVo:self.vo];
    }
}

- (void)dealloc {
    [self.vo removeObserver:self forKeyPath:@"status"];
}

@end
