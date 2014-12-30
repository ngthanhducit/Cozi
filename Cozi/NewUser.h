//
//  NewUser.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUser : NSObject

@property (nonatomic, strong) NSString              *nickName;
@property (nonatomic, strong) NSString              *birthDay;
@property (nonatomic, strong) NSString              *birthMonth;
@property (nonatomic, strong) NSString              *birthYear;
@property (nonatomic, strong) NSString              *gender;
@property (nonatomic, strong) NSString              *avatarKey;
@property (nonatomic, strong) NSString              *avatarFullKey;
@property (nonatomic, strong) NSString              *password;
@property (nonatomic, strong) NSString              *deviceToken;
@property (nonatomic, strong) NSString              *longitude;
@property (nonatomic, strong) NSString              *latitude;
@property (nonatomic, strong) NSString              *userName;
@property (nonatomic, strong) NSString              *firstName;
@property (nonatomic, strong) NSString              *lastName;
@property (nonatomic, strong) NSString              *leftAvatar;
@property (nonatomic, strong) NSString              *topAvatar;
@property (nonatomic, strong) NSString              *widthAvatar;
@property (nonatomic, strong) NSString              *heightAvatar;
@property (nonatomic, strong) NSString              *scaleAvatar;
@property (nonatomic, strong) NSMutableArray        *contacts;
@end
