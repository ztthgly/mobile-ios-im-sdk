//
//  ZTChatVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTChatVC.h"
#import "ZTConversationVC.h"
#import "ZTTextView.h"

#import "NSObject+ZTKit.h"
#import "UIImage+ZTKit.h"
#import "ZTToast.h"

#import "ZTExpressionManager.h"
#import "ZTHelper.h"
#import "ZTImagePickerHelper.h"

#import "ZTRefresh.h"

#import "ZTMessageCell.h"
#import "ZTTextLeftMessageCell.h"
#import "ZTTextRightMessageCell.h"
#import "ZTPictureLeftMessageCell.h"
#import "ZTPictureRightMessageCell.h"
#import "ZTAudioLeftMessageCell.h"
#import "ZTAudioRightMessageCell.h"
#import "ZTVideoLeftMessageCell.h"
#import "ZTVideoRightMessageCell.h"
#import "ZTFileLeftMessageCell.h"
#import "ZTFileRightMessageCell.h"
#import "ZTSystemMessageCell.h"

#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"

#import "ZTRecorderManager.h"
#import "ZTPlayerManager.h"
#import "ZTRecordShowManager.h"

#define kFakeTimerDuration       1
#define kMaxRecordDuration       61     //最长录音时长
#define kRemainCountingDuration  10     //剩余多少秒开始倒计时
#define kContentRealTimeDisplayDuration 2.5 // 实时展示时间
#import "ZTIMLib.h"

@import AVKit;
@import Photos;

@interface ZTAppraiseView : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *descriptTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (strong, nonatomic) IBOutlet ZTTextView *appraisTV;
@property(nonatomic, strong) IBOutletCollection(UIButton) NSArray *stars;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property(nonatomic, strong) ZTOptionV0 *currentOption;
@property(nonatomic, strong) ZTAppraiseV0 *appraiseVO;
- (void)updateAppraisViewWithAppraiseVO:(ZTAppraiseV0 *)vo;
@end

@implementation ZTAppraiseView
- (void)awakeFromNib {
    [super awakeFromNib];
     __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf.appraisTV.isFirstResponder) {
            return;
        }
        NSDictionary *info = [note userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;
        NSNumber *during = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        strongSelf.bottomConstraint.constant = 20 + keyboardSize.height;
        
        [UIView animateWithDuration:during.doubleValue animations:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.superview layoutIfNeeded];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf.appraisTV.isFirstResponder) {
            return;
        }
        NSDictionary *info = [note userInfo];
        NSNumber *during = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        strongSelf.bottomConstraint.constant = 20;
        
        [UIView animateWithDuration:during.doubleValue animations:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.superview layoutIfNeeded];
        }];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.mainView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(4, 4)];
    self.appraisTV.layer.borderWidth = 0.5;
    self.appraisTV.layer.borderColor = UIColorMake(221, 221, 221).CGColor;
    self.appraisTV.layer.cornerRadius = 4;
}

- (void)updateAppraisViewWithAppraiseVO:(ZTAppraiseV0 *)vo {
    self.appraiseVO = vo;
    
    self.descriptTextLabel.text = vo.remarkText;
    self.appraisTV.placeholder = vo.evaDescriptText;
    [self.stars enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag > vo.remarkContent.count) {
            obj.hidden = YES;
        }
        if (obj.tag == vo.remarkContent.count) {
            self.currentOption = vo.remarkContent.lastObject;
            self.optionNameLabel.text = self.currentOption.optionName;
        }
    }];
}

- (IBAction)onPressedStarBtn:(UIButton *)sender {
    [self.stars enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag <= sender.tag) {
            obj.selected = true;
        } else {
            obj.selected = false;
        }
    }];
    self.currentOption = self.appraiseVO.remarkContent[sender.tag - 1];
    self.optionNameLabel.text = self.currentOption.optionName;
    
}

@end

