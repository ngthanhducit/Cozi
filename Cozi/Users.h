//
//  Users.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/11/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friends;

@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * access_key;
@property (nonatomic, retain) NSString * birth_day;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * height_avatar;
@property (nonatomic, retain) NSNumber * key_send_messenger;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * left_avatar;
@property (nonatomic, retain) NSString * nick_name;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSNumber * scale_avatar;
@property (nonatomic, retain) NSString * time_server;
@property (nonatomic, retain) NSNumber * top_avatar;
@property (nonatomic, retain) NSString * url_avatar;
@property (nonatomic, retain) NSString * url_thumbnail;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * user_status;
@property (nonatomic, retain) NSNumber * width_avatar;
@property (nonatomic, retain) NSSet *relationship;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Friends *)value;
- (void)removeRelationshipObject:(Friends *)value;
- (void)addRelationship:(NSSet *)values;
- (void)removeRelationship:(NSSet *)values;

@end
