//
//  ZTRankV0.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/5/26.
//

#import "ZTValueObject.h"
NS_ASSUME_NONNULL_BEGIN
/**
 提醒用户当前排在第几位
 */
@interface ZTRankV0 : ZTValueObject
// 提示语
@property(nonatomic, copy) NSString *text;
// 当前排在第几位
@property(nonatomic, strong) NSNumber *num;
// 已经等待的时间，客户端显示时间就在这个基础上累加
@property(nonatomic, strong) NSNumber *waitTime;
@end
NS_ASSUME_NONNULL_END
