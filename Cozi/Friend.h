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
@property (nonatomic)               int         userID;
@property (nonatomic, strong    ) NSString       *nickName;
@property (nonatomic, strong    ) NSString       *firstName;
@property (nonatomic, strong    ) NSString       *lastName;
@property (nonatomic, strong    ) NSString       *gender;
@property (nonatomic, strong)     NSString       *urlThumbnail;
@property (nonatomic, strong)     NSString       *urlAvatar;
@property (nonatomic, strong    ) UIImage        *avatar;
@property (nonatomic, strong    ) UIImage        *thumbnail;
@property (nonatomic, strong) UIImage            *thumbnailOffline;
@property (nonatomic, strong    ) NSData         *dataAvatar;
@property (nonatomic            ) int            statusFriend;//0: offline - 1: online:
@property (nonatomic            ) CGFloat        leftAvatar;
@property (nonatomic            ) CGFloat        topAvatar;
@property (nonatomic            ) CGFloat        widthAvatar;
@property (nonatomic            ) CGFloat        heightAvatar;
@property (nonatomic            ) CGFloat        scaleAvatar;
@property (nonatomic, strong    ) NSMutableArray *friendMessage;
@property (nonatomic, strong) NSString              *phoneNumber;
@end
