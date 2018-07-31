//
//  ZTConfigItem.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/25.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    ZTConfigTypeColor,
    ZTConfigTypeImage,
    ZTConfigBool,
    ZTConfigTypeString,
    ZTConfigTypeInt,
    ZTConfigTypePicker,
} ZTConfigType;

@interface ZTConfigItem : NSObject
@property(nonatomic, strong) NSString *declare;
@property(nonatomic, assign) ZTConfigType type;
@property(nonatomic, strong) id defaultValue;
@property(nonatomic, strong) NSArray *values;

- (ZTConfigItem *)initWithDeclareName:(NSString *)declare
                                 configType:(ZTConfigType)type
                               defaultValue:(id)defaultValue
                                     values:(NSArray *)values;
@end