@interface ZTChatVC ()<ZTConversationManagerDeleage, UITableViewDataSource, UITableViewDelegate, ChatKeyBoardDelegate, ChatKeyBoardDataSource, ZTVideoMessageCellDelegate>
@property (strong, nonatomic) IBOutlet ZTAppraiseView *appraisView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;

@property (strong, nonatomic) IBOutlet UIButton *moreMsgBtn;
@property (strong, nonatomic) IBOutlet UIButton *transferKefuBtn;

@property(nonatomic, strong) ZTAgentV0 *agent;
@property(nonatomic, copy) NSMutableArray <ZTSendMessageV0 *> *dataSource;
@property(nonatomic, strong) ChatKeyBoard *chatKeyBoard;

// recorder
@property(nonatomic, strong) ZTRecorderManager *recorder;
@property(nonatomic, strong) ZTRecordShowManager *voiceRecordCtrl;
@property (nonatomic, strong) NSTimer *fakeTimer;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) ZTRecordState currentRecordState;

// picker
@property(nonatomic, strong) ZTImagePickerHelper *pickerHelper;

@property(nonatomic, strong) NSMutableDictionary *heightDict;

// 获取当前的请求的历史消息的vo
@property(nonatomic, strong) ZTChatMessageListV0 *currentMsgListVo;
@property (strong, nonatomic) IBOutlet UIButton *getMoreDataBtn;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) NSString *previousDisplayContent;
@end

@implementation ZTChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取历史消息
    [self _getCurrentMessageList];
    // 发送欢迎语
    [self _sendWelcomText];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 配置键盘是否弹出
    if (![ZTUIConfiguration appearance].hideKeyboardOnEnterConsult) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatKeyBoard keyboardUp];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    END_EDITING;
    [self _sendRealTimeDisplayContent];
}

- (void)initSubviews {
    [super initSubviews];
    [self initNavTitle];
    [self initTableView];
    [self initTransferKefuBtn];
    [self initChatBoard];
}

// 初始化NavigationItem title
- (void)initNavTitle {
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleBtn.titleLabel.numberOfLines = 1;
    titleBtn.userInteractionEnabled = false;
    titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    if (![ZTUIConfiguration appearance].hideHeaderIcon) {
        if ([ZTUIConfiguration appearance].headerIcon) {
            [titleBtn setImage:[ZTUIConfiguration appearance].headerIcon forState:UIControlStateNormal];
        } else {
            NSString *iconStr = [self.agent.agentAvatar stringWithSize:CGSizeMake(25, 25) cornerRadius:0];
            [titleBtn setImageWithURLString:iconStr forState:UIControlStateNormal placeholder:nil];
        }
    }
    if (![ZTUIConfiguration appearance].hideHeaderTitle) {
        NSString *btnTitle;
        if ([ZTUIConfiguration appearance].headerTitle) {
            btnTitle = [ZTUIConfiguration appearance].headerTitle;
        } else {
            btnTitle = self.agent.nickName;
        }
        if (btnTitle.length > 8) {
            btnTitle = [btnTitle substringToIndex:8];
        }
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:btnTitle attributes:@{NSForegroundColorAttributeName : [ZTUIConfiguration appearance].navBarBarTintColor, NSFontAttributeName : [UIFont systemFontOfSize:[ZTUIConfiguration appearance].titleLabelSize]}];
        [titleBtn setAttributedTitle:attribute forState:UIControlStateNormal];

    }
    self.navigationItem.titleView = titleBtn;
}

- (void)initTableView {
    // TableView
    if (IOS_VERSION < 11.0) {
        self.tableViewTopLayoutConstraint.constant = 64;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.backgroundColor = [ZTUIConfiguration appearance].msgBackgroundColor;
    
    if ([ZTUIConfiguration appearance].msgBackgroundImage) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[ZTUIConfiguration appearance].msgBackgroundImage];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = [ZTUIConfiguration appearance].msgListViewDividerHeight;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.refreshHeader = [ZTRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(onPressedGetMoreMsgBtn:)];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_keyboardDown)];
    [self.tableView addGestureRecognizer:tapRecognizer];
    [self _registCells];
    
    self.heightDict = @{}.mutableCopy;
}

