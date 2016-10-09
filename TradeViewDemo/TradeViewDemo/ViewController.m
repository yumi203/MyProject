//
//  ViewController.m
//  TradeViewDemo
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "TradeView.h"

@interface ViewController () <TradeViewDelegate>

@property (weak, nonatomic) IBOutlet TradeView *tradeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //可随时调用password查看当前输入的密码,如输入2位时调用
    //self.tradeView.password
    
    //必须指定代理方法否则不调用协议方法
    self.tradeView.delegate = self;
    
    //可用代码和xib两种方法创建
    
//    TradeView *trade = [[TradeView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 10, 40)];
//    [self.view addSubview:trade];
}
//该方法在密码输入到最大数时调用
- (void)checkTradeView:(TradeView *)tradeView password:(NSString *)password
{
    //多个密码输入框时用协议传出来的tradeView判断
    
    //该方法用于清除密码
    //[tradeView clearNumber];
    
    NSLog(@"password:%@", password);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
