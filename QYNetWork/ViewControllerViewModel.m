//
//  ViewControllerViewModel.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/30.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "ViewControllerViewModel.h"
#import "QYNetManager.h"

@implementation ViewControllerViewModel

- (void)loadItemsWithPageNum:(NSInteger)pageNum {
    [super loadItemsWithPageNum:pageNum];
    
    kWeakSelf(self);
    [[QYNetManager sharedInstance] loadDataWithParameters:@{@"method":@"info",@"short_conn":@(0)} path:@"api/v1/vpan" methodType:QYRequestType_POST success:^(id responseObject) {
        kStrongSelf(self);
        
        //TODO:数据的处理
        BOOL hasMoreData = true;//是否数据加载完毕
        
        //data...
        
        if (pageNum == 1) {
            //第一页数据缓存
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                [QYFileManager saveArrayWithPath:self.dataArray fileName:@""];
            });
        }
        
        !self.requestCompletedBlock ?: self.requestCompletedBlock(true,nil,hasMoreData);
    } failure:^(NSString *errorInfo) {
        kStrongSelf(self);
        
        !self.requestCompletedBlock ?: self.requestCompletedBlock(false,errorInfo,false);
    }];
    
}
@end
