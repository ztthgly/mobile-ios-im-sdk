//
//  UIImageView+bubble.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/12.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "UIImageView+bubble.h"

@implementation UIImageView (bubble)
- (void)setBubbleImage:(UIImage *)image {
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithFrame:self.frame];
    bubbleImageView.image = image;
    CALayer *layer = bubbleImageView.layer;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

@end
