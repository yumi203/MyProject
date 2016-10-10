//
//  CrashClass.h
//  PointsMall
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface CrashClass : NSObject

void UncaughtExceptionHandler(NSException *exception);

@end
