//
//  FTPManager.m
//  UpLoadFTP
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FTPManager.h"
#import "SimpleIni.h"

#define DownLocalPath [NSTemporaryDirectory() stringByAppendingPathComponent:@"config_IOS.ini"]
#define kUpLoadPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"log.xml"]


enum {
    kSendBufferSize = 32768
};

@interface FTPManager ()<NSStreamDelegate>{
    uint8_t _buffer[kSendBufferSize];
    FTPStep UpStep;
    CManager *CMana;
}
//内部变量
@property (nonatomic, strong)   NSOutputStream *  networkStream;
@property (nonatomic, strong)   NSInputStream *   fileStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;
//服务器地址与账号
@property (nonatomic, strong) NSString * ftpServer;
@property (nonatomic, strong) NSString * ftpUserName;
@property (nonatomic, strong) NSString * ftpPassword;
@property (nonatomic, strong) NSString * ftpDirectory;

@end


@implementation FTPManager

#pragma mark - 初始化方法
- (instancetype)initWithServer:(NSString *)server user:(NSString *)user password:(NSString *)password directory:(NSString *)directory {
    if ((self = [super init]))
    {
        if ([server hasPrefix:@"ftp://"]) {
            self.ftpServer = server;
        }else {
            self.ftpServer = [@"ftp://" stringByAppendingFormat:@"%@", server];
        }
        self.ftpUserName = user;
        self.ftpPassword = password;
        self.ftpDirectory = [NSString stringWithFormat:@"%@/iOS", directory];
        CMana = [[CManager alloc] init];
        [self createRemoteDirectory:directory];

    }
    return self;
}

- (uint8_t *)buffer
{
    return self->_buffer;
}
#pragma mark - 读取路径
- (void)createRemoteDirectory:(NSString *)directory {
    NSURL *url = [NSURL URLWithString:self.ftpServer];
    
    NSArray *array = [directory componentsSeparatedByString:@"/"];
    for (int i = 0; i < array.count; i++) {
        NSString *dirStr = array[i];
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) dirStr, true)
                                );
        
        
        self.fileStream = CFBridgingRelease(CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));
        //set credentials
        [self.fileStream setProperty:self.ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
        [self.fileStream setProperty:self.ftpPassword forKey:(id)kCFStreamPropertyFTPPassword];
        _fileStream.delegate = self;
        //        performSelector是运行时系统负责去找函数/方法的
        [self performSelector:@selector(scheduleInCurrentThread:)
                     onThread:[[self class] networkThread]
                   withObject:self.fileStream
                waitUntilDone:YES];
        [self.fileStream open];
        [CMana.tempArray addObject:url];
    }
    
    CMana.iniPath = [NSString stringWithFormat:@"%@/config_IOS.ini", CMana.tempArray[0]];
}




#pragma mark - 创建目录
- (void)createDirWithURL:(NSURL *)url {
    if (!url) {
        return;
    }
    self.networkStream = CFBridgingRelease(CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));
    [self.networkStream setProperty:self.ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:self.ftpPassword forKey:(id)kCFStreamPropertyFTPPassword];
    self.networkStream.delegate = self;
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.networkStream
            waitUntilDone:YES];
    [self.networkStream open];
}
#pragma mark - 上传日志
- (void)handleUpLoadWithFile:(NSString *)file {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.ftpServer, self.ftpDirectory]];//服务器地址
    NSString *filePath = file;//本地地址
    NSString *account = self.ftpUserName;//账号
    NSString *password = self.ftpPassword;//密码
    CFWriteStreamRef ftpStream;//输入流
    NSDate *date  = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *timeStr = [formatter stringFromDate:date];
    
    //添加后缀（文件名称）
    url = CFBridgingRelease((CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [NSString stringWithFormat:@"iOS_%@.xml",timeStr], false)) );
    //读取文件，转化为输入流
    self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    [self.fileStream open];
    
    //为url开启CFFTPStream输出流
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    self.networkStream = (__bridge NSOutputStream *) ftpStream;
    
    
    //设置ftp账号密码
    [self.networkStream setProperty:account forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.networkStream.delegate = self;
    //设置runloop
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.networkStream
            waitUntilDone:YES];
    [self.networkStream open];
    
    //完成释放链接
    CFRelease(ftpStream);
}

