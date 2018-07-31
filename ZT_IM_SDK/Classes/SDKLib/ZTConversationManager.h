//
//  ZTConversationManager.h
//  ZTIMSDK
//
//  Created by Deemo on 2018/5/14.
//  Copyright © 2018年 icsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTIMLibDefine.h"
#import "ZTSendMessageV0.h"
#import "ZTAgentV0.h"
#import "ZTChatMessageListV0.h"

// 会话逻辑
typedef enum : NSUInteger {
    /** 等待中 */
    ZTMsgLogicTypeBusy,
    /** 排队中 */
    ZTMsgLogicTypeRank,
    /** 会话 */
    ZTMsgLogicTypeConnWinthSeat,
    /** 留言 */
    ZTMsgLogicTypeLeaveMessage,
    /** 评价 */
    ZTMsgLogicTypeAppraise,
    /** 导航 */
    ZTMsgLogicTypeChooseNavi,
    /** 未知状态 */
    ZTMsgLogicTypeUnknown,
} ZTMsgLogicType;

typedef enum : NSUInteger {
    /** 文字 */
    ZTChatMsgTypeText = 0,
    /** 视频 */
    ZTChatMsgTypeVideo = 1,
    /** 图片 */
    ZTChatMsgTypePic = 2,
    /** 表情 */
    ZTChatMsgTypeExpression = 3,
    /** 文件 */
    ZTChatMsgTypeFile = 4,
    /** 音频 */
    ZTChatMsgTypeRadio = 5,
    /** 系统消息 */
    ZTChatMsgTypeSystem = 6,
    /** 历史消息 */
    ZTChatMsgHistory = 7,
} ZTChatMsgType;

NS_ASSUME_NONNULL_BEGIN
@protocol ZTConversationManagerDeleage <NSObject>

@optional

/**
 已连接
 */
- (void)onConnect;

/**
 收到逻辑跳转消息
 
 @param type 消息类型
 
 @param content 返回数据
 ZTMsgLogicTypeBusy : NSString
 ZTMsgLogicTypeRank: ZTRankVO
 ZTMsgLogicTypeConnWinthSeat:
 ZTMsgLogicTypeLeaveMessage: NSString
 ZTMsgLogicTypeChooseNavi: ZTNavigationInfoV0
 */
- (void)onReceiveLogicMsgType:(ZTMsgLogicType)type content:(nullable id)content;

/**
 聊天内消息类型

 @param type 聊天消息类型
 @param content 内容
 */
- (void)onReceiveChatMsgType:(ZTChatMsgType)type content:(ZTSendMessageV0 *)content;
/**
 收到系统关闭Socket连接消息
 
 @param code 错误code
 @param reason 错误原因
 */
- (void)onCloseWithCode:(NSInteger)code reason:(NSString *)reason;
@end

/**
 会话管理类
 */
@interface ZTConversationManager : NSObject

@property(nonatomic, strong, nullable) ZTSendMessageV0 *lastMessage;

#pragma mark - Conversation

/**
 当前客服对象, 当进入聊天的时候返回客服对象, 在其它状态为nil
 */
@property(nonatomic, strong, readonly, nullable) ZTAgentV0 *currentAgent;

/**
 发送选择导航菜单消息
 
 @param index  菜单序列号
 */
- (void)chooseNavigationWithNavIndex:(NSInteger)index;

/**
 发送留言


 @param phone 电话号码
 @param email 邮箱
 @param content 留言内容
 @param aBlock Block
 */
- (void)feedBackWithPhone:(NSString *)phone
                        email:(NSString *)email
                       conten:(NSString *)content
                     callBack:(ZTComplectionWithResultBlock)aBlock;

/**
 留言超时
 */
- (void)feedBackTimeout;
/**
 排队转留言

 @param aBlock Block
 */
- (void)sendRankTransferFeedbackWithCallBack:(ZTComplectionWithResultBlock)aBlock;

/**
 转接路由

 @param routeId 进入路由的ID
 @param aBlock block
 */
- (void)switchToAgentWithRouteId:(NSString *)routeId
                              callBack:(ZTComplectionWithResultBlock)aBlock;
/**
 发送用户评价消息
 
 @param content Dictionary
 {optionName:"xxx",optionOrder:"1",evaDescriptText:"xxx"}
 optionName: 评价项
 evaDescriptText : 评价描述语
 optionOrder: 评价星级 1 代表 一星 以此类推
 */
- (void)appriseWithContent:(NSDictionary *)content
                      callBack:(ZTComplectionWithResultBlock)aBlock;

/**
 评价完成
 */
- (void)appriseFinish;

/**
 发送文本消息

 @param text 文本内容
 @param aBlock callback
 */
- (void)sendText:(NSString *)text callBack:(ZTCompletionBlock)aBlock;

/**
 发送图片

 @param image 想要发送给后台的Image
 @param aBlock callBack
 */
- (void)sendPicture:(UIImage *)image callBack:(ZTCompletionBlock)aBlock;

/**
 发送语音

 @param audioURLPath 语音所在的本地地址
 @param aBlock callBack
 */
- (void)sendAudio:(NSURL *)audioURLPath callBack:(ZTCompletionBlock)aBlock;


/**
 发送用户端实时信息

 @param content 当前聊天框显示内容, 若为nil则说明当前用户不在焦点
 */
- (void)sendRealTimeDisplayContent:(nullable NSString *)content;

// 获取当前会话的消息
- (void)getCurrenSessionMessageHistoryWithCallBack:(ZTCompletionBlock)aBlock;

// 获取历史消息
- (void)getHistoryMessagesWithVo:(nullable ZTChatMessageListV0 *)vo callBack:(ZTCompletionBlock)aBlock;

#pragma mark - ZTConversationManagerDeleage
/**
 设置会话代理
 
 @param delagte 添加ZTConversationManagerDeleage
 */
- (void)addDelegate:(id <ZTConversationManagerDeleage>)delagte;

/**
 删除会话代理
 
 @param delegate 移除ZTConversationManagerDeleage
 */
- (void)removeDelegate:(id <ZTConversationManagerDeleage>)delegate;

/**
 删除所有代理
 */
- (void)removeAllDelegates;
@end
NS_ASSUME_NONNULL_END

