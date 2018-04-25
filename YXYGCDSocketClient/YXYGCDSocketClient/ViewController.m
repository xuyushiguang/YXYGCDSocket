//
//  ViewController.m
//  YXYGCDSocketClient
//
//  Created by aojinrui on 2018/4/25.
//  Copyright © 2018年 aojinrui. All rights reserved.
//

#import "ViewController.h"
#import "YXYGCDSocket.h"
@interface ViewController ()<YXYGCDSocketDelegate>
{
    YXYGCDSocket *yxyscoket;
}
@end

@implementation ViewController
-(void)connectSuccessWithYXYSocket:(YXYGCDSocket *)socket addrIP:(char *)addrIP port:(NSInteger)port
{
    NSLog(@"ip=%@  port=%ld",[NSString stringWithCString:addrIP encoding:NSUTF8StringEncoding],port);
}
-(void)connectFailedWithYXYSocket:(YXYGCDSocket *)socekt
{
    NSLog(@"连接失败");
}
-(void)receivedDataWithYXYSocket:(YXYGCDSocket *)socekt Data:(char *)data
{
    NSLog(@"receive=%@",[NSString stringWithCString:data encoding:NSUTF8StringEncoding]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(100, 100, 100, 100);
    bt.backgroundColor = [UIColor redColor];
    [bt setTitle:@"" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    
    yxyscoket = [[YXYGCDSocket alloc] init];
    yxyscoket.delegate = self;
    [yxyscoket connectToAddrIP:@"10.22.70.99" port:1024];
    
    
}
-(void)btClick
{
     [yxyscoket sendData:[@"this is client" dataUsingEncoding:NSUTF8StringEncoding]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
