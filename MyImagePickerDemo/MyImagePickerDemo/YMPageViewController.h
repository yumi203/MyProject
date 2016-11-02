//
//  YMPageViewController.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPageViewController : UIPageViewController  <UIPageViewControllerDataSource>

@property (nonatomic, assign) NSInteger startingIndex;

@end
