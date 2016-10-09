//
//  RAMDetect.h
//  sportsm
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAMDetect : NSObject

+ (void)descriptionLog:(NSString *)str;
// 获取当前设备可用内存(单位：MB）
+ (double)availableMemory;
// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory;

@end
