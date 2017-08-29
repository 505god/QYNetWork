//
//  ViewController.m
//  QYNetWork
//
//  Created by 邱成西 on 2017/8/29.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "ViewController.h"
#import "QYNetManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[QYNetManager sharedInstance] loadDataWithParameters:@{@"method":@"info",@"short_conn":@(0)} path:@"api/v1/vpan" methodType:QYRequestType_POST success:^(id responseObject) {
        
    } failure:^(NSString *errorInfo) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
