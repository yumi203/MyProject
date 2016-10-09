//
//  MYActivityIndicatorView.h
//  sportsm
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYActivityIndicatorView : UIView

+ (instancetype)shareInstance;
- (void)startAnimating;
- (void)stopAnimating;

@end
