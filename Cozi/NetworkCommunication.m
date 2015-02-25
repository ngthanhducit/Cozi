//
//  NetworkCommunication.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "NetworkCommunication.h"

@implementation NetworkCommunication

@synthesize gcdSocket;

- (id) init{
    self = [super init];
    if (self) {
        [self setupVariable];
        [self setupAsyncSocket];
    }
    
    return self;
}

/**
 *  singleton partten
 *
 *  @return self
 */
+(id)shareInstance{
    static NetworkCommunication   *shareIns = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        shareIns = [[NetworkCommunication alloc] init];
    });
    
    return shareIns;
}

- (void) setupVariable{
    self.helperIns = [Helper shareInstance];
    content = [[NSMutableString alloc] init];
    muData = [[NSMutableData alloc] init];
}

- (void) setupAsyncSocket{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
}

- (void) connectSocket{
    //    [_gcdSocket connectToHost:@"192.168.1.123" onPort:1411 error:nil];
    //    [_gcdSocket connectToHost:@"192.168.1.202" onPort:1411 error:nil];
    NSError *error = nil;
    //    [self.gcdSocket connectToHost:@"202.150.222.220" onPort:1411 withTimeout:30 error:&error];
    [self.gcdSocket connectToHost:@"202.150.222.220" onPort:1411 error:&error];
//        [self.gcdSocket connectToHost:@"192.168.1.117" onPort:1411 error:&error];
    //    [_gcdSocket connectToHost:@"115.79.48.26" onPort:1411 error:nil];

}

- (void) sendData:(NSString *)str{
    
    if (self.gcdSocket.isConnected) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self.gcdSocket writeData:data withTimeout:30 tag:1];
    }else{

        [self connectSocket];
        
    }
    
}

#pragma -mark =================================================
#pragma -mark GCDAsyncSocket Delegate
- (void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:0];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BOOL isEnd = [self.helperIns endOfWith:str withKey:@"<EOF>"];
    if (isEnd) {
        if (content == nil) {
            content = [[NSMutableString alloc] init];
        }
        [content appendString:str];
        //        [muData appendData:data];
        if (self.delegate && [self.delegate respondsToSelector:@selector(notifyData:)]) {
            [self.delegate notifyData:content];
            
            content = nil;

        }
    }else{
        if (content == nil) {
            content = [[NSMutableString alloc] init];
        }
        
        [content appendString:str];

    }
}

- (void) socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"accept socket");
}

- (void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

- (void) socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"error connect");
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"CANNOT CONNECT TO SERVER. PLEASE TRY AGAIN" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(notifyStatus:)]) {
        [self.delegate notifyStatus:-1];
    }
}

- (void) socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self.gcdSocket readDataWithTimeout:-1 tag:0];
    if (self.gcdSocket.isConnected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notifyStatus:)]) {
            [self.delegate notifyStatus:1];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(notifyStatus:)]) {
            [self.delegate notifyStatus:-1];
        }
    }
}

- (void) disconnectSocket{
    //    [_socket disconnect];
    [self.gcdSocket disconnect];
    //    self.gcdSocket.delegate = nil;
    //    self.gcdSocket = nil;
}

@end
