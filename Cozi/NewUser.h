//
//  NewUser.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUser : NSObject

@property (nonatomic, copy  ) NSString       *nickName;
@property (nonatomic, copy  ) NSString       *birthDay;
@property (nonatomic, copy  ) NSString       *birthMonth;
@property (nonatomic, copy  ) NSString       *birthYear;
@property (nonatomic, copy  ) NSString       *gender;
@property (nonatomic, copy  ) NSString       *avatarKey;
@property (nonatomic, copy  ) NSString       *avatarFullKey;
@property (nonatomic, copy  ) NSString       *password;
@property (nonatomic, copy  ) NSString       *deviceToken;
@property (nonatomic, copy  ) NSString       *longitude;
@property (nonatomic, copy  ) NSString       *latitude;
@property (nonatomic, copy  ) NSString       *userName;
@property (nonatomic, copy  ) NSString       *firstName;
@property (nonatomic, copy  ) NSString       *lastName;
@property (nonatomic, copy  ) NSString       *leftAvatar;
@property (nonatomic, copy  ) NSString       *topAvatar;
@property (nonatomic, copy  ) NSString       *widthAvatar;
@property (nonatomic, copy  ) NSString       *heightAvatar;
@property (nonatomic, copy  ) NSString       *scaleAvatar;
@property (nonatomic, strong) NSMutableArray *contacts;
@end
