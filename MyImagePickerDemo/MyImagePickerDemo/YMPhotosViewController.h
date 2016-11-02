//
//  YMPhotosViewController.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/1.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;
@class YMPhotosViewController;

@protocol YMPhotosViewControllerDelegate <NSObject>

- (void)ymPhotosViewController:(YMPhotosViewController *)photoViewController
            didCommitWithArray:(NSArray <UIImage *>*)imageArray;
@end


@interface YMPhotosViewController : UIViewController

@property (nonatomic, assign) BOOL fromRootFlag;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, assign) NSInteger maxSelect;

@property (nonatomic, assign) id <YMPhotosViewControllerDelegate> delegate;

@end