- (void)initChatBoard {
    // ChatKeyBoard
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleChat;
    self.chatKeyBoard.placeHolder = @"请输入消息";
    
    self.chatKeyBoard.allowVoice = ![ZTUIConfiguration appearance].hideAudio;
    self.chatKeyBoard.allowFace = ![ZTUIConfiguration appearance].hideEmoji;
    self.chatKeyBoard.allowMore =  ![ZTUIConfiguration appearance].hideSendPictureButton || ![ZTUIConfiguration appearance].hidePhotographButton;
    [self.view addSubview:self.chatKeyBoard];
    [self.view bringSubviewToFront:self.chatKeyBoard];
    self.chatKeyBoard.associateTableView = self.tableView;
}

- (void)initTransferKefuBtn {
    if (self.agent.isRobot) {
        self.transferKefuBtn.hidden = false;
    } else {
        self.transferKefuBtn.hidden = true;
    }
    [self.view bringSubviewToFront:self.transferKefuBtn];
}

- (void)updateHeaderView {
    self.getMoreDataBtn.hidden = false;
    
    [self.tableView.refreshHeader endRefresh];
    
    [self.getMoreDataBtn setTitle:@"查看更多消息" forState:UIControlStateNormal];
    
    if (self.currentMsgListVo.totalPageNum.integerValue > 0) {
        if (self.currentMsgListVo.pageNum.integerValue == self.currentMsgListVo.totalPageNum.integerValue) {
            [self.getMoreDataBtn setTitle:@"没有更多消息了" forState:UIControlStateNormal];
            self.getMoreDataBtn.userInteractionEnabled = false;
            self.tableView.refreshHeader.hidden = YES;
        } else {
            [self.getMoreDataBtn setTitle:@"查看更多消息" forState:UIControlStateNormal];
        }
    } else {
        // 当第一次接入会话的时候
        if (self.currentMsgListVo.pageNum.integerValue > self.currentMsgListVo.totalPageNum.integerValue) {
            [self.getMoreDataBtn setTitle:@"没有更多消息了" forState:UIControlStateNormal];
            self.getMoreDataBtn.userInteractionEnabled = false;
            self.tableView.refreshHeader.hidden = YES;
        }
    }
}
- (IBAction)onPressedTransferBtn:(UIButton *)sender {
    [[ZTIM sharedInstance].conversationManager switchToAgentWithRouteId:self.agent.routeId callBack:nil];
}

- (IBAction)onPressedGetMoreMsgBtn:(UIButton *)sender {
    
    self.getMoreDataBtn.hidden = true;
    [[ZTIM sharedInstance].conversationManager getHistoryMessagesWithVo:self.currentMsgListVo callBack:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        
    }];
}

#pragma mark - ZTConversationManager相关
-(void)onReceiveLogicMsgType:(ZTMsgLogicType)type content:(id)content {
    if (type == ZTMsgLogicTypeAppraise) {
        ZTAppraiseV0 *vo = content;
        [self showAppraiseView:vo];
    } else {
        [super onReceiveLogicMsgType:type content:content];
    }
}

- (void)onReceiveChatMsgType:(ZTChatMsgType)type content:(ZTSendMessageV0 *)content {
    ZT_Log(@"%@", content);
    if (type == ZTChatMsgHistory) {
        [self _dealHistoryMessage:content];
        return;
    }
    // 修改MsgType值
    content.msgType = type;
    content.from = content.from;
    [self.dataSource addObject:content];
    [self _scrollToBottom];
}

