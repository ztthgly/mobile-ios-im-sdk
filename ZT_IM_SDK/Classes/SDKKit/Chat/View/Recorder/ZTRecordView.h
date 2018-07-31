//
//  ZTVoiceRecordView.h
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTRecordHeaderDefine.h"
@interface ZTRecordView : UIView

- (void)updateUIWithRecordState:(ZTRecordState)state;
- (void)updatePower:(float)power;
- (void)updateWithRemainTime:(float)remainTime;

@end
