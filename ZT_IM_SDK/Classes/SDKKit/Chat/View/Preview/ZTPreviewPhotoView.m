//
//  ZTPreviewPhotoView.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/12.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTPreviewPhotoView.h"

@import YYWebImage;

@interface ZTPreviewPhotoView() {
    CGAffineTransform _transform;
}

@property(nonatomic, assign) CGFloat lastScare;
@property(nonatomic, assign) CGFloat firstX;
@property(nonatomic, assign) CGFloat firstY;
@property(nonatomic, assign) CGRect imgFrame;

@end

@implementation ZTPreviewPhotoView

- (instancetype)initWithFrame:(CGRect)frame picture:(UIImage *)photo {
    if (self = [super initWithFrame:frame]) {
        CGFloat scale = photo.size.width / self.frame.size.width;
        CGFloat height = photo.size.height / scale;
        
        self.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - height)/2, self.frame.size.width, height)];
        imageView.image = photo;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        self.imgFrame = imageView.frame;
        _transform = imageView.transform;
        self.lastScare = 1.0f;
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchChangeScale:)];
        [imageView addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [imageView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDisappear)];
        oneTapGesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:oneTapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResolve:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTapGesture];
        
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [imageView addGestureRecognizer:longpressGesture];
        
        [oneTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

- (void)pinchChangeScale:(UIPinchGestureRecognizer *)pinch {
    UIImageView *imageView = (UIImageView *)pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        self.lastScare = 1.0;
    }
    CGFloat scare = 1 - (self.lastScare - pinch.scale);
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scare, scare);
    [imageView setTransform:newTransform];
    self.lastScare = pinch.scale;
}

- (void)move:(UIPanGestureRecognizer *)pan {
    CGPoint transpoint = [pan translationInView:self];
    UIImageView *imageView = (UIImageView *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.firstX = imageView.center.x;
        self.firstY = imageView.center.y;
    }
    if (self.lastScare == 1.0f) {
        return;
    }
    transpoint = CGPointMake(self.firstX+transpoint.x, self.firstY+transpoint.y);
    [imageView setCenter:transpoint];
}

- (void)tapDisappear {
    [self removeFromSuperview];
}

- (void)tapResolve:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    [imageView setTransform:_transform];
    [imageView setFrame:self.imgFrame];
    self.lastScare = 1.0f;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
//    UIImageView *imageView = (UIImageView *)longPress.view;
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        if (self.longpressblock && imageView.image) {
//            self.longpressblock(imageView.image);
//        }
//    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