#pragma mark - ZTConversationManager privite
#pragma mark -
- (void)_dealHistoryMessage:(ZTSendMessageV0 *)content {
    ZTChatMessageListV0 *listVo = [ZTChatMessageListV0 voWithJson:content.content];
    self.currentMsgListVo = listVo;
    [self updateHeaderView];
    if (listVo.data && listVo.data.count > 0) {
        // 给每个消息里面添加头像
        [listVo.data enumerateObjectsUsingBlock:^(ZTSendMessageV0 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.avatar = listVo.agentAvatar;
        }];
        // 数据源里添加历史消息
        NSIndexSet *insertSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, listVo.data.count)];
        [self.dataSource insertObjects:[listVo.data.mutableCopy reverseObjectEnumerator].allObjects atIndexes:insertSet];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:listVo.data.count];
        // 第一次加载的时候
        if (self.dataSource.count - listVo.data.count == 1 && self.agent.isRefresh) {
            [self _scrollToBottom];
        } else {
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
        }
    }
}
#pragma mark -

- (void)_getCurrentMessageList {
    [self updateHeaderView];
    if (self.agent.isRefresh || self.agent.isRobot) {
        [[ZTIM sharedInstance].conversationManager getCurrenSessionMessageHistoryWithCallBack:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        }];
    }
}

- (void)_sendWelcomText {
    if (self.agent.data.isNotBlank) {
        [self _sendSystemMsg:self.agent.data];
    } else {
        [self _sendSystemMsg:[NSString stringWithFormat:@"您好，%@客服为您服务",self.agent.nickName]];
    }
    if (self.agent.welcomeText.isNotBlank) {
        ZTSendMessageV0 *message = [[ZTSendMessageV0 alloc]init];
        message.content = self.agent.welcomeText;
        message.msgType = ZTChatMsgTypeText;
        message.from = self.agent.agentId;
        message.createTime = [NSDate date].timeIntervalSince1970;
        [self.dataSource addObject:message];
    }
    
    [self _scrollToBottom];
}

- (void)_sendAudio:(NSURL *)URLPath {
    END_EDITING;

    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:URLPath options:nil];
    int audioDurationSeconds = (int)CMTimeGetSeconds(audioAsset.duration);

    if (audioDurationSeconds < 2.0) {
        [self.voiceRecordCtrl showToast:@"说话时间太短"];
        return;
    }
    
    ZTSendMessageV0 *message = [[ZTSendMessageV0 alloc]init];
    message.msgType = ZTChatMsgTypeRadio;
    message.from = @"0";
    message.createTime = [NSDate date].timeIntervalSince1970;
    message.audioDuration = audioDurationSeconds;
    message.status = ZTSendMessageStatusSending;
    [[ZTIM sharedInstance].conversationManager sendAudio:URLPath callBack:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        if (!anError && aResponseObject) {
            message.content = aResponseObject;
            message.status = ZTSendMessageStatusSuccess;
        }
    }];
    [self.dataSource addObject:message];
    [self _scrollToBottom];
}

- (void)_sendPicture:(UIImage *)image {
    UIImage *tempImage = [[UIImage alloc] initWithCIImage:image.CIImage];
    ZTSendMessageV0 *message = [[ZTSendMessageV0 alloc]init];
    message.msgType = ZTChatMsgTypePic;
    message.from = @"0";
    message.createTime = [NSDate date].timeIntervalSince1970;
    message.image = tempImage;
    message.status = ZTSendMessageStatusSending;
    
    [[ZTIM sharedInstance].conversationManager sendPicture:image callBack:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        if (!anError && aResponseObject) {
            message.content = aResponseObject;
            message.status = ZTSendMessageStatusSuccess;
        }
    }];
    [self.dataSource addObject:message];
    [self _scrollToBottom];
}

