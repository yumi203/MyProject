//
//  ViewController.m
//  LottoDemo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "LottoContentView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *boomView;
@property (nonatomic, strong) LottoContentView *lottoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    self.lottoView = [[LottoContentView alloc] initWithContentArray:arr];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = self.lottoView.contentSize;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.lottoView];
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(40, 76, self.lottoView.contentSize.width, 24)];
    [self.view addSubview:self.topView];
    
    
    for (NSInteger i = 0 ; i < 33; i++) {
        //文字的label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1 + i * 24 + 1 * i, 0, 24, 24)];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld", i + 1];
        label.textColor = [UIColor grayColor];
        [self.topView addSubview:label];
        //竖着的分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1 + 24 + i * 24 + 1 * i, 0, 1, 24)];
        [self.topView addSubview:line];
        line.backgroundColor = [UIColor grayColor];
    }
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 76, 40, 24)];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    //竖着的分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(39, 0, 1, 24)];
    [whiteView addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    
    
    self.boomView = [[UIView alloc] initWithFrame:CGRectMake(40, 500, self.lottoView.contentSize.width, 30)];
    [self.view addSubview:self.boomView];
    for (NSInteger i = 0 ; i < 33; i++) {
        //文字的label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1 + i * 24 + 1 * i, 0, 24, 24)];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld", i + 1];
        label.textColor = [UIColor grayColor];
        [self.boomView addSubview:label];
        //竖着的分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1 + 24 + i * 24 + 1 * i, 0, 1, 24)];
        [self.boomView addSubview:line];
        line.backgroundColor = [UIColor grayColor];
    }
    
    UIView *whiteView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 500, 40, 30)];
    [self.view addSubview:whiteView2];
    whiteView2.backgroundColor = [UIColor whiteColor];
    //竖着的分割线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(39, 0, 1, 24)];
    [whiteView2 addSubview:line2];
    line2.backgroundColor = [UIColor grayColor];
    
    double date_current = CFAbsoluteTimeGetCurrent() - date_s;
    NSLog(@"Time: %f ms",date_current * 1000);
    
    
}

//用 bounces 属性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.x <= 0)) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }else if (scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width) {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, scrollView.contentOffset.y);
    }    
    
    self.lottoView.periodsView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
    self.topView.transform = CGAffineTransformMakeTranslation(-scrollView.contentOffset.x, 0);
    self.boomView.transform = CGAffineTransformMakeTranslation(-scrollView.contentOffset.x, 0);
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
