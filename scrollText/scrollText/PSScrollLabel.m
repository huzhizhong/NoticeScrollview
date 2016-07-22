//
//  PSScrollLabel.m
//  scrollText
//
//  Created by chaiqiwei on 16/7/7.
//  Copyright © 2016年 chaiqiwei. All rights reserved.
//

#import "PSScrollLabel.h"
@interface PSScrollLabel()

@end

@implementation PSScrollLabel

- (void)dealloc
{
    [self animationStop];
    _tapBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)initSubviews
{
    
    [self initData];
    if (!_labelAry)
    {
        _labelAry = [[NSMutableArray alloc]initWithCapacity:0];
    }
    self.clipsToBounds = YES;
    if (!_labelOne)
    {
        _labelOne = [UILabel new];
        _labelOne.userInteractionEnabled = YES;
        _labelOne.textAlignment = NSTextAlignmentLeft;
        _labelOne.textColor = [UIColor brownColor];
        _labelOne.font = [UIFont systemFontOfSize:16];
        [self addSubview:_labelOne];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
        [_labelOne addGestureRecognizer:tap];
        [_labelAry addObject:_labelOne];
    }
    if (!_labelTwo)
    {
        _labelTwo = [UILabel new];
        _labelTwo.userInteractionEnabled = YES;
        _labelTwo.textAlignment = NSTextAlignmentLeft;
        _labelTwo.textColor = [UIColor brownColor];
        _labelTwo.font = [UIFont systemFontOfSize:16];
        [self addSubview:_labelTwo];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
        [_labelTwo addGestureRecognizer:tap];
        [_labelAry addObject:_labelTwo];
    }
}

- (void)lableTap:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    NSInteger idx = _currIdx;
    if (label == _labelTwo ) {
        idx = _lastIdx;
    }
    if (_tapBlock) {
        _tapBlock(label.text,idx);
    }
}

- (void)initData
{
    _currIdx = 0;
    _lastIdx = 1;
    _isAnimating = NO;
    _stayTime = 3.0f;
    _continuTimeOne = 0.0f;
    _continuTimeTwo = 0.0f;
    _timerOneRun = NO;
    _timerOnePause = NO;
    _timerTwoRun = NO;
    _timerTwoPause = NO;
    _pause = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setMessageAry:(NSArray *)messageAry
{
    _messageAry = messageAry;
    
    if (_isAnimating) {
        [self animationStop];
        [self initData];
    }
    
    if (_messageAry.count == 1) {
        _isAnimating = NO;
        _labelOne.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _labelOne.text = _messageAry[0];
    } else {
        _isAnimating = YES;
        _labelOne.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);  //label1 初始位置
        _labelTwo.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height); //label2 初始位置
        _labelOne.text = _messageAry[_currIdx];
        _labelTwo.text = _messageAry[_lastIdx];
    }
    
    if (_isAnimating) {
        [self animationBegin:_labelOne];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    for (UILabel *label in _labelAry) {
        label.textColor = textColor;
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    for (UILabel *label in _labelAry) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    for (UILabel *label in _labelAry) {
        label.textAlignment = alignment;
    }
}


- (void)updateLabel:(NSTimer *)timer
{
    if (_pause) {
        return;
    }
    UILabel *label = (UILabel *)timer.userInfo;
    CGFloat continuTime = 0.0f;
    if (label == _labelOne) {
        if (_timerOnePause) {
            return;
        }
        continuTime = _continuTimeOne;
    } else {
        if (_timerTwoPause) {
            return;
        }
        continuTime = _continuTimeTwo;
    }
    CGFloat height = label.frame.size.height/60.0f;
    CGFloat currY = label.frame.origin.y;
    
    if (currY > 0) {
        label.frame = CGRectMake(0, currY-height, self.frame.size.width, self.frame.size.height);
    } else if (currY == 0 && continuTime <= _stayTime) {
        if (label == _labelOne) {
            _continuTimeOne += 1.0f/60.0f;
        } else {
            _continuTimeTwo += 1.0f/60.0f;
        }
    } else if (currY <= 0 && currY > -self.frame.size.height) {
        [self animationStayEnd:label];
        label.frame = CGRectMake(0, currY-height, self.frame.size.width, self.frame.size.height);
    } else if (currY == -self.frame.size.height) {
        label.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self animationEnd:label];
    }
}

- (void)animationBegin:(UIView *)view
{
    if (view == _labelOne) {
        if (!_timerOneRun) {
            _timerOneRun = YES;
            _timerOne = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0f target:self selector:@selector(updateLabel:) userInfo:view repeats:YES];
            [_timerOne fire];
        }
    } else {
        if (!_timerTwoRun) {
            _timerTwoRun = YES;
            _timerTwo = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0f target:self selector:@selector(updateLabel:) userInfo:view repeats:YES];
            [_timerTwo fire];
        }
    }
}

- (void)animationStayEnd:(UIView *)view
{
    if (view == _labelOne) {
        _continuTimeOne = 0.0f;
        _timerTwoPause = NO;
        [self animationBegin:_labelTwo];
    } else {
        _continuTimeTwo = 0.0f;
        _timerOnePause = NO;
    }
}

- (void)animationEnd:(UIView *)view
{
    if (view == _labelOne) {
        _timerOnePause = YES;
        _currIdx = _lastIdx+1;
        if (_lastIdx >= _messageAry.count-1) {
            _currIdx = 0;
        }
        _labelOne.text = _messageAry[_currIdx];
        
    } else {
        _timerTwoPause = YES;
        _lastIdx = _currIdx+1;
        if (_currIdx >= _messageAry.count-1) {
            _lastIdx = 0;
        }
        _labelTwo.text = _messageAry[_lastIdx];
    }
}

- (void)animationStop
{
    _isAnimating = NO;
    if (_timerOneRun) {
        [_timerOne invalidate];
        _timerOne = nil;
    }
    if (_timerTwoRun) {
        [_timerTwo invalidate];
        _timerTwo = nil;
    }
}

- (void)pause
{
    _pause = YES;
}

- (void)resume
{
    _pause = NO;
}

@end


