//
//  ZTRecordToastContentView.h
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTRecordToastContentView : UIView

@end

//----------------------------------------//
@interface ZTRecordingView : ZTRecordToastContentView

- (void)updateWithPower:(float)power;

@end

//----------------------------------------//
@interface ZTRecordReleaseToCancelView : ZTRecordToastContentView


@end

//----------------------------------------//

@interface ZTRecordCountingView : ZTRecordToastContentView

- (void)updateWithRemainTime:(float)remainTime;

@end

//----------------------------------------//
@interface ZTRecordTipView : ZTRecordToastContentView

- (void)showWithMessage:(NSString *)msg;

@end


