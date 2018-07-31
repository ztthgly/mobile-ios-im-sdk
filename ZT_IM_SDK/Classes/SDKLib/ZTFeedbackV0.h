//
//  ZTFeedbackV0.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/26.
//

#import "ZTValueObject.h"

@interface ZTFeedbackItemV0: ZTValueObject
@property(nonatomic, strong) NSNumber *nid;
@property(nonatomic, copy) NSNumber *fieldTypeId;
@property(nonatomic, copy) NSString *fieldType;
@property(nonatomic, copy) NSString *fieldName;
@property(nonatomic, copy) NSString *fieldHint;
@property(nonatomic, strong) NSNumber *buttonType;
@property(nonatomic, copy) NSString *optionSetting;
@property(nonatomic, strong) NSNumber *isEnableRequired;
@property(nonatomic, copy) NSString *value;

- (instancetype)initWithNid:(NSNumber *)nid
                fieldTypeId:(NSNumber *)fieldTypeId
                  fieldType:(NSString *)fieldType
                  fieldName:(NSString *)fieldName
                  fieldHint:(NSString *)fieldHint
                      value:(NSString *)value;
@end

@interface ZTFeedbackV0 : ZTValueObject
@property(nonatomic, copy) NSString *importText;
@property(nonatomic, strong) NSArray <ZTFeedbackItemV0 *> * options;
@end
