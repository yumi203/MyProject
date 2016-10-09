//
//  MYActivityIndicatorView.m
//  sportsm
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import "MYActivityIndicatorView.h"

@interface MYActivityIndicatorView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton *backGroundButton;
@property (nonatomic, strong) UIView *centerView;

@end

@implementation MYActivityIndicatorView
#pragma mark - 初始化方法
+ (instancetype)shareInstance {
    static MYActivityIndicatorView *activityInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activityInstance = [[MYActivityIndicatorView alloc] init];
    });
    return activityInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.hidden = YES;
        self.frame = [UIScreen mainScreen].bounds;
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
    }
    return self;
}

#pragma mark - 懒加载
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.backGroundButton];
    [self addSubview:self.centerView];
    [self addSubview:self.activityView];
}

- (UIButton *)backGroundButton {
    if (_backGroundButton) {
        _backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backGroundButton.frame = self.frame;
    }
    return _backGroundButton;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        _centerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        _centerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _centerView.layer.cornerRadius = 10;
        _centerView.layer.masksToBounds = YES;
        
        [_activityView startAnimating];
        [_activityView stopAnimating];

    }
    return _centerView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _activityView;
}

- (void)startAnimating {
    self.hidden = NO;
    [self.activityView startAnimating];
}

- (void)stopAnimating {
    self.hidden = YES;
    [self.activityView stopAnimating];
}
@end