- (void)_sendText:(NSString *)text {
    if (!text.isNotBlank) {
        END_EDITING;
        [ZTToast showToast:@"不能发送空白消息"];
        return;
    }
    ZTSendMessageV0 *message = [[ZTSendMessageV0 alloc]init];
    message.msgType = ZTChatMsgTypeText;
    message.from = @"0";
    message.createTime = [NSDate date].timeIntervalSince1970;
    message.content = text;
    message.status = ZTSendMessageStatusSending;
    
    [[ZTIM sharedInstance].conversationManager sendText:text callBack:^(id  _Nullable aResponseObject, NSError * _Nullable anError) {
        if (!anError) {
            message.status = ZTSendMessageStatusSuccess;
        }
    }];
    [self.dataSource addObject:message];
    [self _scrollToBottom];
}

- (void)_sendSystemMsg:(NSString *)content {
    if (!content) {
        return;
    }
    ZTSendMessageV0 *message = [[ZTSendMessageV0 alloc]init];
    message.msgType = ZTChatMsgTypeSystem;
    message.to = self.agent.imId;
    message.createTime = [NSDate date].timeIntervalSince1970;
    message.content = content;
    
    [self.dataSource addObject:message];
    [self _scrollToBottom];
}

- (void)_startDisplayTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kContentRealTimeDisplayDuration target:self selector:@selector(_sendRealTimeDisplayContent) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)_stopDisplayTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)_sendRealTimeDisplayContent {
    if (![self.chatKeyBoard.chatToolBar.textView isFirstResponder]) {
        // 当不在焦点的时候传为nil
        [[ZTIM sharedInstance].conversationManager sendRealTimeDisplayContent:nil];
        self.previousDisplayContent = nil;
        [self _stopDisplayTimer];
    } else {
        if ([self.previousDisplayContent isEqualToString:self.chatKeyBoard.chatToolBar.textView.text]) {
            return;
        }
        self.previousDisplayContent = self.chatKeyBoard.chatToolBar.textView.text;
        [[ZTIM sharedInstance].conversationManager sendRealTimeDisplayContent:self.previousDisplayContent];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTSendMessageV0 *vo = self.dataSource[indexPath.section];
    ZTMessageCell *cell;
    switch (vo.msgType) {
        case ZTChatMsgTypeText:
        {
            if (vo.isMe) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTTextRightMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTTextLeftMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            }
            break;
        }
        case ZTChatMsgTypePic:
        {
            if (vo.isMe) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTPictureRightMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTPictureLeftMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            }
            break;
        }
        case ZTChatMsgTypeRadio:
        {
            if (vo.isMe) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTAudioRightMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTAudioLeftMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            }
            break;
        }
        case ZTChatMsgTypeVideo:
        {
            if (vo.isMe) {
                ZTVideoRightMessageCell * videoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTVideoRightMessageCell class]) forIndexPath:indexPath];
                videoCell.delegate = self;
                [videoCell updateCellWithVo:vo];
                return videoCell;
            } else {
               ZTVideoLeftMessageCell *videoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTVideoLeftMessageCell class]) forIndexPath:indexPath];
                videoCell.delegate = self;
                [videoCell updateCellWithVo:vo];
                return videoCell;
            }
            break;
        }
        case ZTChatMsgTypeFile:
        {
            if (vo.isMe) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTFileRightMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTFileLeftMessageCell class]) forIndexPath:indexPath];
                [cell updateCellWithVo:vo];
            }
            break;
        }
        case ZTChatMsgTypeSystem:
        {
            ZTSystemMessageCell *tempCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTSystemMessageCell class]) forIndexPath:indexPath];
            [tempCell updateCellWithVo:vo];
            return tempCell;
        }
        default:
        {
            UITableViewCell *cell = [UITableViewCell new];
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTSendMessageV0 *vo = self.dataSource[indexPath.section];
    switch (vo.msgType) {
        case ZTChatMsgTypeText:
        case ZTChatMsgTypeSystem:
            return UITableViewAutomaticDimension;
        case ZTChatMsgTypeExpression:
            return 0;
        case ZTChatMsgTypePic:
        case ZTChatMsgTypeVideo:
            return 120;
        case ZTChatMsgTypeRadio:
            return 54;
        case ZTChatMsgTypeFile:
            return 86;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.heightDict objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    } else {
        return 53;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightDict setObject:height forKey:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self _keyboardDown];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self _keyboardDown];
}