#pragma mark - 上传ini
- (void)handleUpLoadIni {
    NSURL *url = [NSURL URLWithString:CMana.iniPath];//上传到的位置
    NSString *filePath = DownLocalPath;//本地地址
    NSString *account = self.ftpUserName;//账号
    NSString *password = self.ftpPassword;//密码
    CFWriteStreamRef ftpStream;//输入流
    //读取文件，转化为输入流
    self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    [self.fileStream open];
    
    //为url开启CFFTPStream输出流
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    self.networkStream = (__bridge NSOutputStream *) ftpStream;
    
    //设置ftp账号密码
    [self.networkStream setProperty:account forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.networkStream.delegate = self;
    //设置runloop
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.networkStream
            waitUntilDone:YES];
    [self.networkStream open];
    
    //完成释放链接
    CFRelease(ftpStream);
}

#pragma mark - 下载ini文件
-(void)downloadIni {
    //设置本地输出的位置
    NSString *path = DownLocalPath;
    //设置到本地的输出流
    self.networkStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    //开启输出流
    [self.networkStream open];
    
    //设置访问的位置
    NSURL * url = [NSURL URLWithString:CMana.iniPath];
    //设置下载的地址
    self.fileStream= CFBridgingRelease(CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));
    [self.fileStream setProperty:self.ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
    [self.fileStream setProperty:self.ftpPassword forKey:(id)kCFStreamPropertyFTPPassword];
    self.fileStream.delegate = self;
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.fileStream
            waitUntilDone:YES];
    [self.fileStream open];
}


