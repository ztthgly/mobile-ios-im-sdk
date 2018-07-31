//
//  ZTVoiceRecordView.m
//  ZTRecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import "ZTRecordView.h"
#import "ZTRecordToastContentView.h"
@interface ZTRecordView ()
@property (nonatomic, strong) ZTRecordingView *recodingView;
@property (nonatomic, strong) ZTRecordReleaseToCancelView *releaseToCancelView;
@property (nonatomic, strong) ZTRecordCountingView *countingView;
@property (nonatomic, assign) ZTRecordState currentState;
@property(nonatomic, strong) UIView *contentView;
@end

@implementation ZTRecordView
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
    self.backgroundColor = [UIColor clearColor];

    CGRect frame = CGRectMake(0, 0, 150, 150);
    CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);

    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor grayColor];
    self.contentView.frame = frame;
    self.contentView.center = center;
    [self addSubview:self.contentView];
    
    self.recodingView = [[ZTRecordingView alloc] init];
    [self.contentView addSubview:self.recodingView];
    self.recodingView.hidden = YES;

    self.releaseToCancelView = [[ZTRecordReleaseToCancelView alloc] init];
    [self.contentView addSubview:self.releaseToCancelView];
    self.releaseToCancelView.hidden = YES;
    
    self.countingView = [[ZTRecordCountingView alloc] init];
    [self.contentView addSubview:self.countingView];
    self.countingView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.clipsToBounds = YES;
    self.recodingView.frame = self.contentView.bounds;
    self.releaseToCancelView.frame = self.contentView.bounds;
    self.countingView.frame = self.contentView.bounds;
}

- (void)updatePower:(float)power
{
    if (self.currentState != ZTRecordState_Recording) {
        return;
    }
    [self.recodingView updateWithPower:power];
}

- (void)updateWithRemainTime:(float)remainTime
{
    if (self.currentState != ZTRecordState_RecordCounting || self.releaseToCancelView.hidden == false) {
        return;
    }
    [self.countingView updateWithRemainTime:remainTime];
}

- (void)updateUIWithRecordState:(ZTRecordState)state
{
    self.currentState = state;
    if (state == ZTRecordState_Normal) {
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }
    else if (state == ZTRecordState_Recording)
    {
        self.recodingView.hidden = NO;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }
    else if (state == ZTRecordState_ReleaseToCancel)
    {
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = NO;
        self.countingView.hidden = YES;
    }
    else if (state == ZTRecordState_RecordCounting)
    {
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = NO;
    }
    else if (state == ZTRecordState_RecordTooShort)
    {
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }
}
@end
