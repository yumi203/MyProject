//
//  YMPhotoDetailViewController.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPhotoDetailViewController : UIViewController

@property NSUInteger pageIndex;

+ (YMPhotoDetailViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex;


@end
