//
//  NSObject+Extension.h
//  HLJSportsLottery
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 俞明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension) <NSCoding>

/**
 *  @brief  异步执行代码块
 *
 *  @param block 代码块
 */
- (void)performAsynchronous:(void(^)(void))block;
/**
 *  @brief  GCD主线程执行代码块
 *
 *  @param block 代码块
 *  @param wait  是否同步请求
 */
- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

/**
 *  @brief  延迟执行代码块
 *
 *  @param seconds 延迟时间 秒
 *  @param block   代码块
 */
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

/**
 *  动态替换方法
 */
+ (void)swizzleMethod:(SEL)originalMethod withMethod:(SEL)newMethod;

/**
 *  动态为某个类添加方法
 */
+ (void)appendMethod:(SEL)newMethod fromClass:(Class)klass;

/**
 *  动态为某个类替换方法
 */
+ (void)replaceMethod:(SEL)method fromClass:(Class)klass;

/**
 Check whether the receiver implements or inherits a specified method up to and exluding a particular class in hierarchy.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)respondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether a superclass implements or inherits a specified method.
 
 @param selector A selector that identifies a method.
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)superRespondsToSelector:(SEL)selector;

/**
 Check whether a superclass implements or inherits a specified method.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether the receiver's instances implement or inherit a specified method up to and exluding a particular class in hierarchy.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
+ (BOOL)instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass;
@end
