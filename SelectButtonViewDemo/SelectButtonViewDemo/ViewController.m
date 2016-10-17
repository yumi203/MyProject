//
//  ViewController.m
//  SelectButtonViewDemo
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "SelectBallView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SelectBallView *ball = [[SelectBallView alloc] initWithFrame:CGRectMake(50, 100, 200, 200) numberArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] ballWidth:50 column:3];
    [self.view addSubview:ball];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
