//
//  ZTIMLibDefine.h
//  ZTIMSDK
//
//  Created by Deemo on 2018/5/14.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#ifndef ZTIMLibDefine_h
#define ZTIMLibDefine_h

#pragma mark Log
/**
 *  自定义Log，可配置开关（用于替换ZT_Log）
 */
#define ZT_Log(format,...) ZTLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)

/**
 *  自定义Log
 *  @warning 外部可直接调用 ZTLog
 *
 *  @param func         方法名
 *  @param lineNumber   行号
 *  @param format       Log内容
 *  @param ...          个数可变的Log参数
 */
void ZTLog(const char * _Nullable func, int lineNumber, NSString * _Nullable format, ...);

/**
 完成时的回调
 
 @param anError 是否成功
 */
typedef void (^ZTComplectionWithResultBlock)(NSError* _Nullable anError);

/**
 完成回调
 */
typedef void (^ZTCompletionBlock)(_Nullable id aResponseObject, NSError* _Nullable anError);


typedef NS_ENUM(NSUInteger, ZTErrorType) {
    ZT_Not_Recive_Seq = 10000, // 发送Message,并没有收到回调
    ZT_Upload_File_Empty = 10001, // 上传图片/音频失败
    ZT_OSS_Key_Error = 10002, // 上传OSSKeyerror
};

// 需要客户端手动关闭webSocket
typedef NS_ENUM(NSUInteger, ZTCloseWebSocketType) {
    ZT_Close_web_Socket_Unknow_Error = 3000, // 未知错误

    ZT_Close_Web_Socket_Feedback_Timeout = 3001, // 留言超时
    ZT_Close_Web_Socket_Conversation_Timeout = 3002, // 206超时或用户会话会触发
    ZT_Close_Web_Socket_Apprise_Finish = 3003, // 坐席主动断开, 关闭
    
    ZT_Close_Web_Socket_Failed_Error = 3004, //  收到error断开
};

#endif /* ZTIMLibDefine_h */
