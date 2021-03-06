//
//  NSObject+ZTKit.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/24.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "NSObject+ZTKit.h"
#import "ZTUICommonDefine.h"

@implementation NSObject (ZTKit)

@end

@implementation NSDictionary (ZTKit)
+ (NSDictionary *)dictionaryWithJson:(id)json {
    if (!json) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

@end

@implementation NSDate (ZTKit)
- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}
@end

@implementation UIView (ZTKit)

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    shape.frame = self.bounds;
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}
@end

@implementation UIImageView (ZTKit)
- (void)setImageWithUrlString:(NSString *)urlString {
    [self setImageWithUrlString:urlString placeholder:nil];
}

- (void)setImageWithUrlString:(nullable NSString *)urlString
                  placeholder:(nullable UIImage *)placeholder {
    [self setImageWithUrlString:urlString placeholder:placeholder  completion:nil];
}

- (void)setImageWithUrlString:(NSString *)urlString
                  placeholder:(UIImage *)placeholder
                   completion:(YYWebImageCompletionBlock)block {
    [self yy_setImageWithURL:[NSURL URLWithString:urlString] placeholder:placeholder options:YYWebImageOptionProgressiveBlur completion:block];
}

- (void)setImageWithUrlString:(NSString *)urlString
                  placeholder:(UIImage *)placeholder
                         size:(CGSize)size
                 cornerRadius:(CGFloat)radius {
    if (!urlString || urlString.length == 0) {
        return;
    }
    [self setImageWithUrlString:[urlString stringWithSize:size cornerRadius:radius] placeholder:placeholder];
}

- (void)setImageWithUrlString:(NSString *)urlString
                  placeholder:(UIImage *)placeholder
                  avatarShape:(NSInteger)avatarShape{
    if (avatarShape == 0) {
        [self setImageWithUrlString:urlString placeholder:placeholder size:CGSizeMake(36, 36) cornerRadius:18];
    } else {
        [self setImageWithUrlString:urlString placeholder:placeholder size:CGSizeMake(36, 36) cornerRadius:4];
    }
}

@end

@implementation UIButton (ZTKit)
- (void)setImageWithURLString:(nullable NSString *)URLString
                     forState:(UIControlState)state
                  placeholder:(nullable UIImage *)placeholder{
    [self yy_setImageWithURL:[NSURL URLWithString:URLString] forState:state placeholder:placeholder];
}
@end

@implementation NSString (ZTKit)
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}
@end

@implementation NSString (oss)
- (nullable NSString *)stringWithSize:(CGSize)size
                         cornerRadius:(CGFloat)radius {
    NSMutableString *URLString = [NSMutableString stringWithString:self];

    int scale;
    
    if (IS_40INCH_SCREEN || IS_35INCH_SCREEN || IS_47INCH_SCREEN) {
        scale = 2;
    } else {
        scale = 3;
    }
    [URLString appendFormat:@"?x-oss-process=image/resize,m_fixed,h_%d,w_%d/",(int)size.height * scale, (int)size.width * scale];
    if (radius > 0) {
        [URLString appendFormat:@"rounded-corners,r_%d/",(int)radius * scale];
    }
    [URLString appendString:@"format,png"];
    return URLString;
}
- (nullable NSString *)stringWithHeight:(CGFloat)height {
    NSMutableString *URLString = [NSMutableString stringWithString:self];
    [URLString appendFormat:@"?x-oss-process=image/resize,h_%d/",(int)height];
    [URLString appendString:@"format,png"];
    return URLString;
}
- (nullable NSString *)resizeStringWithSize:(CGSize)size {
    NSMutableString *URLString = [NSMutableString stringWithString:self];
    [URLString appendFormat:@"?x-oss-process=image/resize,m_fill,h_%d,w_%d/",(int)size.height * 4, (int)size.width * 4];
    [URLString appendString:@"format,png"];
    return URLString;
}

@end

@implementation NSBundle (create)
+ (nullable NSBundle *)currentBundle {
    NSString *bundlePath = [NSBundle bundleForClass:[self class]].resourcePath;
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle) {
        return bundle;
    } else {
        return nil;
    }
}
@end

