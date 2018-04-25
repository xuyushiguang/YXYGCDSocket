//
//  YXYGCDSocket.m
//  iOS-Socket-C-Version-Client
//
//  Created by aojinrui on 2018/4/24.
//  Copyright © 2018年 huangyibiao. All rights reserved.
//

#import "YXYGCDSocket.h"
#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>

@interface YXYGCDSocket()
{
    int clientSocketId;
   
}





@end

@implementation YXYGCDSocket



-(void)connectToAddrIP:(NSString*)addrIP port:(NSInteger)port
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initializeSocketWithAddrIP:addrIP port:port];
    });
    
}

/**
 初始化socket
 */
-(void)initializeSocketWithAddrIP:(NSString*)addrIP port:(NSInteger)port
{
    // 第一步：创建soket; TCP是基于数据流的，因此参数二使用SOCK_STREAM
    int error = -1;
    clientSocketId = socket(AF_INET, SOCK_STREAM, 0);
    BOOL success = (clientSocketId != -1);
    struct sockaddr_in addr;
    // 第二步：绑定端口号
    if (success) {
//        NSLog(@"client socket create success");
        // 初始化
        
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        
        // 指定协议簇为AF_INET，比如TCP/UDP等
        addr.sin_family = AF_INET;
        
        // 监听任何ip地址
        addr.sin_addr.s_addr = INADDR_ANY;
        error = bind(clientSocketId, (const struct sockaddr *)&addr, sizeof(addr));
        success = (error == 0);
        
        if (success) {
            // p2p
            struct sockaddr_in peerAddr;
            memset(&peerAddr, 0, sizeof(peerAddr));
            peerAddr.sin_len = sizeof(peerAddr);
            peerAddr.sin_family = AF_INET;
            peerAddr.sin_port = htons(port);
            
            // 指定服务端的ip地址，测试时，修改成对应自己服务器的ip 19700
            peerAddr.sin_addr.s_addr = inet_addr([addrIP UTF8String]);
            
            socklen_t addrLen;
            addrLen = sizeof(peerAddr);
//            NSLog(@"will be connecting");
            
            // 第三步：连接服务器
            error = connect(clientSocketId, (struct sockaddr *)&peerAddr, addrLen);
            success = (error == 0);
            
            if (success) {
                // 第四步：获取套接字信息
                error = getsockname(clientSocketId, (struct sockaddr *)&addr, &addrLen);
                success = (error == 0);
                
                if (success) {
                    //                NSLog(@"client connect success, local address:%s,port:%d",
                    //                      inet_ntoa(addr.sin_addr),
                    //                      ntohs(addr.sin_port));
                    if ([_delegate respondsToSelector:@selector(connectSuccessWithYXYSocket:addrIP:port:)]) {
                        [_delegate connectSuccessWithYXYSocket:self addrIP:inet_ntoa(addr.sin_addr) port:addr.sin_port];
                    }
                    
                 
                    
                }
            } else {
//                NSLog(@"connect failed");
                
                // 第六步：关闭套接字
                [self closeSocket];
                if([_delegate respondsToSelector:@selector(connectFailedWithYXYSocket:)]) {
                    [_delegate connectFailedWithYXYSocket:self];
                }
                
            }
        }else{
            [self closeSocket];
            if([_delegate respondsToSelector:@selector(connectFailedWithYXYSocket:)]) {
                [_delegate connectFailedWithYXYSocket:self];
            }
        }
    }
}

-(void)sendData:(NSData*)data
{
    
        NSLog(@"8888%@",data);
        send(clientSocketId,[data bytes] ,data.length , 0);
    
    
    //接收数据
    char buf[1024];
    size_t len = sizeof(buf);
   long leng = recv(clientSocketId, buf, len, 0);
    NSLog(@"long=%ld",leng);
    if (strlen(buf) != 0) {
        NSLog(@"received message from client：%@",[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
        
        if ([_delegate respondsToSelector:@selector(receivedDataWithYXYSocket:Data:)]) {
            [_delegate receivedDataWithYXYSocket:self Data:buf];
            
        }
        memset(buf, 0x00, sizeof(buf));
    }
    
}


-(void)closeSocket
{
   
    _delegate = nil;
    close(clientSocketId);
}







@end
