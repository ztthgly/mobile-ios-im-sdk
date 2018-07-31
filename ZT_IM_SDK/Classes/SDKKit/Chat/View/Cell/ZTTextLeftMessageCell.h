//
//  ZTTextLeftMessageCell.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTMessageCell.h"
#import "ZTEditableLabel.h"

@interface ZTTextLeftMessageCell : ZTMessageCell
@property (strong, nonatomic) IBOutlet UIStackView *mainView;
@property (strong, nonatomic) IBOutlet ZTEditableLabel *contentTF;
@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;

@end
