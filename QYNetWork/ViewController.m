//
//  ViewController.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerViewModel.h"
#import "MJRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ViewControllerViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeader];
    [self addFooter];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 上拉下拉刷新

- (void)addHeader {
    kWeakSelf(self);
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        kStrongSelf(self);

        self.viewModel.refresh = true;
        [self.viewModel loadLastestPage];
    }];
}

- (void)addFooter {
    kWeakSelf(self);
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        kStrongSelf(self);
        
        [self.viewModel loadNextPage];
    }];
}

#warning tableView代理未实现


#pragma mark - getter

- (ViewControllerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ViewControllerViewModel alloc] init];
        
        __block ViewControllerViewModel *temp_viewModel = _viewModel;
        kWeakSelf(self);
        _viewModel.requestCompletedBlock = ^(BOOL success,NSString *error,BOOL hasMoreData,BOOL isBlank) {
            kStrongSelf(self);
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (success) {
                
                if (!hasMoreData) {//是否有更多数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (isBlank) {
                    //数据为空
                    //TODO:添加缺省页面
                }else {
                    if (temp_viewModel.refresh) {
                        //下拉上拉刷新
                    }else {
                        //上拉刷新
                    }
                }
            }else {
                //TODO:给出错误提示
            }
        };
        
        _viewModel.cacheCompletedBlock = ^(BOOL success,NSString *error) {
            //缓存
        };
        
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
