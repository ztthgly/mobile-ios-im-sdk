//
//  ZTRefreshComponent.h
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define R_G_B(_r_,_g_,_b_)          \
[UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:1.0]

#define ZTRefreshHeaderHeight 60
#define ZTREFRESH_COLOR      R_G_B(50, 50, 50)
#define ZTREFRESH_FONT       [UIFont boldSystemFontOfSize:13]
extern NSString *const ZTRefreshMoreData;
/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, ZTRefreshState) {
    
    ZTRefreshStateNormal          = 0, //普通状态
    ZTRefreshStateWiZTRefresh,         //松开就刷新的状态
    ZTRefreshStateRefreshing,          //正在刷新中的状态
    ZTRefreshStateNoMoreData           //没有更多的数据
};

@interface ZTRefreshComponent : UIView{
    ZTRefreshState _refreshState;
    UILabel *_messageLabel;
}

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/** 是否处于刷新状态 */
@property (nonatomic, assign) BOOL isRefreshing;

/** 回调对象 */
@property (nonatomic, weak) id refreshingTarget;

/** 回调方法 */
@property (nonatomic, assign) SEL refreshingAction;

#pragma mark - 交给子类去访问
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - 交给子类们去实现
/** 普通状态 */
- (void)refreshNormal NS_REQUIRES_SUPER;

/** 松开就刷新的状态 */
- (void)willRefresh NS_REQUIRES_SUPER;

/** 没有更多的数据 */
- (void)noMoreData NS_REQUIRES_SUPER;

/** 正在刷新中的状态 */
- (void)beginRefresh NS_REQUIRES_SUPER;

/** 刷新结束 */
- (void)endRefresh:(BOOL)more NS_REQUIRES_SUPER;

/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;

/** 创建子视图 */
- (void)createViews;

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;

/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;

/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

/** 更新刷新控件的状态 */
- (void)updateRefreshState:(ZTRefreshState)refreshState;

/** 移除kvo监听 */
- (void)removeObservers;

@end
