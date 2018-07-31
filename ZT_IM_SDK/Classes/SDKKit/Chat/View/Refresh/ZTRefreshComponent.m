//
//  ZTRefreshComponent.m
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import "ZTRefreshComponent.h"

NSString *const ZTRefreshKeyPathContentOffset = @"contentOffset";
NSString *const ZTRefreshKeyPathContentSize   = @"contentSize";
NSString *const ZTRefreshKeyPathPanState      = @"state";
NSString *const ZTRefreshHeaderTime           = @"ZTRefreshHeaderTime";
NSString *const ZTRefreshMoreData             = @"ZTRefreshMoreData";
@interface ZTRefreshComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation ZTRefreshComponent

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        _refreshState = ZTRefreshStateNormal;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor  = [UIColor clearColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        
        if ([newSuperview isKindOfClass:[UITableView class]]) {
            //关闭UITableView的高度预估
            ((UITableView *)newSuperview).estimatedRowHeight = 0;
            ((UITableView *)newSuperview).estimatedSectionHeaderHeight = 0;
            ((UITableView *)newSuperview).estimatedSectionFooterHeight = 0;
        }
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)removeFromSuperview {
    [self removeObservers];
    [super removeFromSuperview];
}

- (UIActivityIndicatorView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:ZTRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:ZTRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:ZTRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    @try {
        [self.superview removeObserver:self forKeyPath:ZTRefreshKeyPathContentOffset];
        [self.superview removeObserver:self forKeyPath:ZTRefreshKeyPathContentSize];
        [self.pan removeObserver:self forKeyPath:ZTRefreshKeyPathPanState];
        self.pan = nil;
    } @catch (NSException *exception) {}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.isRefreshing) return;
    if ([keyPath isEqualToString:ZTRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden)       return;
    if ([keyPath isEqualToString:ZTRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqualToString:ZTRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

/** 普通状态 */
- (void)refreshNormal{
    [self updateRefreshState:ZTRefreshStateNormal];
}

/** 松开就刷新的状态 */
- (void)willRefresh {
    [self updateRefreshState:ZTRefreshStateWiZTRefresh];
}

/** 没有更多的数据 */
- (void)noMoreData {
    [self updateRefreshState:ZTRefreshStateNoMoreData];
}

/** 正在刷新中的状态 */
- (void)beginRefresh{
    self.isRefreshing = YES;
    [self refreshUI:YES];
    [self updateRefreshState:ZTRefreshStateRefreshing];
}

/** 结束刷新 */
- (void)endRefresh:(BOOL)more{
    self.isRefreshing = NO;
    if (more) {
        [self refreshNormal];
    }
    else {
        [self noMoreData];
    }
    [self refreshUI:NO];
}

- (void)refreshUI:(BOOL)begin {
    if (begin) {
        [self.loadingView startAnimating];
    }
    else {
        if ([self isKindOfClass:NSClassFromString(@"ZTRefreshHeaderView")]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *value = _messageLabel.text;
                    NSInteger w = ceil([value sizeWithAttributes:@{NSFontAttributeName:ZTREFRESH_FONT}].width);
                    self.loadingView.frame = CGRectMake((self.bounds.size.width-w)/2-35, (ZTRefreshHeaderHeight-40)/2.0, 15, 40);
                    [self.loadingView stopAnimating];
                });
            });
        }
    }
}

- (void)createViews{};
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}
- (void)updateRefreshState:(ZTRefreshState)refreshState{}

@end
