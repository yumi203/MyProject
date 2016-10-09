//
//  UIFont+Extension.m
//  HLJSportsLottery
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 俞明. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

#pragma mark  打印并显示所有字体
+(void)showAllFonts{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}

@end
