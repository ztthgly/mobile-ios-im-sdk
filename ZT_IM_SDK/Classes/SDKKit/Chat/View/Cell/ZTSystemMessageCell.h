//
//  ZTSystemMessageCell.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/4.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSendMessageV0.h"

@interface ZTSystemMessageCell : UITableViewCell
- (void)updateCellWithVo:(ZTSendMessageV0 *)vo;
@end
