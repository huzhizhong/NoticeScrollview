//
//  ViewController.m
//  scrollText
//
//  Created by chaiqiwei on 16/7/7.
//  Copyright © 2016年 chaiqiwei. All rights reserved.
//

#import "ViewController.h"
#import "PSScrollLabel.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
<AVAudioPlayerDelegate>

{
    PSScrollLabel *scrollLabel;
    AVAudioPlayer *player;
}

@property(nonatomic,strong)NSArray *allMessageAry;
@property(nonatomic,assign)NSInteger idx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"role" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:pathStr];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;
    [player prepareToPlay];
    
    [player play];
    
    
    _allMessageAry = @[@[@"欢迎来到英雄联盟",@"敌军还有30秒到达战场",@"啊,first blood",@"建议您先和电脑控制的英雄进行练习模式的游戏",@"以熟悉操作和战斗模式",@"用鼠标右键 小心（啊 first blood）",@"你很快就会成为传奇人物",@"全军出击"],
                      @[@"德玛西亚 德玛西亚 德玛 德玛 德玛西亚",@"蒙多...... 蒙多......走这边.....走这边...",@"我剑..就是你剑...你剑...就是我剑...",@"那个..你看见过我的小熊吗？？？我剑...",@"我来为你带路...不要害怕...跟我来...",@"再来..我就打你哟。。。",@"呀...打你哟...呀...打你哟...呀...打你哟.",@"呀。。啊~~~啊~~~"],
                      @[@"狡诈恶毒...胜利在望...",@"狡诈恶毒...保家卫国...",@"狡诈恶毒...勇往直前...",@"狡诈恶毒...吾皇万岁...",@"嘿~~~我...正在...打飞机..",@"打的漂亮...",@"我..打飞机...打的漂亮..."],
                      @[@"蓝宝石...红宝石...",@"蓝蓝蓝...红宝石...",@"猫眼石...祖母绿...",@"哇...哇...一碰就碎",@"我没有 但你也没有...我没有 但...畏惧我吧...主人...主人...",@"你也没有...吧...吧...你也没有...穿过暮光的帷幕...哈 哈",@"game over"],];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 400, 300, 30)];
    showLabel.backgroundColor = [UIColor grayColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:16.0f];
    showLabel.textColor = [UIColor brownColor];
    [self.view addSubview:showLabel];
    
    _idx = 0;
    scrollLabel = [[PSScrollLabel alloc]initWithFrame:CGRectMake(10, 200, 300, 30)];
    scrollLabel.backgroundColor = [UIColor grayColor];
    scrollLabel.textColor = [UIColor brownColor];
    scrollLabel.fontSize = 16.0f;
    scrollLabel.alignment = NSTextAlignmentLeft;
    [self.view addSubview:scrollLabel];
    
    __weak ViewController *weak_self = self;
    scrollLabel.tapBlock = ^(NSString *str, NSInteger index) { 
        showLabel.text = str;
        NSLog(@"点中的文字是:%@",weak_self.allMessageAry[weak_self.idx][index]);
    };
    scrollLabel.messageAry = _allMessageAry[_idx];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.tag = 10;
    nextBtn.backgroundColor = [UIColor brownColor];
    [nextBtn setTitle:@"下一条" forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(80, 300, 60, 40);
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *pasueBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pasueBtn.tag = 11;
    pasueBtn.backgroundColor = [UIColor brownColor];
    [pasueBtn setTitle:@"暂停" forState:UIControlStateNormal];
    pasueBtn.frame = CGRectMake(160, 300, 60, 40);
    [self.view addSubview:pasueBtn];
    [pasueBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *resumeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resumeBtn.tag = 12;
    resumeBtn.backgroundColor = [UIColor brownColor];
    [resumeBtn setTitle:@"恢复" forState:UIControlStateNormal];
    resumeBtn.frame = CGRectMake(240, 300, 60, 40);
    [self.view addSubview:resumeBtn];
    [resumeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 10) {
        _idx++;
        if (_idx >= _allMessageAry.count) {
            _idx = 0;
        }
        scrollLabel.messageAry = _allMessageAry[_idx];
    } else if (sender.tag == 11) {
        [scrollLabel pause];
    } else if (sender.tag == 12) {
        [scrollLabel resume];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
