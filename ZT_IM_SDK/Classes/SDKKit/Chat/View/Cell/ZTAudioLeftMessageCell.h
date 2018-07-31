//
//  ZTAudioLeftMessageCell.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTMessageCell.h"

@interface ZTAudioLeftMessageCell : ZTMessageCell
@property (strong, nonatomic) IBOutlet UIImageView *audioImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;
@end
