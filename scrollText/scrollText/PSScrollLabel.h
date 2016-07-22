//
//  PSScrollLabel.h
//  scrollText
//
//  Created by chaiqiwei on 16/7/7.
//  Copyright © 2016年 chaiqiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSScrollLabel : UIView
{
    UILabel *_labelOne;
    UILabel *_labelTwo;
    NSMutableArray *_labelAry;
    NSInteger _currIdx;
    NSInteger _lastIdx;
    
    BOOL _pause;
    
    NSTimer *_timerOne;
    BOOL _timerOneRun;
    BOOL _timerOnePause;
    
    NSTimer *_timerTwo;
    BOOL _timerTwoRun;
    BOOL _timerTwoPause;
    
    CGFloat _continuTimeOne;
    CGFloat _continuTimeTwo;
    CGFloat _stayTime;
}


- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)NSArray<__kindof NSString*> *messageAry;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,assign)CGFloat fontSize;
@property(nonatomic,assign)NSTextAlignment alignment;
@property(nonatomic,assign,readonly)BOOL isAnimating;
@property(nonatomic,copy)void(^tapBlock)(NSString *text, NSInteger idx);

- (void)animationStop;

- (void)pause;

- (void)resume;

@end

