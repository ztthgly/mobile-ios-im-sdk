//
//  ZTRecordShowManager.h
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTRecordHeaderDefine.h"
@interface ZTRecordShowManager : NSObject
- (void)updateUIWithRecordState:(ZTRecordState)state;
- (void)showToast:(NSString *)message;
- (void)updatePower:(float)power;
- (void)showRecordCounting:(float)remainTime;
@end
