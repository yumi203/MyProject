//
//  NetWorkingHandle.h
//  sportsm
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class NetWorkingModel;

//加密key
static NSString * _Nonnull keyValue = @"521521";
//超时时间
static NSTimeInterval timeOut = 20;
//网络状态
static NetworkStatus status = ReachableViaWiFi;

@interface NetWorkingHandle : NSObject

/**
 *  @author 俞明, 16-07-20 09:07:34
 *
 *  网络请求
 *
 *  @param url            URL
 *  @param parameters     参数，
 *  @param code           是否加密
 *  @param time           超时时间 0为默认值
 *  @param show           是否有网络加载提示框
 *  @param header         请求头
 *  @param responseObject 返回结果
 *  @param errorBlock     返回错误
 */
+ (void)postUrl:(NSString * _Nullable)url
     parameters:(NSDictionary * _Nullable)parem
         encode:(BOOL)code
        timeout:(NSTimeInterval)time
          alert:(BOOL)show
         header:(NSDictionary * _Nullable)headerValue
   successBlock:(void (^ _Nullable)(NetWorkingModel *  _Nullable response))responseBlock
   failureBlock:(void (^ _Nullable)(NSError *  _Nullable error))errorBlock;
/** 默认有加密有提示框的 */
+ (void)postHasAlertWithUrl:(NSString * _Nullable)url
     parameters:(NSDictionary * _Nullable)parem
   successBlock:(void (^ _Nullable)(NetWorkingModel * _Nullable response))responseBlock
   failureBlock:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;
/** 默认加密和无提示框的 */
+ (void)postHidenAlertWithUrl:(NSString * _Nullable)url
     parameters:(NSDictionary * _Nullable)parem
   successBlock:(void (^ _Nullable)(NetWorkingModel * _Nullable response))responseBlock
   failureBlock:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;
/** 默认无加密和有提示框的 */
+ (void)postEnCodeHasAlertWithUrl:(NSString * _Nullable)url
                 parameters:(NSDictionary * _Nullable)parem
               successBlock:(void (^ _Nullable)(NetWorkingModel * _Nullable response))responseBlock
               failureBlock:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;
/** 默认无加密和无提示框的 */
+ (void)postEnCodeHidenAlertWithUrl:(NSString * _Nullable)url
                   parameters:(NSDictionary * _Nullable)parem
                 successBlock:(void (^ _Nullable)(NetWorkingModel * _Nullable response))responseBlock
                 failureBlock:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;
/**
 *  @author 俞明, 16-08-17 13:08:07
 *
 *  下载文件
 *
 *  @param url           URL地址
 *  @param path          存放本地路径
 *  @param responseBlock 成功后调用的方法
 *  @param errorBlock    失败后返回的结果
 */
+ (void)downloadFileWith:(NSString * _Nullable)url
              fileCreate:(NSString * _Nullable)path
            successBlock:(void (^ _Nullable)())responseBlock
            failureBlock:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;

#pragma mark - 把静态变量当做类的属性使用
+ (void)setTimeOut:(NSTimeInterval)time;
+ (void)setKeyValue:(NSString * _Nonnull)key;
+ (void)setStatus:(NetworkStatus)sta;
+ (NSTimeInterval)timeOut;
+ (NSString * _Nonnull)keyValue;
+ (NetworkStatus)status;

#pragma mark - 判断网络请求
+ (void)checkNetWorkStatus;

@end

@interface NetWorkingModel : NSObject

@property (nonatomic, assign) NSInteger  errorCode;
@property (nonatomic, strong) NSString  * _Nullable message;
@property (nonatomic, strong) NSDictionary * _Nullable data;
@property (nonatomic, strong) NSString  * _Nullable JSONString;

@end
