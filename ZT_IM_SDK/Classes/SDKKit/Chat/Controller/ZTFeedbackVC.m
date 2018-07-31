//
//  ZTFeedbackVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTFeedbackVC.h"
#import "ZTTextView.h"
#import "UIView+ZTKit.h"
#import "ZTToast.h"

static NSInteger const kMaxTimeoutSeconds = 180;

@interface ZTFeedbackVC ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet ZTTextView *feedbackTV;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property(nonatomic, strong) NSTimer *timer;
@end

@implementation ZTFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = self.info;
    self.feedbackTV.maxLength = 300;
    [self addKeyboardObservers];
    [self createTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

//NSTimer
-(void)createTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(feedbackTimeout:) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}
- (void)addKeyboardObservers {
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        strongSelf.scrollView.contentInset = contentInsets;
        strongSelf.scrollView.scrollIndicatorInsets = contentInsets;
        
        // 判断submitBtn与键盘的高度大小, 若大于键盘的高度则不必缩回去
        CGPoint aPoint = strongSelf.submitBtn.origin;
        CGFloat keyboardDistance = strongSelf.scrollView.height - strongSelf.submitBtn.height - strongSelf.submitBtn.originY - kbSize.height;
        if (keyboardDistance < 10) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height - (strongSelf.scrollView.height - strongSelf.submitBtn.originY - strongSelf.submitBtn.height) + 10.0);
            [strongSelf.scrollView setContentOffset:scrollPoint animated:YES];
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        if (IOS_VERSION < 11.0 ) {
            contentInsets = UIEdgeInsetsMake(64, 0, 0, 0);
        }
        strongSelf.scrollView.contentInset = contentInsets;
        strongSelf.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)initSubviews {
    [super initSubviews];
    [self.scrollView addSubview:self.mainView];
    self.title = @"请您留言";
    self.infoLabel.text = @"您好，当前无客服在线。如需帮助，请在下面留言，我们将尽快联系并解决您的问题。";
    
    self.feedbackTV.layer.borderWidth = 0.5;
    self.feedbackTV.layer.borderColor = UIColorMake(221, 221, 221).CGColor;
    self.feedbackTV.layer.cornerRadius = 4;
}
- (IBAction)onPressedSubmitFeedbackBtn:(UIButton *)sender {
    END_EDITING;
    if (![self _checkPhone:self.phoneTF.text]) {
        [ZTToast showToast:@"手机号有误, 请填写正确的手机号"];
        return;
    }
    if (![self _checkEmail:self.emailTF.text]) {
        [ZTToast showToast:@"邮箱有误, 请填写正确邮箱地址"];
        return;
    }
    if (!self.feedbackTV.text || self.feedbackTV.text.length == 0) {
        [ZTToast showToast:@"留言内容不能为空!"];
        return;
    }
    END_EDITING;
    [[ZTIM sharedInstance].conversationManager feedBackWithPhone:self.phoneTF.text email:self.emailTF.text conten:self.feedbackTV.text callBack:^(NSError * _Nullable anError) {
        if (!anError) {
            [self showEmptyViewWithImage:UIImageMake(@"chenggong") text:@"留言成功，我们将尽快与您联系~" detailText:nil buttonTitle:nil buttonAction:nil];
            [self stopTimer];
        }
    }];
}

- (void)feedbackTimeout:(NSTimer *)timer {
    static seconds = 0;
    ++seconds;
    if (seconds % kMaxTimeoutSeconds == 0) {
        // 留言超时
        [self stopTimer];
        [[ZTIM sharedInstance].conversationManager feedBackTimeout];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)_checkEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)_checkPhone:(NSString *)phone {
    NSString *charRegex = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
    NSPredicate *charPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", charRegex];
    return [charPre evaluateWithObject:phone];
}

@end
