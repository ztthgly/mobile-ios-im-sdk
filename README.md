# ZT_IM_SDK

# 中通天鸿 iOS SDK 开发指南
## 1.简介
#### 中通天鸿 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 APP 中。iOS SDK 支持 iOS 9 以上版本，目前只支持iphone竖屏

## 2.将SDK导入工程
#### CocoaPods集成:
1. 在Podfile文件中加入SDK(包含逻辑界面和Lib库)

```
pod 'ZT_IM_SDK/SDKKit'
```
假若完全自定义也可以单独引入Lib库: 

```
pod 'ZT_IM_SDK/SDKLib'
```

> 备注: 
> 
> ZT_IM_SDK  SDKLib库依赖:'Protobuf','3.6.0','SocketRocket','0.5.1','YYModel', '1.0.4'

> ZT_IM_SDK SDKKit依赖:YYWebImage, SDKLib

#### https相关:
SDK已经全面支持https，但是聊天消息中可能存在链接，点击链接会用UIWebView打开，链接地址有可能是http的，为了能够正常打开，需要增加配置项。在Info.plist中加入以下内容：

```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```
#### iOS10权限设置
在Info.plist中加入以下内容：

```
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME)需要访问您的相机</string>
<key>NSContactsUsageDescription</key>
<string>$(PRODUCT_NAME)需要访问您的通讯录？</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME)需要访问您的麦克风</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<key>NSPhotoLibraryUsageDescription</key>
<string>$(PRODUCT_NAME)需要访问您的相册</string>
```

#### iOS 11权限设置
在Info.plist中加入以下内容：

```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>$(PRODUCT_NAME)需要您的同意,才能保存图片到您的相册</string>
```

## 3. 初始化SDK

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
ZTUserV0 *vo = [ZTUserV0 new];
vo.tid = kTid;
vo.userName = [NSString stringWithFormat:@"App接入用户%@",kTid];
vo.avatar = @"http://img.qqu.cc/uploads/allimg/150530/1-1505301S542.jpg";
[[ZTIM sharedInstance] registerChannelKey:kChannelKey User:vo];
...
return YES;
}
```

1. channlKey可以在“管理后台” -> “配置” -> "渠道配置" ->“App接入” -> “2. secret Key” 找到。 
2. tid对应的用户唯一标识符, 代表的是聊天用户的身份, 后台会根据tid获取到相应的imId,才能支持聊天. 推荐使用用户的唯一标识符, 若为空则为设备ID
3. 一般在“application: didFinishLaunchingWithOptions:”这个方法里面调用“registerChannelKey:”方法，这个方法会注册一个IM服务
4. 倘若存在切换用户的情况, 请重新使用注册方法
```
[[ZTIM sharedInstance] registerChannelKey:kChannelKey User:vo];
```

## 4. 集成聊天组件(必须)

```
ZTConversationVC *vc = [[ZTConversationVC alloc] init];
// 发起页: 可以在坐席侧看到
vc.sourcePageName = @"Demo开始页";
// 着陆页
vc.landingPageName = @"";
[self.navigationController pushViewController:vc animated:YES];
```

> 目前只支持NavigationController push 操作

## 5. 聊天界面自定义

支持自定义的选项:

```
#pragma mark - 导航栏
// 导航栏backGroudImage
@property(nonatomic, strong) UIImage *navBarBackgroundImage UI_APPEARANCE_SELECTOR;
// 导航栏文字填充颜色
@property(nonatomic, strong) UIColor *navBarBarTintColor UI_APPEARANCE_SELECTOR;

// 导航栏名称, 如何不设置则显示坐席信息
@property(nonatomic, strong) NSString *headerTitle UI_APPEARANCE_SELECTOR;
// 隐藏导航栏名称
@property(nonatomic, assign) BOOL hideHeaderTitle UI_APPEARANCE_SELECTOR;
// 导航栏Icon, 如果不设置则显示坐席头像
@property(nonatomic, strong) UIImage *headerIcon UI_APPEARANCE_SELECTOR;
// 隐藏导航栏的图像 默认为false, 隐藏icon
@property(nonatomic, assign) BOOL hideHeaderIcon UI_APPEARANCE_SELECTOR;
// 导航栏title大小
@property(nonatomic, assign) NSInteger titleLabelSize UI_APPEARANCE_SELECTOR;

#pragma mark - 整体
@property(nonatomic, strong) UIImage *msgBackgroundImage UI_APPEARANCE_SELECTOR;
// 主题色
@property(nonatomic, strong) UIColor *msgBackgroundColor UI_APPEARANCE_SELECTOR;

