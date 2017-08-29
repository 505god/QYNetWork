//
//  QYNetManager.h
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 请求类型

 - QYRequestType_GET: get
 - QYRequestType_POST: post
 - QYRequestType_PUT: put
 - QYRequestType_DELETE: delete
 - QYRequestType_UPLOAD: 上传
 - QYRequestType_DOWN: 下载
 */
typedef NS_ENUM(NSInteger,QYRequestType) {
    QYRequestType_GET,
    QYRequestType_POST,
    QYRequestType_PUT,
    QYRequestType_DELETE,
    QYRequestType_UPLOAD,
    QYRequestType_DOWN
};

typedef void (^progressBlock)(id responseObject);
typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSString *errorInfo);

@interface QYNetManager : NSObject

///单列模式
+ (instancetype)sharedInstance;

///网络判断
- (BOOL)isReachability;

//基本请求
- (NSInteger)loadDataWithParameters:(NSDictionary *)parameters
                               path:(NSString *)path
                         methodType:(QYRequestType)methodType
                            success:(successBlock)success
                            failure:(failureBlock)failure;

//上传
- (NSInteger)uploadDataWithFileData:(NSData *)filedata
                         fileType:(NSString *)fileType
                         progress:(progressBlock)progress
                          success:(successBlock)success
                          failure:(failureBlock)failure;

//下载
- (NSInteger)downloadWithFilePath:(NSString *)filePath
                        localPath:(NSString *)localPath
                         progress:(progressBlock)progress
                          success:(successBlock)success
                             fail:(failureBlock)failure;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;
@end
