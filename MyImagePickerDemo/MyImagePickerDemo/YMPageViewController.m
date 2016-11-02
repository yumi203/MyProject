//
//  YMPageViewController.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMPageViewController.h"
#import "YMPhotoDetailViewController.h"
#import "YMPageViewData.h"

@interface YMPageViewController ()

@end

@implementation YMPageViewController

- (instancetype)init {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YMPhotoDetailViewController *startingPage = [YMPhotoDetailViewController photoViewControllerForPageIndex:self.startingIndex];
    if (startingPage != nil)
    {
        self.dataSource = self;
        
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDelegate


- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(YMPhotoDetailViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [YMPhotoDetailViewController photoViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(YMPhotoDetailViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [YMPhotoDetailViewController photoViewControllerForPageIndex:(index + 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
