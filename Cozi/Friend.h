//
//  Friend.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend : NSObject

@property (nonatomic            ) int            friendID;
@property (nonatomic            ) int            userID;
@property (nonatomic, copy)     NSString            *userName;
@property (nonatomic, copy      ) NSString       *nickName;
@property (nonatomic, copy      ) NSString       *firstName;
@property (nonatomic, copy      ) NSString       *lastName;
@property (nonatomic, copy      ) NSString       *gender;
@property (nonatomic, copy      ) NSString       *urlThumbnail;
@property (nonatomic, copy      ) NSString       *urlAvatar;
@property (nonatomic, strong    ) UIImage        *avatar;
@property (nonatomic, strong    ) UIImage        *thumbnail;
@property (nonatomic, strong    ) UIImage        *thumbnailOffline;
@property (nonatomic            ) int            statusFriend;//0: offline - 1: online:
@property (nonatomic)             int            statusAddFriend; //0: ok - 1: request
@property (nonatomic, strong    ) NSMutableArray *friendMessage;
@property (nonatomic, copy      ) NSString       *phoneNumber;
@property (nonatomic, copy)     NSString            *birthDay;
@property (nonatomic, copy)     NSString            *relationship;
@property (nonatomic) int                           isFriendWithYour; //0: is friend - 1: not friend;
@end
