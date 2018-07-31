//
//  ZTConfigItem.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/25.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTConfigItem.h"

@implementation ZTConfigItem
- (ZTConfigItem *)initWithDeclareName:(NSString *)declare
                                 configType:(ZTConfigType)type
                               defaultValue:(id)defaultValue
                                     values:(NSArray *)values {
    ZTConfigItem *item = [ZTConfigItem new];
    item.declare = declare;
    item.type = type;
    item.defaultValue = defaultValue;
    item.values = values;
    return item;
}
@end
