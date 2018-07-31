//
//  ZTMessageCell.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/28.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTHelper.h"
#import "NSObject+ZTKit.h"
#import "ZTUIConfiguration.h"
#import "ZTUICommonDefine.h"
#import "ZTSendMessageV0.h"

@interface ZTMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) IBOutlet UIView *avatarView;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLbl;

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo NS_REQUIRES_SUPER;
@end
