//
//  QYNetwork.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "QYNetwork.h"
#import <AFNetworking/AFNetworking.h>

@interface QYNetwork ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation QYNetwork

///单列模式
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QYNetwork *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QYNetwork alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

///get
- (NSInteger)callGETWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(CallBackBlock)success
                          fail:(CallBackBlock)fail {
    __block NSURLSessionDataTask *dataTask = nil;
    
    kWeakSelf(self);
    dataTask = [self.sessionManager GET:methodName parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        kStrongSelf(self);
        
        ///请求完成---移除
        [self.dispatchTable removeObjectForKey:@([dataTask taskIdentifier])];
        
        [self processingResponseObject:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kStrongSelf(self);
        
        [self.dispatchTable removeObjectForKey:@([dataTask taskIdentifier])];
        
        [self processingError:error fail:fail];
    }];
    
    self.dispatchTable[@([dataTask taskIdentifier])] = dataTask;
    return dataTask.taskIdentifier;
}

///post
- (NSInteger)callPOSTWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
                        success:(CallBackBlock)success
                           fail:(CallBackBlock)fail {
    __block NSURLSessionDataTask *dataTask = nil;
    
    kWeakSelf(self);
    dataTask = [self.sessionManager POST:methodName parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        kStrongSelf(self);
        [self.dispatchTable removeObjectForKey:@([dataTask taskIdentifier])];
        
        [self processingResponseObject:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kStrongSelf(self);
        [self.dispatchTable removeObjectForKey:@([dataTask taskIdentifier])];
        
        [self processingError:error fail:fail];
    }];
    
    self.dispatchTable[@([dataTask taskIdentifier])] = dataTask;
    return dataTask.taskIdentifier;
}

///upload
- (NSInteger)callUPLOADWithFileData:(NSData *)filedata
                           fileType:(NSString *)fileType
                           progress:(CallBackBlock)progress
                            success:(CallBackBlock)success
                               fail:(CallBackBlock)fail {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    
    kWeakSelf(self);
    uploadTask = [self.sessionManager uploadTaskWithRequest:request fromData:filedata progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progressValue = (CGFloat)uploadProgress.completedUnitCount/(CGFloat)uploadProgress.totalUnitCount;
        !progress ?: progress(0,@(progressValue));
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        kStrongSelf(self);
        [self.dispatchTable removeObjectForKey:@([uploadTask taskIdentifier])];
        
        if (error) {
            [self processingError:error fail:fail];
        } else {
            [self processingResponseObject:responseObject success:success fail:fail];
        }
    }];
    
    self.dispatchTable[@([uploadTask taskIdentifier])] = uploadTask;
    
    return uploadTask.taskIdentifier;
}

///download
- (NSInteger)callDOWNLOADWithFilePath:(NSString *)filePath
                            localPath:(NSString *)localPath
                             progress:(CallBackBlock)progress
                              success:(CallBackBlock)success
                                 fail:(CallBackBlock)fail {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    
    __block NSURLSessionDownloadTask *downTask = nil;
    
    kWeakSelf(self);
    downTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progressValue = (CGFloat)downloadProgress.completedUnitCount/(CGFloat)downloadProgress.totalUnitCount;
        !progress ?: progress(0,@(progressValue));
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        kStrongSelf(self);
        [self.dispatchTable removeObjectForKey:@([downTask taskIdentifier])];
        
        if (error) {
            [self processingError:error fail:fail];
        } else {
            [self processingResponseObject:response success:success fail:fail];
        }
    }];
    
    self.dispatchTable[@([downTask taskIdentifier])] = downTask;
    return downTask.taskIdentifier;
}

///对API返回的数据进行初始判断
- (void)processingResponseObject:(id)responseObject
                         success:(CallBackBlock)success
                            fail:(CallBackBlock)fail {
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
    
    //TODO:解析code，返回具体数据，具体业务具体处理
    NSInteger code = [json[@"code"] integerValue];
    if (code == 200) {
        !success ?: success(code, json);
    }else {
        !fail ?: fail(code,json[@"message"]);
    }
}

///处理错误事件
- (void)processingError:(NSError *)error
                   fail:(CallBackBlock)fail {
    //TODO:提示
    if (error.code == NSURLErrorTimedOut) {
        //超时
        !fail ?: fail(error.code,@"超时");
    }else if (error.code == NSURLErrorCancelled){
        //取消

    }else if (error.code == NSURLErrorNetworkConnectionLost){
        //网络
        !fail ?: fail(error.code,@"无网络");
    }
    //...
}

//根据tast的taskIdentifier取消task
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}


#pragma mark - get

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.7.1:80"]];
        [_sessionManager.requestSerializer setTimeoutInterval:30];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
