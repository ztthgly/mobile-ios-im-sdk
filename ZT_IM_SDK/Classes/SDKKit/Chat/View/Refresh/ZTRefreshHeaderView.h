//
//  ZTRefreshHeaderView.h
//  refresh
//
//  Created by Null on 18/6/21.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import "ZTRefreshComponent.h"

@interface ZTRefreshHeaderView : ZTRefreshComponent

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)endRefresh;

@end
