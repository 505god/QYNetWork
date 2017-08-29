//
//  QYNetManager.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "QYNetManager.h"
#import "RealReachability.h"
#import "QYNetwork.h"

#define QYCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
REQUEST_ID = [[QYNetwork sharedInstance] call##REQUEST_METHOD##WithParams:parameters methodName:path success:^(NSInteger code,id responseObject) {                                                          \
success(responseObject);\
} fail:^(NSInteger code,id responseObject) {                                                                                 \
failure(responseObject);\
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}


#define QYUPLOADAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
REQUEST_ID = [[QYNetwork sharedInstance] call##REQUEST_METHOD##WithFileData:filedata fileType:fileType progress:^(NSInteger code,id responseObject) {                                                          \
progress(responseObject);\
}success:^(NSInteger code,id responseObject) {                                                          \
success(responseObject);\
} fail:^(NSInteger code,id responseObject) {                                                                                 \
failure(responseObject);\
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}


#define QYDOWNLOADAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
REQUEST_ID = [[QYNetwork sharedInstance] call##REQUEST_METHOD##WithFilePath:filePath localPath:localPath progress:^(NSInteger code,id responseObject) {                                                          \
progress(responseObject);\
}success:^(NSInteger code,id responseObject) {                                                          \
success(responseObject);\
} fail:^(NSInteger code,id responseObject) {                                                                                 \
failure(responseObject);\
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

@interface QYNetManager ()

@property (nonatomic, assign) ReachabilityStatus wifiStatus;

@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation QYNetManager

///单列模式
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QYNetManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QYNetManager alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    
    if (self) {
        ///网络监听
        [GLobalRealReachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 网络

///实时监听网络状态变化
- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    
    self.wifiStatus = status;
}

///网络判断
- (BOOL)isReachability {
    BOOL isReachable = false;
    
    //获取网络状态
    ReachabilityStatus status = self.wifiStatus;
    
    if (status == RealStatusNotReachable) {
        isReachable = false;
    }else if (status == RealStatusViaWiFi) {
        isReachable = true;
    }else if (status == RealStatusViaWWAN) {
        isReachable = true;
    }
    
    return isReachable;
}

#pragma mark - 请求

- (NSInteger)loadDataWithParameters:(NSDictionary *)parameters
                               path:(NSString *)path
                         methodType:(QYRequestType)methodType
                            success:(successBlock)success
                            failure:(failureBlock)failure {
    NSInteger requestId = 0;
    
    if ([self isReachability]) {//网络状态
        switch (methodType) {
            case QYRequestType_GET:
                QYCallAPI(GET,requestId);
                break;
                
            case QYRequestType_POST:
                QYCallAPI(POST,requestId);
                break;
                
            default:
                break;
        }
    }
    
    return requestId;
}

//上传
- (NSInteger)uploadDataWithFileData:(NSData *)filedata
                         fileType:(NSString *)fileType
                         progress:(progressBlock)progress
                          success:(successBlock)success
                          failure:(failureBlock)failure {
    NSInteger requestId = 0;
    
    if ([self isReachability]) { //网络状态
        
        QYUPLOADAPI(UPLOAD,requestId)
    }
    
    return requestId;
}

//下载
- (NSInteger)downloadWithFilePath:(NSString *)filePath
                        localPath:(NSString *)localPath
                         progress:(progressBlock)progress
                          success:(successBlock)success
                             fail:(failureBlock)failure {
    NSInteger requestId = 0;
    
    if ([self isReachability]) { //网络状态
        
        QYDOWNLOADAPI(DOWNLOAD,requestId)
    }
    
    return requestId;
}

#pragma mark - cancel请求

- (void)cancelAllRequests {
    [[QYNetwork sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    [self.requestIdList removeObjectsInArray:requestIDList];
    [[QYNetwork sharedInstance] cancelRequestWithRequestIDList:requestIDList];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIdWithRequestID:requestID];
    [[QYNetwork sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - getter

- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}
@end
