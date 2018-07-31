//
//  ZTSendMessageVO.h
//  Pods-ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//

#import "ZTValueObject.h"

typedef enum : NSUInteger {
    ZTSendMessageStatusSuccess, // 发送成功
    ZTSendMessageStatusSending, // 发送中
    ZTSendMessageStatusError,   // 发送失败
} ZTSendMessageStatus;

NS_ASSUME_NONNULL_BEGIN
@interface ZTSendMessageV0 : ZTValueObject

/** 发送者 -1 系统消息 0 用户 1 坐席 2 机器人 */
@property(nonatomic, copy) NSString *from;

/** 接收消息者 -1 系统消息 0 用户 1 坐席 2 机器人 */
@property(nonatomic, copy) NSString *to;

/** 消息类型 0 私聊 1 群聊 ... */
@property(nonatomic) uint32_t chatType;

/** 消息类型：音频，视频，图片，表情，文件， 系统消息 */
@property(nonatomic) uint32_t msgType;

/** 创建时间 */
@property(nonatomic) uint32_t createTime;

/** 消息内容 */
@property(nonatomic, copy, nullable) NSString *content;

/** 音频时长  //如果是音频消息 需要该参数 */
@property(nonatomic) uint32_t audioDuration;

/** 缩略图URL */
@property(nonatomic, copy, nullable) NSString *thumbnail;

/** 消息Id */
@property(nonatomic) uint64_t id_p;

/** 消息状态 0 有效 1 撤回 2 删除 */
@property(nonatomic) ZTSendMessageStatus status;

#pragma mark - 本地字段
// 客户端发送的Image
@property(nonatomic, strong, nullable) UIImage *image;
// 是否由本人发送
@property(nonatomic, assign) BOOL isMe;
// 因为用户不一定对应的是某一个客服
@property(nonatomic, copy) NSString *avatar;

- (instancetype)initWithSendMessage:(id)message;
@end
NS_ASSUME_NONNULL_END

