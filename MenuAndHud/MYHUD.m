//
//  MYHUD.m
//  HudDemo
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "MYHUD.h"

@interface MYHUD ()

@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *constString;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MYHUD

@synthesize minShowTime = _minShowTime;

#define kLabelMargin 30
#define kCornerRadius 10

+ (void)hudWithText:(NSString *)contextStr {
    MYHUD *hud = [self shareInstance];
    hud.constString = contextStr;
}

+ (instancetype)shareInstance {
    static MYHUD *HUDInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HUDInstance = [[MYHUD alloc] init];
    });
    return HUDInstance;
}



- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - 懒加载
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.textView];
    [self addSubview:self.textLabel];
}

- (void)setConstString:(NSString *)constString {
    _constString = constString;
    self.textLabel.text = constString;
    CGSize strSize = [constString boundingRectWithSize:CGSizeMake(self.frame.size.width - 130, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    if (self.type == HUDPositionLower) {
        self.textLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - strSize.width) / 2, [UIScreen mainScreen].bounds.size.height - 100 - strSize.height - kLabelMargin / 2, strSize.width, strSize.height);
        self.textView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - strSize.width - kLabelMargin) / 2, [UIScreen mainScreen].bounds.size.height - 100 - strSize.height - kLabelMargin, strSize.width + kLabelMargin, strSize.height + kLabelMargin);
    }else {
        self.textLabel.frame = CGRectMake(0, 0, strSize.width, strSize.height);
        self.textView.frame = CGRectMake(0, 0, strSize.width + kLabelMargin, strSize.height + kLabelMargin);
        _textLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        _textView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    }
    self.alpha = 0;
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.minShowTime * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}


- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc] init];
        _textView.backgroundColor = self.viewBackGroundColor;
        _textView.layer.cornerRadius = kCornerRadius;
    }
    return _textView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = self.labelTextColor;
        _textLabel.font = self.font;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont boldSystemFontOfSize:16];
    }
    return _font;
}

- (UIColor *)viewBackGroundColor {
    if (!_viewBackGroundColor) {
        _viewBackGroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _viewBackGroundColor;
}

- (UIColor *)labelTextColor {
    if (!_labelTextColor) {
        _labelTextColor = [UIColor whiteColor];
    }
    return _labelTextColor;
}

- (void)setMinShowTime:(NSTimeInterval)minShowTime {
    if (minShowTime > 1) {
        _minShowTime = minShowTime;
    }
}
- (NSTimeInterval)minShowTime {
    if (!_minShowTime) {
        _minShowTime = 2;
    }
    return _minShowTime;
}

@end
