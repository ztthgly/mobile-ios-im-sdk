//
//  ZTVideoLeftMessageCell.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTMessageCell.h"
@class ZTVideoLeftMessageCell;

@protocol ZTVideoMessageCellDelegate <NSObject>
- (void)videoMessageCell:(ZTVideoLeftMessageCell *)cell
       didClickedPlayBtn:(UIButton *)btn
           sendMessageVO:(ZTSendMessageV0 *)vo;
@end

@interface ZTVideoLeftMessageCell : ZTMessageCell
@property(nonatomic, weak) id <ZTVideoMessageCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;

@end

