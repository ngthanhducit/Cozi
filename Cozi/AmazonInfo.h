//
//  AmazonInfo.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonInfo : NSObject
{
    
}

@property (nonatomic, strong) NSString              *key;
@property (nonatomic, strong) NSString              *policy;
@property (nonatomic, strong) NSString              *signature;
@property (nonatomic, strong) NSString              *accessKey;
@property (nonatomic, strong) NSString              *url;
@property (nonatomic ) int                          userReceiveID;
@property (nonatomic) int                           keyMessage;
@property (nonatomic, strong) NSData                *imgDataSend;
@end
