//
//  DataWall.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/19/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataWall : NSObject
{
    
}

@property (nonatomic ) int   userPostID;
@property (nonatomic, strong) NSString                  *fullName;
@property (nonatomic, strong) NSString                  *content;
@property (nonatomic, strong) NSMutableArray            *images;
@property (nonatomic, strong) NSString                  *video;
@property (nonatomic, strong) NSString                  *longitude;
@property (nonatomic, strong) NSString                  *latitude;
@property (nonatomic, strong) NSString                  *time;
@property (nonatomic, strong) NSString                  *clientKey;
@property (nonatomic, strong) NSString                  *firstName;
@property (nonatomic, strong) NSString                  *lastName;
@property (nonatomic, strong) NSMutableArray            *comments;
@property (nonatomic, strong) NSMutableArray            *likes;
@end
