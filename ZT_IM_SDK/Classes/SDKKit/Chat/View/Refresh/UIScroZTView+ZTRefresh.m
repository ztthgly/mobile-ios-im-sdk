//
//  UITableView+ZTRefresh.m
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import "UIScroZTView+ZTRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (ZTRefresh)

static ZTRefreshHeaderView *_aRefreshHeader;

- (void)setRefreshHeader:(ZTRefreshHeaderView *)aRefreshHeader {
    if (aRefreshHeader != self.refreshHeader) {
        //移除旧的
        [self.refreshHeader removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshHeader atIndex:0];
        //设置frame
        aRefreshHeader.frame = CGRectMake(0, -ZTRefreshHeaderHeight, self.bounds.size.width, ZTRefreshHeaderHeight);
        if ([aRefreshHeader respondsToSelector:@selector(createViews)]) {
            [aRefreshHeader createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"ZTRefreshHeader"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshHeader, aRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"ZTRefreshHeader"];  // KVO
    }
}

- (ZTRefreshHeaderView *)refreshHeader {
    return objc_getAssociatedObject(self, &_aRefreshHeader);
}
@end
