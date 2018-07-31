//
//  ZTRefreshHeaderView.m
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTRefreshHeaderView.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define ZTRefreshMsgSend(...)       ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define ZTRefreshMsgTarget(target)  (__bridge void *)(target)
@implementation ZTRefreshHeaderView

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    ZTRefreshHeaderView *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingTarget = target;
    refreshHeader.refreshingAction = action;
    return refreshHeader;
}

- (void)layoutSubviews {
    
    CGRect rect = self.frame;
    rect.origin.y = -ZTRefreshHeaderHeight;
    self.frame = rect;
    
    NSInteger w = ceil([_messageLabel.text sizeWithAttributes:@{NSFontAttributeName:ZTREFRESH_FONT}].width);
    self.loadingView.frame = CGRectMake((self.bounds.size.width-w)/2-35, (ZTRefreshHeaderHeight-40)/2.0, 15, 40);
    
    self.loadingView.color = ZTREFRESH_COLOR;
    
    [super layoutSubviews];
}

- (void)createViews {
    [super createViews];
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _messageLabel.font = ZTREFRESH_FONT;
    _messageLabel.text = @"下拉可以加载";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = ZTREFRESH_COLOR;
    [self addSubview:_messageLabel];
}

- (void)updateRefreshState:(ZTRefreshState)refreshState {
    if (refreshState == _refreshState) return;
    
    NSString *refreshText;
    if (refreshState == ZTRefreshStateNormal) {
        refreshText = @"         ";
    }
    else if (refreshState == ZTRefreshStateWiZTRefresh) {
        refreshText = @"         ";
    }
    else if (refreshState == ZTRefreshStateRefreshing) {
        refreshText = @"加载中...";
    }
    else {
        refreshText = @"       ";
    }
    _messageLabel.text = refreshText;
    _refreshState = refreshState;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y >= 0) return;
    
    if (self.scrollView.contentOffset.y > -ZTRefreshHeaderHeight) {
        [self refreshNormal];
    }
    else {
        [self willRefresh];
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.y <= -ZTRefreshHeaderHeight) {
            [self beginRefresh];
        }
    }
}

- (void)beginRefresh {
    if (self.isRefreshing == NO) {
        [super beginRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(ZTRefreshHeaderHeight, 0, 0, 0);
            } completion:^(BOOL finished) {
                if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
                    ZTRefreshMsgSend(ZTRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
                }
            }];
        });
    }
}

- (void)endRefresh:(BOOL)more {
    if (self.isRefreshing) {
        [super endRefresh:more];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZTRefreshMoreData object:@(more)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

- (void)endRefresh {
    if (self.isRefreshing) {
        [super endRefresh:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZTRefreshMoreData object:@(YES)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}


@end
