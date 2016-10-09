//
//  NetWorkingHandle.m
//  sportsm
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 俞明. All rights reserved.
//

#import "NetWorkingHandle.h"
#import "DES3Util.h"
#import "MYActivityIndicatorView.h"


typedef void (^responseBlock)(NSDictionary *);
typedef void (^errorBlock)(NSError *);

@implementation NetWorkingHandle
#pragma mark - 网络请求方法
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
   successBlock:(void (^)(NetWorkingModel *))responseBlock
   failureBlock:(void (^)(NSError *))errorBlock {
    //没有网不请求网络
    if(status == NotReachable) {
        NSLog(@"没有网");
        return;
    }
    /** url转码防止有汉字 */
    NSString *tempStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    /** 创建url*/
    NSURL *useUrl = [NSURL URLWithString:tempStr];
    /** 创建可变请求 */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:useUrl];
    if (request.timeoutInterval != 0) {
        request.timeoutInterval = time;
    }else {
        request.timeoutInterval = timeOut;
    }
    //设置请求头
    NSDictionary * valueDic = nil;
    if (headerValue == nil) {
        valueDic = @{@"Content-Type" : @"application/json",
                     @"Accept-Language" : @"zh-Hans-US;q=1,en-US;q=0.9",
                     @"encoding" : @"utf-8"};
    }else {
        valueDic = headerValue;
    }
    for (NSString *key in valueDic) {
        [request addValue:[valueDic objectForKey:key] forHTTPHeaderField:key];
    }
    //设置请求方式
    request.HTTPMethod = @"POST";
    NSString *bodyStr = @"";
    if (parem) {
        bodyStr = [self dictionaryToJson:parem];
    }
    //设置是否加密
    if (code) {
        NSString *desStr =[DES3Util encryptUseDES:bodyStr key:keyValue];
        request.HTTPBody = [desStr dataUsingEncoding:NSUTF8StringEncoding];
    }else {
        request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    //设置是否有网络等待动画
    if (show) {
        [[MYActivityIndicatorView shareInstance] startAnimating];
    }
    
    /** 创建连接通道 */
    NSURLSession *session = [NSURLSession sharedSession];
    /** 创建任务 */
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //移除提示框
            [[MYActivityIndicatorView shareInstance] stopAnimating];
        });
        
        NSError *alertError = nil;
        //网络错误
        if (error) {
            alertError = [NSError errorWithDomain:@"网络错误" code:0 userInfo:error.userInfo];
            if (error.code == NSURLErrorNotConnectedToInternet) {
                status = NotReachable;
            }
            errorBlock(alertError);
            return;
        }
        //数据为空
        if (!data) {
            alertError = [NSError errorWithDomain:@"数据为空" code:1 userInfo:nil];
            errorBlock(alertError);
            return;
        }
        //获取JSON字符串
        NSString *JSONString = nil;
        //判断数据是否需要解密
        NSData *tempData = nil;
        if (code) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *str2 = [DES3Util decryptUseDES:str key:keyValue];
            tempData = [str2 dataUsingEncoding:NSUTF8StringEncoding];
            JSONString = str2;
        }else {
            tempData = data;
            JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        NSError *errorJSON = nil;
        //数据解析
        id result = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:&errorJSON];
        //数据解析错误
        if (errorJSON) {
            alertError = [NSError errorWithDomain:@"数据解析错误" code:2 userInfo:errorJSON.userInfo];
            errorBlock(alertError);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NetWorkingModel *model = [[NetWorkingModel alloc] init];
            [model setValuesForKeysWithDictionary:result];
            model.JSONString = JSONString;
            //返回数据解析
            responseBlock(model);
        });
    }];
    /** 开始任务 */
    [task resume];
    
}



