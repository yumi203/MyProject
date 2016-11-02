//
//  YMPageViewData.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPageViewData : NSObject

+ (YMPageViewData *)sharedInstance;
- (NSUInteger)photoCount;
- (UIImage *)photoAtIndex:(NSUInteger)index;
@property (nonatomic, strong) NSArray *photoAssets;

@end
