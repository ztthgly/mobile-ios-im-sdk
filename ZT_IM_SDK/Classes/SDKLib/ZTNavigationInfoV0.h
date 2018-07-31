//
//  ZTNavigationInfo.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/5/26.
//

#import "ZTValueObject.h"

NS_ASSUME_NONNULL_BEGIN
/**
 导航菜单
 */
@interface ZTNavigationInfoV0 : ZTValueObject
// 导航菜单引导语
@property(nonatomic, copy) NSString *navText;
// 导航菜单选项
@property(nonatomic, copy) NSArray *navContent;
@end
NS_ASSUME_NONNULL_END
