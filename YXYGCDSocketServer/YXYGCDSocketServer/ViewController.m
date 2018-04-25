//
//  ViewController.m
//  YXYGCDSocketServer
//
//  Created by aojinrui on 2018/4/25.
//  Copyright © 2018年 aojinrui. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

//端口号
#define ServerPort 1024

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self tcpServer];
    
    
}
- (void)tcpServer {
    // 第一步：创建socket
    int error = -1;
    
    // 创建socket套接字
    int serverSocketId = socket(AF_INET, SOCK_STREAM, 0);
    // 判断创建socket是否成功
    BOOL success = (serverSocketId != -1);
    
    // 第二步：绑定端口号
    if (success) {
        NSLog(@"server socket create success");
        // Socket address
        struct sockaddr_in addr;
        
        // 初始化全置为0
        memset(&addr, 0, sizeof(addr));
        
        // 指定socket地址长度
        addr.sin_len = sizeof(addr);
        
        // 指定网络协议，比如这里使用的是TCP/UDP则指定为AF_INET
        addr.sin_family = AF_INET;
        
        // 指定端口号
        addr.sin_port = htons(ServerPort);
        
        // 指定监听的ip，指定为INADDR_ANY时，表示监听所有的ip
        addr.sin_addr.s_addr = INADDR_ANY;
        
        // 绑定套接字
        error = bind(serverSocketId, (const struct sockaddr *)&addr, sizeof(addr));
        success = (error == 0);
    }
    
    // 第三步：监听
    if (success) {
        NSLog(@"bind server socket success");
        error = listen(serverSocketId, 5);
        success = (error == 0);
    }
    
    if (success) {
        NSLog(@"listen server socket success");
        
        while (true) {
            // p2p
            struct sockaddr_in peerAddr;
            int peerSocketId;
            socklen_t addrLen = sizeof(peerAddr);
            
            // 第四步：等待客户端连接
            peerSocketId = accept(serverSocketId, (struct sockaddr *)&peerAddr, &addrLen);
            success = (peerSocketId != -1);
            
            if (success) {
                NSLog(@"accept server socket success,remote address:%s,port:%d",
                      inet_ntoa(peerAddr.sin_addr),
                      ntohs(peerAddr.sin_port));
                
                char buf[1024];
                size_t len = sizeof(buf);
                
                // 第五步：接收来自客户端的信息
                do {
                    // 接收来自客户端的信息
                    recv(peerSocketId, buf, len, 0);
                    if (strlen(buf) != 0) {
                        NSLog(@"received message from client：%@",[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
                        
                        memset(buf, 0x00, sizeof(buf));
                        //收到消息后给客户端一个应答
                        NSString *str = @"this is server";
                        const char *cha = [str UTF8String];
                        send(peerSocketId, cha, strlen(cha), 0);
                        
                    }
                } while (strcmp(buf, "out") != 0);
                
                NSLog(@"收到exit信号，本次socket通信完毕");
                
                // 第六步：关闭socket
                close(peerSocketId);
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
