//
//  ZTToast.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/7/5.
//

#import <Foundation/Foundation.h>

@interface ZTToast : NSObject
+ (void)showToast:(NSString *)message;

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration;

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
           view:(UIView *)view;

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
           view:(UIView *)view
       completion:(void (^ __nullable)(BOOL finished))completion;
@end
