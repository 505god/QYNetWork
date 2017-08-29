//
//  QYNetwork.h
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 回调
 */
typedef void (^CallBackBlock)(NSInteger code,id responseObject);

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;
/**
 网络请求
 */
@interface QYNetwork : NSObject

///单列模式
+ (instancetype)sharedInstance;

///get
- (NSInteger)callGETWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(CallBackBlock)success
                          fail:(CallBackBlock)fail;

///post
- (NSInteger)callPOSTWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
                        success:(CallBackBlock)success
                           fail:(CallBackBlock)fail;

///upload
- (NSInteger)callUPLOADWithFileData:(NSData *)filedata
                           fileType:(NSString *)fileType
                           progress:(CallBackBlock)progress
                            success:(CallBackBlock)success
                               fail:(CallBackBlock)fail;

///download
- (NSInteger)callDOWNLOADWithFilePath:(NSString *)filePath
                            localPath:(NSString *)localPath
                             progress:(CallBackBlock)progress
                              success:(CallBackBlock)success
                                 fail:(CallBackBlock)fail;

//取消task
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
