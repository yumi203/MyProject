//
//  UIView+Extension.h
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 俞明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyTapGestureRecognizerBlock)();

@interface UIView (Extension)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat centerX;

@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;


- (void)removeAllSubViews;


/**
 *  @author 俞明, 16-06-03 10:06:44
 *
 *  可用来重新设置点击事件的方法
 */
@property (nonatomic, copy) MyTapGestureRecognizerBlock __nonnull gestureBlock;
/**
 *  @author 俞明, 16-06-03 10:06:14
 *
 *  给视图添加一个点击事件
 *
 *  @param action 实现点击事件的方法
 */
- (void)addGestureRecognizerAtction:(MyTapGestureRecognizerBlock __nonnull)action;


//View截图
- (UIImage * __nonnull) screenshot;

//ScrollView截图 contentOffset
- (UIImage * __nonnull) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

//View按Rect截图
- (UIImage * __nonnull) screenshotInFrame:(CGRect)frame;

@end
