//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITextField+YM.h"
#import <objc/runtime.h>
NSString * const YMTextFieldDidDeleteBackwardNotification = @"textfield.did.delete.notification";
@implementation UITextField (WJ)
+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(ym_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)ym_deleteBackward {
    [self ym_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <YMTextFieldDelegate> delegate  = (id<YMTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YMTextFieldDidDeleteBackwardNotification object:self];
}
@end
