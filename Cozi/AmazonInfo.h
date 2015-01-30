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

@property (nonatomic, copy  ) NSString *key;
@property (nonatomic, copy  ) NSString *policy;
@property (nonatomic, copy  ) NSString *signature;
@property (nonatomic, copy  ) NSString *accessKey;
@property (nonatomic, copy  ) NSString *url;
@property (nonatomic        ) int      userReceiveID;
@property (nonatomic, copy  ) NSString *keyMessage;
@property (nonatomic, strong) NSData   *imgDataSend;
@end
