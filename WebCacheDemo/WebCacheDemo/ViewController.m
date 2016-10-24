//
//  ViewController.m
//  WebCacheDemo
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "YMWebCacheProtocol.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YMWebCacheProtocol start];
    NSArray *arr = @[@"http://www.baidu.com", @"http://www.163.com", @"http://www.tianya.cn", @"http://www.youku.com", @"http://v.baidu.com"];
    for (int i = 0; i < 5; i++) {
        NSString *str = arr[i];
        
        UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        
        button.frame = CGRectMake(10, 100 * (i + 1), 300, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

-(void)click:(UIButton *)button
{
    WebViewController *web = [[WebViewController alloc] init];
    web.url = button.titleLabel.text;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