#pragma mark 回调方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    //NSStreamEventOpenCompleted       //判断是否成功
    //NSStreamEventHasBytesAvailable   //下载内容
    //NSStreamEventHasSpaceAvailable   //上传内容
    //NSStreamEventErrorOccurred       //内容访问错误
    switch (UpStep) {
        case FTPStepCheckDir:{//判断目录是否存在  第一步
            if (eventCode == NSStreamEventOpenCompleted) {
                //用来记录进行了几次回调
                CMana.dirNum++;
            }else if (eventCode == NSStreamEventErrorOccurred) {
                //添加为创建的目录进入数组
                [CMana.urlArray addObject:CMana.tempArray[CMana.dirNum]];
                //用来记录进行了几次回调
                CMana.dirNum++;
                //用来记录是否需要创建目录
                CMana.flag = NO;
            }
            //当回调全部完成后
            if (CMana.dirNum == CMana.tempArray.count) {
                //关闭全部的流
                [self closeAll];
                //进行判断是否需要创建目录
                if (CMana.flag) {
                    //不需要创建目录        跳转到第三步
                    UpStep = FTPStepCheckHasIni;
                    //进行目录判断
                    [self downloadIni];
                }else { //需要创建目录          跳转到第二步
                    UpStep = FTPStepCreateDir;
                    //清空控制器中的所有标记
                    [CMana clean];
                    //遍历数组调用创建目录的方法
                    for (NSURL *url in CMana.urlArray) {
                        [self createDirWithURL:url];
                    }
                }
            }
        }break;
        case FTPStepCreateDir:{//创建目录
            if (eventCode == NSStreamEventEndEncountered){
                CMana.dirNum++;
                if (CMana.dirNum == CMana.urlArray.count) {
                    //关闭全部的流
                    [self closeAll];
                    //下次进行回调时跳转到第三步
                    UpStep = FTPStepCheckHasIni;
                    //清空控制器中的所有标记
                    [CMana clean];
                    //进行目录判断
                    [self downloadIni];
                }
            }else if (eventCode == NSStreamEventErrorOccurred) {
                [self closeAll];
            }
            
        }break;
        case FTPStepCheckHasIni:{//判断ini文件是否存在
            if (eventCode == NSStreamEventOpenCompleted) {
                UpStep = FTPStepDownIniAndReadIni;
            }else if (eventCode == NSStreamEventErrorOccurred) {
                //关闭流
                [self closeAll];
                //创建ini对象
                CSimpleIniA ini;
                //设置编码
                ini.SetUnicode();
                // 写入
                ini.SetValue("Config", "isopenupload", "1");
                //设置路径
                NSString *path = DownLocalPath;
                //写入本地
                ini.SaveFile([path UTF8String]);
                //设置下次加载流上传日志
                UpStep = FTPStepUpLoadIni;
                [self handleUpLoadIni];
                
            }
        }break;
        case FTPStepUpLoadIni:{//上传ini文件
            if (eventCode == NSStreamEventErrorOccurred) {
                [self closeAll];
            }else if (eventCode == NSStreamEventHasSpaceAvailable) {
                NSLog(@"bufferOffset is %zd",self.bufferOffset);
                NSLog(@"bufferLimit is %zu",self.bufferLimit);
                if (self.bufferOffset == self.bufferLimit) {
                    NSInteger   bytesRead;
                    bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                    
                    if (bytesRead == -1) {
                        //读取文件错误
                        [self closeAll];
                    } else if (bytesRead == 0) {
                        //文件读取完成 上传完成
                        [self closeAll];
                        UpStep = FTPStepUpLoadLog;
                        //从本地路径读取
                        NSString *xmlPath = kUpLoadPath;
                        [self handleUpLoadWithFile:xmlPath];
                    } else {
                        self.bufferOffset = 0;
                        self.bufferLimit  = bytesRead;
                    }
                }
                
                if (self.bufferOffset != self.bufferLimit) {
                    //写入数据
                    NSInteger bytesWritten;//bytesWritten为成功写入的数据
                    bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        [self closeAll];
                    } else {
                        self.bufferOffset += bytesWritten;
                    }
                }
            }
        }break;
        case FTPStepDownIniAndReadIni:{//下载ini文件并且判断内容
            if (eventCode == NSStreamEventHasBytesAvailable) {
                NSInteger       bytesRead;
                uint8_t         buffer[32768];
                bytesRead = [self.fileStream read:buffer maxLength:kSendBufferSize];
                if (bytesRead == -1) {
                    [self closeAll];
                } else if (bytesRead == 0) {
                } else {
                    NSInteger   bytesWritten;
                    NSInteger   bytesWrittenSoFar;
                    bytesWrittenSoFar = 0;
                    do {
                        bytesWritten = [self.networkStream write:&buffer[bytesWrittenSoFar] maxLength:(NSUInteger) (bytesRead - bytesWrittenSoFar)];
                        if (bytesWritten == -1) {
                            [self closeAll];
                            break;
                        } else {
                            bytesWrittenSoFar += bytesWritten;
                        }
                    } while (bytesWrittenSoFar != bytesRead);
                    [self closeAll];
                    
                    //创建ini对象
                    CSimpleIniA ini;
                    //设置编码
                    ini.SetUnicode();
                    //设置路径
                    NSString *path = DownLocalPath;
                    ini.LoadFile([path UTF8String]);
                    // 读取
                    const char * pVal = ini.GetValue("Config", "isopenupload","");
                    int flag = [[NSString stringWithCString:pVal encoding:NSUTF8StringEncoding] intValue];
                    if (flag == 1) {
                        //从本地路径读取
                        NSString *xmlPath = kUpLoadPath;
                        UpStep = FTPStepUpLoadLog;
                        [self handleUpLoadWithFile:xmlPath];
                    }else {
                        NSLog(@"不允许上传");
                    }
                }
            }else {
                //非下载的时候说明流错误了 关闭所有流
                [self closeAll];
            }
        }break;
        case FTPStepUpLoadLog:{//上传log文件
            if (eventCode == NSStreamEventErrorOccurred) {
                [self closeAll];
            }else if (eventCode == NSStreamEventHasSpaceAvailable) {
                NSLog(@"bufferOffset is %zd",self.bufferOffset);
                NSLog(@"bufferLimit is %zu",self.bufferLimit);
                if (self.bufferOffset == self.bufferLimit) {
                    NSInteger   bytesRead;
                    bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                    
                    if (bytesRead == -1) {
                        //读取文件错误
                        [self closeAll];
                    } else if (bytesRead == 0) {
                        //文件读取完成 上传完成
                        [self closeAll];
                        NSLog(@"日志上传完成");
                    } else {
                        self.bufferOffset = 0;
                        self.bufferLimit  = bytesRead;
                    }
                }
                
                if (self.bufferOffset != self.bufferLimit) {
                    //写入数据
                    NSInteger bytesWritten;//bytesWritten为成功写入的数据
                    bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        [self closeAll];
                    } else {
                        self.bufferOffset += bytesWritten;
                    }
                }
            }
        }break;
    }
}

#pragma thread management 线程管理
+ (NSThread *)networkThread {
    static NSThread *networkThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        networkThread =
        [[NSThread alloc] initWithTarget:self
                                selector:@selector(networkThreadMain:)
                                  object:nil];
        [networkThread start];
    });
    
    return networkThread;
}

+ (void)networkThreadMain:(id)unused {
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

// 执行当前线程
- (void)scheduleInCurrentThread:(NSStream*)aStream
{
    [aStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
}




#pragma mark - 关闭所有线程
-(void)closeAll
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.fileStream.delegate = nil;
        [self.fileStream close];
        self.fileStream = nil;
    }
}

@end

@implementation CManager

- (instancetype)init {
    if (self = [super init]) {
        self.dirNum = 0;
        self.flag = YES;
    }
    return self;
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (void)clean {
    self.dirNum = 0;
    self.flag = YES;
}

@end