#pragma mark - priveite tableView 相关
// 滚动到底部
- (void)_scrollToBottom {
    if (self.dataSource && self.dataSource.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.dataSource.count - 1];
        [self _scrollToIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)_scrollToIndexPath:(NSIndexPath *)indexPath
          atScrollPosition:(UITableViewScrollPosition)scrollPosition
                  animated:(BOOL)animated {
    
    [self.tableView reloadData];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (indexPath.section < [self.tableView numberOfSections]) {
            [strongSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        }
    });
}

- (void)_keyboardDown {
    [self.chatKeyBoard keyboardDown];
}

- (void)_registCells {
    [self _registCell:[ZTTextLeftMessageCell class]];
    [self _registCell:[ZTTextRightMessageCell class]];
    
    [self _registCell:[ZTPictureLeftMessageCell class]];
    [self _registCell:[ZTPictureRightMessageCell class]];
    
    [self _registCell:[ZTAudioLeftMessageCell class]];
    [self _registCell:[ZTAudioRightMessageCell class]];
    
    [self _registCell:[ZTVideoLeftMessageCell class]];
    [self _registCell:[ZTVideoRightMessageCell class]];
    
    [self _registCell:[ZTFileLeftMessageCell class]];
    [self _registCell:[ZTFileRightMessageCell class]];
    
    [self _registCell:[ZTSystemMessageCell class]];
}

- (void)_registCell:(Class)cls {
    NSString *identifier = NSStringFromClass(cls);
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:[ZTHelper currentBundle]] forCellReuseIdentifier:identifier];
}

#pragma mark - ZTVideoMessageCellDelegate
- (void)videoMessageCell:(ZTVideoLeftMessageCell *)cell didClickedPlayBtn:(UIButton *)btn sendMessageVO:(ZTSendMessageV0 *)vo {
    AVPlayer *avPlayer= [AVPlayer playerWithURL:[NSURL URLWithString:vo.content]];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = avPlayer;
    playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
    playerVC.showsPlaybackControls = YES;
    [self presentViewController:playerVC animated:YES completion:^{
        [playerVC.player play];
    }];
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems {
    NSMutableArray *items = @[].mutableCopy;
    if (![ZTUIConfiguration appearance].hideSendPictureButton) {
        MoreItem *item1 = [MoreItem moreItemWithPicName:@"icon_photo" highLightPicName:@"icon_photo" itemName:@"图片"];
        [items addObject:item1];
    }
    if (![ZTUIConfiguration appearance].hidePhotographButton) {
        MoreItem *item2 = [MoreItem moreItemWithPicName:@"icon_camera" highLightPicName:@"icon_camera" itemName:@"拍照"];
        [items addObject:item2];
    }
    return items;
}

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems {
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems {
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"expression"];
    
    for (int i = 0; i < sources.count; ++i)
    {
        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
        themeM.themeStyle = FaceThemeStyleCustomEmoji;
        themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (NSDictionary *obj in [ZTExpressionManager sharedInstance].expressions) {
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceIcon = obj.allValues.firstObject;
            fm.faceTitle = obj.allKeys.firstObject;
            [modelsArr addObject:fm];
        }
        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    
    return subjectArray;
}

#pragma mark - ChatKeyBoardDelegate
// 录音
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard {
    if (![ZTHelper canRecord]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.recorder startRecording];
    self.currentRecordState = ZTRecordState_Recording;
    [self _dispatchVoiceState];
}

- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard {
    [self.recorder stopRecording];
    [self _sendAudio:self.recorder.recordFileUrl];
    
    self.currentRecordState = ZTRecordState_Normal;
    [self _dispatchVoiceState];
}

- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard {
    self.currentRecordState = ZTRecordState_Normal;
    [self.recorder stopRecording];
    [self _dispatchVoiceState];
}

- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard {
    self.currentRecordState = ZTRecordState_ReleaseToCancel;
    [self _dispatchVoiceState];
}

- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard {
    self.currentRecordState = ZTRecordState_Recording;
    [self _dispatchVoiceState];
}

// 更多
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self _choosePhoto];
            break;
        case 1:
            [self _takePhoto];
            break;
        default:
            break;
    }
}