#pragma mark - 消息区
// 消息列表消息项间距
@property(nonatomic, assign) NSInteger msgListViewDividerHeight UI_APPEARANCE_SELECTOR;
// 隐藏左侧(客服消息)头像 默认false
@property(nonatomic, assign) BOOL hideLeftAvatar UI_APPEARANCE_SELECTOR;
// 隐藏右侧(访客消息)头像 默认false
@property(nonatomic, assign) BOOL hideRightAvatar UI_APPEARANCE_SELECTOR;
// 头像形状 默认为0，0为圆形头像，1为方形头像
@property(nonatomic, assign) NSInteger avatarShape UI_APPEARANCE_SELECTOR;

// 提示类消息的字体颜色（包括分配客服消息，消息时间标签等）
@property(nonatomic, strong) UIColor *tipsTextColor UI_APPEARANCE_SELECTOR;
// 提示类消息的字体大小（包括分配客服消息，消息时间标签等）
@property(nonatomic, assign) NSInteger tipsTextSize UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *tipsBackgroundColor UI_APPEARANCE_SELECTOR;

// 左边消息项背景,同时影响文本和语音消息
@property(nonatomic, strong) UIImage *msgLeftItemBgNormol UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIImage *msgLeftItemBgSelcted UI_APPEARANCE_SELECTOR;
// 右边消息项背景,同时影响文本和语音消息
@property(nonatomic, strong) UIImage *msgRightItemBgNormol UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIImage *msgRightItemBgSelcted UI_APPEARANCE_SELECTOR;
// 文本消息字体颜色
@property(nonatomic, strong) UIColor *textMsgLeftColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *textMsgRightColor UI_APPEARANCE_SELECTOR;
// 文本消息字体大小
@property(nonatomic, assign) NSInteger textMsgSize UI_APPEARANCE_SELECTOR;

#pragma mark - 输入区
// 隐藏表情按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideEmoji UI_APPEARANCE_SELECTOR;
// 隐藏拍照按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hidePhotographButton UI_APPEARANCE_SELECTOR;
// 隐藏语音切换按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideAudio UI_APPEARANCE_SELECTOR;
// 隐藏发送图片按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideSendPictureButton UI_APPEARANCE_SELECTOR;
// 在进入聊天界面时是否隐藏输入键盘 默认为 false，进入时就自动弹出键盘
@property(nonatomic, assign) BOOL hideKeyboardOnEnterConsult UI_APPEARANCE_SELECTOR;

```

> 如何使用

```
// 隐藏拍照按钮 
[ZTUIConfiguration appearance].hidePhotographButton = YES
....
```
## 6. 浏览轨迹

```
/**
用户访问轨迹

@param title 访问的标题
@param enterOrOut 进入或者退出
*/
- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut

```

> App在调用trackHistory:title:enterOrOut:key会自动记录一条轨迹,然后再进入聊天的时候,会将浏览轨迹自动发送给客服

## 7. 消息发送

1. 发送文本消息

```
/**
发送文本消息

@param text 文本内容
@param aBlock callback
*/
- (void)sendText:(NSString *)text callBack:(ZTCompletionBlock)aBlock;

```

2. 发送图片

```
/**
发送图片

@param image 想要发送给后台的Image
@param aBlock callBack
*/
- (void)sendPicture:(UIImage *)image callBack:(ZTCompletionBlock)aBlock;
```

3. 发送语音

```
/**
发送语音

@param audioURLPath 语音所在的本地地址
@param aBlock callBack
*/
- (void)sendAudio:(NSURL *)audioURLPath callBack:(ZTCompletionBlock)aBlock;

```
> 更多Conversation相关信息,ZTConversationManager.h

## 8. 消息获取

1. 添加代理

```
[[ZTIM sharedInstance].conversationManager addDelegate:self];

```

2. 代理

```
@protocol ZTConversationManagerDeleage <NSObject>

@optional
/**
已连接
*/
- (void)onConnect;

/**
收到逻辑跳转消息

@param type 消息类型

@param content 返回数据
ZTMsgLogicTypeBusy : NSString
ZTMsgLogicTypeRank: ZTRankVO
ZTMsgLogicTypeConnWinthSeat:
ZTMsgLogicTypeLeaveMessage: NSString
ZTMsgLogicTypeChooseNavi: ZTNavigationInfoV0
*/
- (void)onReceiveLogicMsgType:(ZTMsgLogicType)type content:(nullable id)content;

/**
聊天内消息类型

@param type 聊天消息类型
@param content 内容
*/
- (void)onReceiveChatMsgType:(ZTChatMsgType)type content:(ZTSendMessageV0 *)content;

/**
收到系统关闭Socket连接消息

@param code 错误code
@param reason 错误原因
*/
- (void)onCloseWithCode:(NSInteger)code reason:(NSString *)reason;

@end
```

3. 关闭代理

```
[[ZTIM sharedInstance].conversationManager removeAllDelegates];
[[ZTIM sharedInstance].conversationManager removeDelegate:self];

```



## License

ZT_IM_SDK is available under the MIT license. See the LICENSE file for more info.