#pragma mark * 有加密和提示框
+ (void)postHasAlertWithUrl:(NSString * _Nullable)url parameters:(NSDictionary *)parem successBlock:(void (^)(NetWorkingModel *))responseBlock failureBlock:(void (^)(NSError *))errorBlock {
    [self postUrl:url parameters:parem encode:YES timeout:0 alert:YES header:nil successBlock:responseBlock failureBlock:errorBlock];
}
#pragma mark * 有加密无提示框
+ (void)postHidenAlertWithUrl:(NSString * _Nullable)url parameters:(NSDictionary *)parem successBlock:(void (^)(NetWorkingModel *))responseBlock failureBlock:(void (^)(NSError *))errorBlock {
    [self postUrl:url parameters:parem encode:YES timeout:0 alert:NO header:nil successBlock:responseBlock failureBlock:errorBlock];
}
#pragma mark * 无加密有提示框
+ (void)postEnCodeHasAlertWithUrl:(NSString * _Nullable)url parameters:(NSDictionary *)parem successBlock:(void (^)(NetWorkingModel *))responseBlock failureBlock:(void (^)(NSError *))errorBlock {
    [self postUrl:url parameters:parem encode:NO timeout:0 alert:YES header:nil successBlock:responseBlock failureBlock:errorBlock];
}
#pragma mark * 无加密无提示框
+ (void)postEnCodeHidenAlertWithUrl:(NSString * _Nullable)url parameters:(NSDictionary *)parem successBlock:(void (^)(NetWorkingModel *))responseBlock failureBlock:(void (^)(NSError *))errorBlock {
    [self postUrl:url parameters:parem encode:NO timeout:0 alert:NO header:nil successBlock:responseBlock failureBlock:errorBlock];
}


#pragma mark - 字符串和字典的处理
#pragma mark * 字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingMutableContainers
                         error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark * 字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark - 类的属性
+ (void)setTimeOut:(NSTimeInterval)time {
    timeOut = time;
}

+ (void)setKeyValue:(NSString * _Nonnull)key {
    keyValue = key;
}

+ (void)setStatus:(NetworkStatus)sta {
    status = sta;
}

+ (NSTimeInterval)timeOut {
    return timeOut;
}

+ (NSString *)keyValue {
    return keyValue;
}

+ (NetworkStatus)status {
    return status;
}

#pragma mark - 判断网络状态

+ (void)checkNetWorkStatus {
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(chenckStatus:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
}

+ (void)chenckStatus:(NSNotification *)note {
    
    status = [((Reachability *)note.object) currentReachabilityStatus];
    switch (status) {
        case NotReachable:{
            NSLog(@"没有网--------------");
        }break;
        case ReachableViaWWAN:{
            NSLog(@"手机网络");
        }break;
        case ReachableViaWiFi:{
            NSLog(@"WIFI");
        }break;
    }
}


#pragma mark - 下载文件
+ (void)downloadFileWith:(NSString *)url
              fileCreate:(NSString *)path
            successBlock:(void (^)())responseBlock
            failureBlock:(void (^)(NSError *))errorBlock {
    /** url转码防止有汉字 */
    NSString *tempStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    /** 创建url*/
    NSURL *useUrl = [NSURL URLWithString:tempStr];
    /** 创建可变请求 */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:useUrl];
    //设置请求头
    NSDictionary * valueDic = @{@"Content-Type" : @"application/json",
                                @"Accept-Language" : @"zh-Hans-US;q=1,en-US;q=0.9",
                                @"encoding" : @"utf-8"};
    
    for (NSString *key in valueDic) {
        [request addValue:[valueDic objectForKey:key] forHTTPHeaderField:key];
    }
    //设置请求方式
    request.HTTPMethod = @"GET";
    /** 创建连接通道 */
    NSURLSession *session = [NSURLSession sharedSession];
    /** 创建任务 */
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                errorBlock(error);
            }else {
                NSData *data = [NSData dataWithContentsOfURL:location];
                [data writeToFile:path atomically:NO];
                responseBlock();
            }
        });
    }];
    /** 开始任务 */
    [downTask resume];
}


@end

@implementation NetWorkingModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"error_code"]) {
        _errorCode = [value integerValue];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nerrorCode:%ld\nmessage:%@\ndata:%@\n",self.errorCode , self.message, self.data];
}

@end