// 文字
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView {
    [self _startDisplayTimer];
}

#pragma mark - 相册
- (void)_takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusDenied:
        {
//            ZT_Log(@"用户拒绝");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开启相机权限" message:@"开启相机权限,才能拍摄照片" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
                if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
            break;
        case AVAuthorizationStatusAuthorized:
//            ZT_Log(@"用户同意");
            [self _doTakePhoto];
            break;
        case AVAuthorizationStatusNotDetermined:
            ZT_Log(@"用户还未授权");
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
//                    ZT_Log(@"用户同意");
                    __weak __typeof(self)weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                        [strongSelf _doTakePhoto];
                    });
                }
                else {
//                    ZT_Log(@"用户拒绝");
                }
            }];
        }
            break;
        default:
//            ZT_Log(@"无法访问摄像头");
            break;
    }
}

- (void)_doTakePhoto {
    self.pickerHelper = [[ZTImagePickerHelper alloc] init];
    __weak __typeof(self)weakSelf = self;
    [self.pickerHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UIImage *originalImage = editingInfo[UIImagePickerControllerOriginalImage];
        [strongSelf _sendPicture:originalImage];
    }];
}

- (void)_choosePhoto {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusDenied:
//            ZT_Log(@"用户拒绝");
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开启相册权限" message:@"开启相册权限,才能选取照片" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
                if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case PHAuthorizationStatusAuthorized:
//            ZT_Log(@"同意");
            [self _doChoosePhoto];
            break;
        case PHAuthorizationStatusNotDetermined:
//            ZT_Log(@"用户还未授权");
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
//                        ZT_Log(@"用户同意");
                    {
                        __weak __typeof(self)weakSelf = self;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            [strongSelf _doChoosePhoto];
                        });
                    }
                        break;
                    default:
//                        ZT_Log(@"用户拒绝");
                        break;
                }
            }];
        }
            break;
        default:
//            ZT_Log(@"无法访问相册");
            break;
    }
}

- (void)_doChoosePhoto {
    self.pickerHelper = [[ZTImagePickerHelper alloc] init];
    __weak __typeof(self)weakSelf = self;
    [self.pickerHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UIImage *originalImage = editingInfo[UIImagePickerControllerOriginalImage];
        [strongSelf _sendPicture:originalImage];
    }];
}


#pragma mark - privite 录音相关
- (void)_startFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
    self.fakeTimer = [NSTimer scheduledTimerWithTimeInterval:kFakeTimerDuration target:self selector:@selector(_onFakeTimerTimeOut) userInfo:nil repeats:YES];
    [_fakeTimer fire];
}

- (void)_stopFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
}

