//
//  ZTRecordToastContentView.m
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import "ZTRecordToastContentView.h"
#import "ZTRecordPowerAnimationView.h"
#import "ZTUICommonDefine.h"

@implementation ZTRecordToastContentView

@end

//----------------------------------------//
@interface ZTRecordingView ()
@property (nonatomic, strong) UIImageView *imgRecord;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) ZTRecordPowerAnimationView *powerView;
@end

@implementation ZTRecordingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.lbContent = [[UILabel alloc] init];
    self.lbContent.text = @"手指上滑 取消发送";
    self.lbContent.textColor = [UIColor whiteColor];
    self.lbContent.textAlignment = NSTextAlignmentCenter;
    self.lbContent.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.lbContent];

    self.imgRecord = [[UIImageView alloc] init];
    self.imgRecord.image = UIImageMake(@"ic_record");
    [self addSubview:self.imgRecord];
    
    self.powerView = [[ZTRecordPowerAnimationView alloc] init];
    [self addSubview:self.powerView];

    //默认显示一格音量
    [self.powerView updateWithPower:0];
}

- (void)updateWithPower:(float)power
{
    [self.powerView updateWithPower:power];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbContent sizeToFit];
    self.lbContent.frame = CGRectMake(0, self.frame.size.height - self.lbContent.frame.size.height - 12, self.frame.size.width, self.lbContent.frame.size.height);
    
    self.imgRecord.frame = CGRectMake(40, 30, self.imgRecord.image.size.width, self.imgRecord.image.size.height);

    self.powerView.frame = CGRectMake(self.imgRecord.frame.origin.x+self.imgRecord.frame.size.width + 6, self.imgRecord.frame.origin.y+self.imgRecord.frame.size.height-56, 29, 54);
}
@end

//----------------------------------------//
@interface ZTRecordReleaseToCancelView ()
@property (nonatomic, strong) UIImageView *imgRelease;
@property (nonatomic, strong) UILabel *lbContent;
@end

@implementation ZTRecordReleaseToCancelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.lbContent = [[UILabel alloc] init];
    self.lbContent.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.lbContent.text = @"松开手指 取消发送";
    self.lbContent.textColor = [UIColor whiteColor];
    self.lbContent.textAlignment = NSTextAlignmentCenter;
    self.lbContent.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.lbContent];

    self.imgRelease = [[UIImageView alloc] init];
    self.imgRelease.image = UIImageMake(@"ic_release_to_cancel");
    [self addSubview:self.imgRelease];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgRelease.frame = CGRectMake((self.frame.size.width - self.imgRelease.image.size.width) * 0.5, 30, self.imgRelease.image.size.width, self.imgRelease.image.size.height);
    
    self.lbContent.frame = CGRectMake(6, self.frame.size.height - 25 - 7, self.frame.size.width - 12, 25);
    
    self.lbContent.layer.cornerRadius = 2;
    self.lbContent.clipsToBounds = YES;
}
@end

//----------------------------------------//
@interface ZTRecordCountingView ()
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UILabel *lbRemainTime;
@end

@implementation ZTRecordCountingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
        self.lbContent = [[UILabel alloc] init];
//        _lbContent.backgroundColor = [UIColor colorWithHex:0xA52E2C];
        self.lbContent.text = @"松开手指 取消发送";
        self.lbContent.textColor = [UIColor whiteColor];
        self.lbContent.textAlignment = NSTextAlignmentCenter;
        self.lbContent.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.lbContent];
    
        self.lbRemainTime = [[UILabel alloc] init];
        self.lbRemainTime.font = [UIFont boldSystemFontOfSize:80];
        self.lbRemainTime.textColor = [UIColor whiteColor];
        [self addSubview:self.lbRemainTime];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lbContent.frame = CGRectMake(6, self.frame.size.height - 25 - 7, self.frame.size.width - 12, 25);
    self.lbContent.layer.cornerRadius = 2;
    self.lbContent.clipsToBounds = YES;
    
    [self.lbRemainTime sizeToFit];
    self.lbRemainTime.frame = CGRectMake((self.frame.size.width - self.lbRemainTime.frame.size.width) * 0.5, 16, self.lbRemainTime.frame.size.width, 95);
}
- (void)updateWithRemainTime:(float)remainTime
{
    self.lbRemainTime.text = [NSString stringWithFormat:@"%d",(int)remainTime];
    [self setNeedsLayout];
}

@end

//----------------------------------------//
@interface ZTRecordTipView ()
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *lbContent;
@end

@implementation ZTRecordTipView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.lbContent = [[UILabel alloc] init];
    self.lbContent.textColor = [UIColor whiteColor];
    self.lbContent.textAlignment = NSTextAlignmentCenter;
    self.lbContent.font = [UIFont systemFontOfSize:14];
    self.lbContent.text = @"说话时间太短";
    [self addSubview:self.lbContent];

    self.imgIcon = [[UIImageView alloc] init];
    self.imgIcon.image = UIImageMake(@"ic_record_too_short");
    [self addSubview:self.imgIcon];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    
    self.imgIcon.frame = CGRectMake((self.frame.size.width - self.imgIcon.image.size.width) * 0.5, 32, self.imgIcon.image.size.width, self.imgIcon.image.size.height);
    
    self.lbContent.frame = CGRectMake(0, self.frame.size.height - 25 - 7, self.frame.size.width, 25);
}
- (void)showWithMessage:(NSString *)msg
{
    self.lbContent.text = msg;
    [self setNeedsLayout];
}
@end


