//
//  YMPhotoDetailViewController.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMPhotoDetailViewController.h"
#import "YMPageViewData.h"
#import "YMImageScroll.h"

@interface YMPhotoDetailViewController ()

@end

@implementation YMPhotoDetailViewController

+ (YMPhotoDetailViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex < [[YMPageViewData sharedInstance] photoCount])
    {
        return [[self alloc] initWithPageIndex:pageIndex];
    }
    return nil;
}

- (id)initWithPageIndex:(NSInteger)pageIndex
{
    self = [super init];
    if (self != nil)
    {
        _pageIndex = pageIndex;
    }
    return self;
}

- (void)loadView
{
    YMImageScroll *scrollView = [[YMImageScroll alloc] init];
    scrollView.index = _pageIndex;
    self.view = scrollView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.navigationItem.title =
    [NSString stringWithFormat:@"%@ of %@", [@(self.pageIndex+1) stringValue], [@([[YMPageViewData sharedInstance] photoCount]) stringValue]];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
