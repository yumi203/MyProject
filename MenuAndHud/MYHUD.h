//
//  MYHUD.h
//  HudDemo
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HUDPosition) {
    HUDPositionLower    = 0,
    HUDPositionCenter      ,
};

@interface MYHUD : UIView

+ (void)hudWithText:(NSString *)contextStr;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) HUDPosition *type;
@property (nonatomic, assign) NSTimeInterval minShowTime;
@property (nonatomic, strong) UIColor *viewBackGroundColor;
@property (nonatomic, strong) UIColor *labelTextColor;

@end
