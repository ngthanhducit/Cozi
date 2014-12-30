//
//  Messengers.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/11/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messengers : NSManagedObject

@property (nonatomic, retain) NSString * amazon_key;
@property (nonatomic, retain) NSNumber * friend_id;
@property (nonatomic, retain) NSNumber * key_send_message;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * sender_id;
@property (nonatomic, retain) NSNumber * status_messenger;
@property (nonatomic, retain) NSString * str_messenger;
@property (nonatomic, retain) NSString * strImage;
@property (nonatomic, retain) NSString * time_messenger;
@property (nonatomic, retain) NSString * time_server;
@property (nonatomic, retain) NSNumber * type_messenger;
@property (nonatomic, retain) NSString * url_image;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * timeout_messenger;
@property (nonatomic, retain) NSNumber * is_timeout;

@end
