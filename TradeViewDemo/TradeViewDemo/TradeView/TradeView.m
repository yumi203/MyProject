//
//  TradeView.m
//  TextFieldInput
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TradeView.h"
#import "UITextField+YM.h"

#define TradeInputViewNumCount 6

// 屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface TradeView () <UITextFieldDelegate> {
    CGFloat leftPadding;
}

@property (nonatomic, strong) UITextField *textField;
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;

@end

@implementation TradeView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)nums {
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:(CGRect){.size = self.frame.size}];
        [self addSubview:_textField];
        _textField.delegate = self;
        
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, leftPadding, 0)];
        //设置显示模式为永远显示(默认不显示)
        _textField.leftViewMode = UITextFieldViewModeUnlessEditing;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

#pragma mark - 点击删除的方法
- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

#pragma mark - 点击按钮的方法
- (void)passNumber:(NSNumber *)num
{
    if (self.nums.count >= TradeInputViewNumCount) return;
    [self.nums addObject:num];
    if (self.nums.count == TradeInputViewNumCount) {
        if ([self.delegate respondsToSelector:@selector(checkTradeView:password:)]) {
            [self.delegate checkTradeView:self password:self.password];
        }
    }
    [self setNeedsDisplay];
}
#pragma mark - 绘制方法，用来绘制点和边框
- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    [field drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = ScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = self.frame.size.height / 2.f - pointW / 2;
    CGFloat pointX;
    CGFloat padding = (self.frame.size.width - (pointW * TradeInputViewNumCount)) / (TradeInputViewNumCount * 2);
    if (self.nums.count == 0) {
        leftPadding = padding;
        _textField.leftView.frame = CGRectMake(0, 0, leftPadding, 0);
        [self.textField layoutIfNeeded];
    }
    for (int i = 0; i < self.nums.count; i++) {
        pointX = padding + i * (pointW + 2 * padding);
        leftPadding = padding + (i + 1) * (pointW + 2 * padding);
        _textField.leftView.frame = CGRectMake(0, 0, leftPadding, 0);
        [self.textField layoutIfNeeded];
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }   

}


#pragma mark - 用来删除数组中的密码
- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    [self delete];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *number = @"[0-9]{1}";
    NSPredicate *passWordPredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    if ([passWordPredicate1 evaluateWithObject:string] || [string isEqualToString:@""]) {
        if ([string isEqualToString:@""]) {
            [self delete];
        }else {
            [self passNumber:@([string integerValue])];
        }
    }
    return NO;
}

#pragma mark - 获取密码的方法
- (NSString *)password {
    // 包装通知字典
    NSMutableString *pwd = [NSMutableString string];
    for (int i = 0; i < self.nums.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
        [pwd appendString:str];
    }
    return pwd;
}
#pragma mark - 清除数组
- (void)clearNumber {
    self.nums = nil;
    [self setNeedsDisplay];
    [self.textField resignFirstResponder];
}

#pragma mark - 重写成为响应者的方法
- (BOOL)becomeFirstResponder {
    [self.textField becomeFirstResponder];
    return [super becomeFirstResponder];
}


@end

