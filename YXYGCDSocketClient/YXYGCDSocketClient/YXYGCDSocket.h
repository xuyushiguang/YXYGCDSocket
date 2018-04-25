//
//  YXYGCDSocket.h
//  iOS-Socket-C-Version-Client
//
//  Created by aojinrui on 2018/4/24.
//  Copyright © 2018年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXYGCDSocket;

@protocol YXYGCDSocketDelegate <NSObject>
@optional
-(void)connectSuccessWithYXYSocket:(YXYGCDSocket*)socket addrIP:(char*)addrIP port:(NSInteger)port;
-(void)receivedDataWithYXYSocket:(YXYGCDSocket*)socekt Data:(char*)data;
-(void)connectFailedWithYXYSocket:(YXYGCDSocket*)socekt;

@end


@interface YXYGCDSocket : NSObject


@property(nonatomic,assign)id<YXYGCDSocketDelegate> delegate;

-(void)connectToAddrIP:(NSString*)addrIP port:(NSInteger)port;
-(void)sendData:(NSData*)data;

@end
