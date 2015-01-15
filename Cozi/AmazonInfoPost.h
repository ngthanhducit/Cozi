//
//  AmazonInfoPost.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/15/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonInfoPost : NSObject
{
    
}

@property (nonatomic, strong) NSString              *key;
@property (nonatomic, strong) NSString              *policy;
@property (nonatomic, strong) NSString              *signature;
@property (nonatomic, strong) NSString              *accessKey;
@property (nonatomic, strong) NSString              *url;

@property (nonatomic, strong) NSString              *keyThumb;
@property (nonatomic, strong) NSString              *policyThumb;
@property (nonatomic, strong) NSString              *signatureThumb;
@property (nonatomic, strong) NSString              *accessKeyThumb;
@property (nonatomic, strong) NSString              *urlThumb;


@property (nonatomic ) int                          userReceiveID;
@property (nonatomic) int                           keyMessage;
@property (nonatomic, strong) NSData                *imgDataSend;
@end
