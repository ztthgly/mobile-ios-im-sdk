//
//  ZTUserV0.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/11.
//

#import "ZTValueObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface ZTUserV0 : ZTValueObject
// 用户的唯一标识符
@property(nonatomic, strong) NSString *tid;
// 用户的UserName
@property(nonatomic, copy) NSString *userName;
// 用户的头像
@property(nonatomic, copy) NSString *avatar;

// 额外字段
@property(nonatomic, strong) NSDictionary *options;
@end
NS_ASSUME_NONNULL_END
