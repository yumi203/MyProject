//
//  SelectBallView.h
//  SelectButtonViewDemo
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBallView : UIView

- (instancetype)initWithFrame:(CGRect)frame numberArray:(NSArray *)numberArray ballWidth:(CGFloat)width column:(NSInteger)column;
//列数
@property (nonatomic, assign) NSInteger column;
//球的宽度
@property (nonatomic, assign) CGFloat ballWidth;
//是否可以点击
@property (nonatomic, assign) BOOL canClick;

@end
