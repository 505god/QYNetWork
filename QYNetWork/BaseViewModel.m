//
//  BaseViewModel.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 0;
        _pageSize = 20;
    }
    return self;
}

//刷新
- (void)loadLastestPage {
    self.pageIndex= 0;
    [self loadItemsWithPageNum:self.pageIndex];
}

//加载下一页
- (void)loadNextPage {
    self.pageIndex ++;
    [self loadItemsWithPageNum:self.pageIndex];
}

- (void)loadItemsWithPageNum:(NSInteger)pageNum {
    
}

//读取本地数据
-(void)getCacheDataWithPath:(NSString*)fileName {
    NSArray *array = [QYFileManager readArrayWithFileName:fileName];
    
    [self.dataArray addObjectsFromArray:array];
    
    if (array.count>0) {
        
        !self.cacheCompletedBlock ?: self.cacheCompletedBlock(true,nil);
    }else {
        !self.cacheCompletedBlock ?: self.cacheCompletedBlock(false,nil);
    }
}

#pragma mark - getter

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
