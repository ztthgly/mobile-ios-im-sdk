//
//  ZTRecordHeaderDefine.h
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#ifndef ZTRecordHeaderDefine_h
#define ZTRecordHeaderDefine_h

typedef NS_ENUM(NSInteger, ZTRecordState)
{
    ZTRecordState_Normal,          //初始状态
    ZTRecordState_Recording,       //正在录音
    ZTRecordState_ReleaseToCancel, //上滑取消（也在录音状态，UI显示有区别）
    ZTRecordState_RecordCounting,  //最后10s倒计时（也在录音状态，UI显示有区别）
    ZTRecordState_RecordTooShort,  //录音时间太短（录音结束了）
};

#endif
