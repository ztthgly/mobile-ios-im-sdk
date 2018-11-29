//
//  ZTBaseVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTBaseVC.h"

#import "NSObject+ZTKit.h"
#import "UIViewController+ZTKit.h"

#import "ZTConversationNavigationVC.h"
#import "ZTFeedbackVC.h"
#import "ZTChatVC.h"

#import "ZTUICommonDefine.h"
#import "ZTRankV0.h"
#import "ZTFeedbackV0.h"
@interface ZTBaseVC ()
@end

@implementation ZTBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavHeaders];
    [self initSubviews];
    [[ZTIM sharedInstance].conversationManager addDelegate:self];
}

- (void)configNavHeaders {
    [UIApplication sharedApplication].statusBarStyle = [ZTUIConfiguration appearance].statusBarStyle;
    if ([ZTUIConfiguration appearance].navBarBackgroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:[ZTUIConfiguration appearance].navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [ZTUIConfiguration appearance].navBarBarTintColor, NSFontAttributeName : [UIFont systemFontOfSize:[ZTUIConfiguration appearance].titleLabelSize]}];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"arrow_left") style:UIBarButtonItemStylePlain target:self action:@selector(onPressedBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
        
}

- (void)initSubviews {
    // 子类覆盖
}

#pragma mark - actions
- (void)onPressedBack:(UIBarButtonItem *)item {
    // 退出轨迹
    END_EDITING;
    [[ZTIM sharedInstance].conversationManager removeDelegate:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onPressedRestartBtn:(UIButton *)button {
    // 重连的时候重新添加代理
    self.title = @"在线客服";
    [self showEmptyViewWithImage:UIImageMake(@"lianjiezhong") text:@"努力连接中, 请稍等..."];
    [[ZTIM sharedInstance] restartService];
    [[ZTIM sharedInstance].conversationManager addDelegate:self];
}

#pragma mark - emptyView

- (ZTEmptyView *)emptyView {
    if (!_emptyView) {
 
        _emptyView = [[[ZTHelper currentBundle] loadNibNamed:@"ZTEmptyView" owner:nil options:nil] firstObject];
        _emptyView.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)showEmptyViewWithImage:(UIImage *)image text:(NSString *)text {
    [self showEmptyViewWithImage:image text:text buttonTitle:nil buttonAction:nil];
}

- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action {
    [self showEmptyViewWithImage:image text:text detailText:nil buttonTitle:buttonTitle buttonAction:action];
}

- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                    detailText:(NSAttributedString *)detailText
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action {
    [self.emptyView setImage:image];
    [self.emptyView setTextLabelText:text];
    [self.emptyView setDetailLabelText:detailText];
    [self.emptyView setActionButtonTitle:buttonTitle];
    
    [self.emptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.emptyView.actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.emptyView];
}

- (void)hideEmptyView {
    [self.view sendSubviewToBack:self.emptyView];
}

#pragma mark - ZTConversationManagerDeleage

- (void)onReceiveLogicMsgType:(ZTMsgLogicType)type content:(id)content {
    END_EDITING;
    switch (type) {
            // 214 导航菜单
        case ZTMsgLogicTypeChooseNavi:
        {
            [self _toNavigationVC:content];
            break;
        }
            
            // 215 留言
        case ZTMsgLogicTypeLeaveMessage:
        {
            [self _toFeedbackVCWithContent:content];
        }
            break;
            
            // 227 提醒用户排在第几位
        case ZTMsgLogicTypeRank:
        {
            ZTRankV0 *vo = content;
            [self showRankViewWithMessage:vo];
            break;
        }
            // 222 匹配到坐席
        case ZTMsgLogicTypeConnWinthSeat:
        {
            [self _toChatVC:content];
            break;
        }
        case ZTMsgLogicTypeBusy:
        {
            [self showWaitingViewWithMessage:content];
            break;
        }
        default:
            break;
    }
}

- (void)onCloseWithCode:(NSInteger)code reason:(NSString *)reason {
    END_EDITING;
    self.navigationItem.titleView = nil;
    switch (code) {
        case ZT_Close_Web_Socket_Feedback_Timeout:
            self.title = @"留言超时";
            [self showEmptyViewWithImage:UIImageMake(@"chaoshi") text:@"留言超时，如需留言请重新刷新…" buttonTitle:@"刷新重试" buttonAction:@selector(onPressedRestartBtn:)];
            break;
        default:
#if DEBUG
            if (reason) {
                self.title = [NSString stringWithFormat:@"%d-异常断开 %@",code, reason];
            } else {
                self.title = [NSString stringWithFormat:@"%d-异常断开",code];
            }
#else
            self.title = @"连接异常断开";
#endif
            [self showEmptyViewWithImage:UIImageMake(@"duankai") text:@"会话已断开,如需咨询请重新发起会话" buttonTitle:@"继续会话" buttonAction:@selector(onPressedRestartBtn:)];
            break;
    }
}

#pragma mark - 业务跳转逻辑
- (void)showRankViewWithMessage:(ZTRankV0 *)vo {
    self.navigationItem.titleView = nil;
    self.title = @"排队中";
    [self showEmptyViewWithImage:UIImageMake(@"busy") text:vo.text detailText:[self _rankAttributesWithNum:vo.num.stringValue] buttonTitle:@"去留言" buttonAction:@selector(_rankToFeedBackVC)];
}

- (void)showWaitingViewWithMessage:(NSString *)msg {
    self.navigationItem.titleView = nil;
    [self showEmptyViewWithImage:UIImageMake(@"busy") text:msg buttonTitle:@"去留言" buttonAction:@selector(_rankToFeedBackVC)];
}


- (void)_rankToFeedBackVC {
    __weak __typeof(self)weakSelf = self;
    [[ZTIM sharedInstance].conversationManager sendRankTransferFeedbackWithCallBack:nil];
}

- (void)_toNavigationVC:(ZTNavigationInfoV0 *)vo {
    ZTConversationNavigationVC *vc = [[UIStoryboard storyboardWithName:@"ZTConversation" bundle:[ZTHelper currentBundle]] instantiateViewControllerWithIdentifier:@"conversationNav"];
    vc.navInfo = vo;
    [self _replaceCurretVCWithVC:vc];
    
}
- (void)_toChatVC:(ZTAgentV0 *)content {
    ZTChatVC *vc = [[UIStoryboard storyboardWithName:@"ZTConversation" bundle:[ZTHelper currentBundle]] instantiateViewControllerWithIdentifier:@"chat"];
    [self _replaceCurretVCWithVC:vc];
}

- (void)_toFeedbackVCWithContent:(ZTFeedbackV0 *)content {
    ZTFeedbackVC *vc = [[UIStoryboard storyboardWithName:@"ZTConversation" bundle:[ZTHelper currentBundle]] instantiateViewControllerWithIdentifier:@"feedback"];
    vc.info = content.importText;
    [self _replaceCurretVCWithVC:vc];
}

- (void)_replaceCurretVCWithVC:(UIViewController *)vc {
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    UIViewController *lastVC = vcs.lastObject;
    [[ZTIM sharedInstance].conversationManager removeDelegate:lastVC];
    
    [vcs removeLastObject];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:false];
}

- (NSAttributedString *)_rankAttributesWithNum:(NSString *)number {
    NSMutableAttributedString *mutiAttribute = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes1 = @{
                                  NSForegroundColorAttributeName: UIColorMake(96, 98, 102)
                                  };
    NSDictionary *attributes2 = @{
                                  NSForegroundColorAttributeName: [UIColor redColor]
                                  };
    NSAttributedString *first = [[NSAttributedString alloc] initWithString:@"您当前排在第" attributes:attributes1];
    NSAttributedString *second = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",number] attributes:attributes2];
    NSAttributedString *third = [[NSAttributedString alloc] initWithString:@"位" attributes:attributes1];
    [mutiAttribute appendAttributedString:first];
    [mutiAttribute appendAttributedString:second];
    [mutiAttribute appendAttributedString:third];
    
    return mutiAttribute;
}

- (void)dealloc {
    ZT_Log(@"%@--call %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
@end

