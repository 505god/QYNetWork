//
//  QYFileManager.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "QYFileManager.h"

@implementation QYFileManager

+ (NSString *)userDocumentPath {
    NSString* path= [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/QY/"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSError *error;
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error) {
            NSLog(@"%@",[error description]);
        }
    }
    return path;
}

///存
+ (void)saveArrayWithPath:(NSArray*)array fileName:(NSString*)fileName {
    NSString *filePath =[[QYFileManager userDocumentPath] stringByAppendingFormat:@"%@.plist",fileName];
    
    //存文件前 如果存在 先清空数据
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&error];
    }
    
    [NSKeyedArchiver archiveRootObject:array toFile:filePath];
}

///读
+ (NSArray*)readArrayWithFileName:(NSString*)fileName {
    NSString *filePath =[[QYFileManager userDocumentPath] stringByAppendingFormat:@"%@.plist",fileName];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if(arr == nil){
        arr = @[];
    }
    return arr;
}

///删
+ (void)deleteArrayWithFileName:(NSString*)fileName {
    NSString *filePath =[[QYFileManager userDocumentPath] stringByAppendingFormat:@"%@.plist",fileName];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&error];
    }
}

///缓存大小
+(float)folderSizeAtPath {
    @autoreleasepool {
        NSString *path = [QYFileManager userDocumentPath];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        float folderSize = 0.0;
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                folderSize +=[QYFileManager fileSizeAtPath:absolutePath];
            }
            return folderSize;
        }
        return 0;
    }
}

///计算文件缓存
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

///清理缓存
+(void)clearCache {
    @autoreleasepool {
        NSString *path = [QYFileManager userDocumentPath];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles){
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
}
@end