- (void)_onFakeTimerTimeOut {
    self.duration += kFakeTimerDuration;
    ZT_Log(@"+++duration+++ %f",self.duration);
    float remainTime = kMaxRecordDuration-self.duration;
    if ((int)remainTime == 0) {
        self.currentRecordState = ZTRecordState_Normal;
        [self.recorder stopRecording];
        [self _dispatchVoiceState];
    }
    else if ([self _shouldShowCounting]) {
        self.currentRecordState = ZTRecordState_RecordCounting;
        [self _dispatchVoiceState];
        [self.voiceRecordCtrl showRecordCounting:remainTime];
    }
    else {
        [self.recorder.recorder updateMeters];
        float   level = 0.0f;                // The linear 0.0 .. 1.0 value we need.
        
        float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
        float decibels = [self.recorder.recorder peakPowerForChannel:0];
        if (decibels < minDecibels) {
            level = 0.0f;
        } else if (decibels >= 0.0f) {
            level = 1.0f;
        } else {
            float   root            = 2.0f;
            float   minAmp          = powf(10.0f, 0.05f * minDecibels);
            float   inverseAmpRange = 1.0f / (1.0f - minAmp);
            float   amp             = powf(10.0f, 0.05f * decibels);
            float   adjAmp          = (amp - minAmp) * inverseAmpRange;
            level = powf(adjAmp, 1.0f / root);
        }
//        ZT_Log(@"平均值 %f", level );
        [self.voiceRecordCtrl updatePower:level];
    }
}

- (BOOL)_shouldShowCounting {
    if (self.duration >= (kMaxRecordDuration-kRemainCountingDuration) && self.duration < kMaxRecordDuration && self.currentRecordState != ZTRecordState_ReleaseToCancel) {
        return YES;
    }
    return NO;
}

- (void)_resetState {
    [self _stopFakeTimer];
    self.duration = 0;
}

- (void)_dispatchVoiceState {
    if (_currentRecordState == ZTRecordState_Recording) {
        [self _startFakeTimer];
    }
    else if (_currentRecordState == ZTRecordState_Normal)
    {
        [self _resetState];
    }
    [self.voiceRecordCtrl updateUIWithRecordState:_currentRecordState];
    
}

#pragma mark - 文字发送

- (void)chatKeyBoardSendText:(NSString *)text {
    [self _sendText:text];
}

#pragma mark - 评价
- (void)showAppraiseView:(ZTAppraiseV0 *)vo {
    END_EDITING;
    self.appraisView.frame = [UIScreen mainScreen].bounds;
    [self.appraisView updateAppraisViewWithAppraiseVO:vo];
    [self.view addSubview:self.appraisView];
    [self.view bringSubviewToFront:self.appraisView];
}
- (IBAction)onPressedSubmitBtn:(UIButton *)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"optionName"] = self.appraisView.currentOption.optionName;
    params[@"optionOrder"] = self.appraisView.currentOption.optionOrder;
    params[@"evaDescriptText"] = self.appraisView.appraisTV.text;
    __weak __typeof(self)weakSelf = self;
    [[ZTIM sharedInstance].conversationManager appriseWithContent:params.copy callBack:^(NSError *anError) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!anError) {
            [strongSelf.appraisView removeFromSuperview];
            // 坐席主动结束会话
            if (self.appraisView.appraiseVO.remarkType.integerValue == 1) {
                [strongSelf onPressedBack:nil];
            } else {
                [strongSelf _sendSystemMsg:@"您已作出评价, 感谢您的支持"];
            }
        }
    }];
}

- (IBAction)onPressedCancelBtn:(UIButton *)sender {
    [self.appraisView removeFromSuperview];
    // 坐席主动结束会话
    if (self.appraisView.appraiseVO.remarkType.integerValue == 1) {
        [self onPressedBack:nil];
        [[ZTIM sharedInstance].conversationManager appriseFinish];
    }
}

- (void)dealloc {
    [[ZTPlayerManager sharedInstance] stop];
}

#pragma mark - setters and getters

- (NSMutableArray<ZTSendMessageV0 *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (ZTRecorderManager *)recorder {
    if (!_recorder) {
        _recorder = [ZTRecorderManager sharedInstance];
    }
    return _recorder;
}

- (ZTRecordShowManager *)voiceRecordCtrl {
    if (!_voiceRecordCtrl) {
        _voiceRecordCtrl = [ZTRecordShowManager new];
    }
    return _voiceRecordCtrl;
}

- (ZTAgentV0 *)agent {
    return [ZTIM sharedInstance].conversationManager.currentAgent;
}
@end
