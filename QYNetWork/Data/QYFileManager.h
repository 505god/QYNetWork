//
//  QYFileManager.h
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>

///缓存，这里直接用plist，也可用FMDB

@interface QYFileManager : NSObject

///存
+ (void)saveArrayWithPath:(NSArray*)array fileName:(NSString*)fileName;

///读
+ (NSArray*)readArrayWithFileName:(NSString*)fileName;

///删
+ (void)deleteArrayWithFileName:(NSString*)fileName;

///缓存大小
+(float)folderSizeAtPath;

///清理缓存
+(void)clearCache;
@end
