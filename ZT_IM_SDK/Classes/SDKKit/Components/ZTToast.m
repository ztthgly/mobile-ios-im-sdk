//
//  ZTToast.m
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/7/5.
//

#import "ZTToast.h"

static const float kZTToastMaxWidth = 0.8; //window宽度的80%
static const float kZTToastFontSize = 14;
static const float kZTToastHorizontalSpacing = 8.0;
static const float kZTToastVerticalSpacing = 6.0;

@implementation ZTToast
+ (void)showToast:(NSString *)message {
    [self showToast:message duration:1.5f];
}

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration {
    [self showToast:message duration:duration view:[UIApplication sharedApplication].delegate.window];
}

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
           view:(UIView *)view {
    [self showToast:message duration:duration view:view completion:nil];
}

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
           view:(UIView *)view
       completion:(void (^ __nullable)(BOOL finished))completion {
    CGSize viewSize = view.frame.size;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont boldSystemFontOfSize:kZTToastFontSize];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.alpha = 1.0;
    titleLabel.text = message;
    
    CGSize maxSizeTitle = CGSizeMake(viewSize.width * kZTToastMaxWidth, viewSize.height);
    
    CGSize expectedSizeTitle = [message boundingRectWithSize:maxSizeTitle options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : titleLabel.font } context:nil].size;
    titleLabel.frame = CGRectMake(kZTToastHorizontalSpacing, kZTToastVerticalSpacing, expectedSizeTitle.width + 4, expectedSizeTitle.height);
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake((viewSize.width - titleLabel.frame.size.width) / 2 - kZTToastHorizontalSpacing,
                                          viewSize.height * .6 - titleLabel.frame.size.height,
                                          titleLabel.frame.size.width + kZTToastHorizontalSpacing * 2,
                                          titleLabel.frame.size.height + kZTToastVerticalSpacing * 2);
    bgView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.7];
    bgView.alpha  = 0;
    bgView.layer.cornerRadius = bgView.frame.size.height * .15;
    bgView.layer.masksToBounds = YES;
    [bgView addSubview:titleLabel];
    
    [view addSubview:bgView];
    [UIView animateWithDuration:.25 animations:^{
        bgView.alpha = 1;
    } completion:^(BOOL finished) {
        if (duration > 0) {
            dispatch_time_t popTime =
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:.25 animations:^{
                    bgView.alpha = 0;
                } completion:^(BOOL finished) {
                    [bgView removeFromSuperview];
                    if (completion) completion(finished);
                }];
            });
        }
    }];
}
@end
