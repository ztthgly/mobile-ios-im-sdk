//
//  NSObject+ZTKit.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/24.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZTKit)

@end

@interface NSDictionary (ZTKit)

+ (nullable NSDictionary *)dictionaryWithJson:(id _Nullable )json;

@end

@interface NSDate (ZTKit)
- (nullable NSString *)stringWithFormat:(NSString *)format;
@end

@interface UIView (ZTKit)
#pragma mark - 设置圆角
/**
 设置部分圆角(绝对布局)

 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
@end

@interface UIImageView (ZTKit)
- (void)setImageWithUrlString:(nullable NSString *)urlString;
- (void)setImageWithUrlString:(nullable NSString *)urlString
                  placeholder:(nullable UIImage *)placeholder;
- (void)setImageWithUrlString:(nullable NSString *)urlString
                  placeholder:(nullable UIImage *)placeholder
                         size:(CGSize)size
                      cornerRadius:(CGFloat)radius;

/**
 设置avatar

 @param urlString avatarUrlString
 @param avatarShape 头像形状 默认为0，0为圆形头像，1为方形头像
 */
- (void)setImageWithUrlString:(nullable NSString *)urlString
                  placeholder:(nullable UIImage *)placeholder
                  avatarShape:(NSInteger)avatarShape;
@end

@interface UIButton (ZTKit)
- (void)setImageWithURLString:(nullable NSString *)URLString
                  forState:(UIControlState)state
            placeholder:(nullable UIImage *)placeholder;
@end

@interface NSString (oss)
- (nullable NSString *)stringWithSize:(CGSize)size
                              cornerRadius:(CGFloat)radius;

- (nullable NSString *)resizeStringWithSize:(CGSize)size;
@end

@interface NSString (ZTKit)
- (BOOL)isNotBlank;
@end

@interface NSBundle (create)
+ (nullable NSBundle *)currentBundle;
@end
NS_ASSUME_NONNULL_END
