//
//  NetworkCommunication.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "Helper.h"

@protocol NetworkCommunicationDelegate <NSObject>

@required
- (void) notifyData:(NSString*)_data;

@optional
- (void) notifyStatus:(int)code;

@end
@interface NetworkCommunication : NSObject <NSStreamDelegate, GCDAsyncSocketDelegate>
{
    GCDAsyncSocket                              *_gcdSocket;
    NSMutableString               *content;
    NSMutableData                   *muData;
}

+ (id)shareInstance;

@property (nonatomic, strong) GCDAsyncSocket                *gcdSocket;
@property (nonatomic, strong) id <NetworkCommunicationDelegate> delegate;
@property (nonatomic      ) Helper                       *helperIns;

- (void) sendData:(NSString*)str;
- (void) connectSocket;
- (void) disconnectSocket;
@end
