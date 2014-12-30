//
//  Friends.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/11/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friends : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * friend_id;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * height_avatar;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * left_avatar;
@property (nonatomic, retain) NSString * nick_name;
@property (nonatomic, retain) NSNumber * scale_avatar;
@property (nonatomic, retain) NSNumber * status_friend;
@property (nonatomic, retain) NSNumber * top_avatar;
@property (nonatomic, retain) NSString * url_avatar;
@property (nonatomic, retain) NSString * url_thumbnail;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * width_avatar;
@property (nonatomic, retain) NSString * phone_number;

@end
