//
//  BaseViewModel.h
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYFileManager.h"

typedef void(^QYRequestCompletedBlock)(BOOL success,NSString *error,BOOL hasMoreData,BOOL isBlank);

typedef void(^QYCacheCompletedBlock)(BOOL success,NSString *error);

@interface BaseViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

//true = 刷新； false ＝ 加载更多
@property (nonatomic, assign) BOOL refresh;

///分页
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

//网络请求成功回调
@property (nonatomic, copy) QYRequestCompletedBlock requestCompletedBlock;

///读取本地数据请求回调
@property (nonatomic, copy) QYCacheCompletedBlock cacheCompletedBlock;

- (void)loadLastestPage;//刷新
- (void)loadNextPage;//加载下一页
- (void)loadItemsWithPageNum:(NSInteger)pageNum;

//读取本地数据
-(void)getCacheDataWithPath:(NSString*)fileName;
@end
