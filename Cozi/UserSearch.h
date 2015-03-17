//
//  UserSearch.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserSearch : NSObject
{
    
}

@property (nonatomic)       int     friendID;
@property (nonatomic      ) int      userID;
@property (nonatomic, copy) NSString    *nickName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *urlAvatar;
@property (nonatomic, copy) NSString *urlAvatarFull;
@property (nonatomic, copy) NSString    *phoneNumber;
@property (nonatomic, copy) NSString        *userName;
@property (nonatomic)       int         isAddFriend;
@property (nonatomic, strong) UIImage   *imgThumbnail;
@end
