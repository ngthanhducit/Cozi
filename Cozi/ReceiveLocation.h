//
//  ReceiveLocation.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/2/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveLocation : NSObject
{
    
}

@property (nonatomic, strong) NSURLRequest              *request;
@property (nonatomic) NSInteger                 keySendMessage;
@property (nonatomic, strong) NSString          *longitude;
@property (nonatomic, strong) NSString          *latitude;
@property (nonatomic) int                       senderID;
@property (nonatomic) int                       friendID;
@end
