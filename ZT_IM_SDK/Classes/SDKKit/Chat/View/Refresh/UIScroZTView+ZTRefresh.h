//
//  UITableView+ZTRefresh.h
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 ICSOC. AZT rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTRefreshHeaderView.h"

@interface UIScrollView (ZTRefresh)

- (void)setRefreshHeader:(ZTRefreshHeaderView *)aRefreshHeader;
- (ZTRefreshHeaderView *)refreshHeader;


@end
