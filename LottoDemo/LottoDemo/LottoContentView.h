//
//  LottoContentView.h
//  LottoDemo
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberPeriodsView;
@interface LottoContentView : UIView


- (instancetype)initWithContentArray:(NSArray<NSArray *> *)listArray;

@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong) NumberPeriodsView *periodsView;

@end

@interface NumberPeriodsView : UIView

- (instancetype)initWithPeriodsArray:(NSArray *)periodsArray;

@end

@interface NumberView : UIView

- (instancetype)initWithNumberArray:(NSArray *)numberArray awardArray:(NSArray *)awardArray color:(NSString *)color;

@end