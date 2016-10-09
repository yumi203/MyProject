//
//  TradeView.h
//  TextFieldInput
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TradeView;

@protocol TradeViewDelegate <NSObject>

- (void)checkTradeView:(TradeView *)tradeView password:(NSString *)password;

@end


@interface TradeView : UIView

@property (nonatomic, strong) NSString *password;

@property (nonatomic, assign) id <TradeViewDelegate> delegate;

- (void)clearNumber;

@end