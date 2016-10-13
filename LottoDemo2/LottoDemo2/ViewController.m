//
//  ViewController.m
//  LottoDemo2
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "TextView.h"
#import "LottoView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    double date_s = CFAbsoluteTimeGetCurrent();
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 25; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        while (tempArr.count < 5) {
            NSString *tempStr = [NSString stringWithFormat:@"%d", arc4random() % 33 + 1];
            if (![tempArr containsObject:tempStr]) {
                [tempArr addObject:tempStr];
            }
        }
        NSArray *tempTempArray = [tempArr sortedArrayUsingComparator:cmptr];
        [arr addObject:@{@"periods" : [NSString stringWithFormat:@"1%02ld",i], @"number" : @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"1", @"2", @"3"], @"award":tempTempArray,@"color":@"red"}];
        
    }
    LottoView *lotto = [[LottoView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 448) listArray:arr];
    [self.view addSubview:lotto];
    double date_current = CFAbsoluteTimeGetCurrent() - date_s;
    NSLog(@"Time: %f ms",date_current * 1000);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
