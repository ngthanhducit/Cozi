//
//  User.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic        ) int       userID;
@property (nonatomic        ) int       statusUser;
@property (nonatomic, copy  ) NSString  *nickName;
@property (nonatomic, copy  ) NSString  *firstname;
@property (nonatomic, copy  ) NSString  *lastName;
@property (nonatomic, copy  ) NSString  *phoneNumber;
@property (nonatomic, copy  ) NSString  *birthDay;
@property (nonatomic, copy  ) NSString  *gender;
@property (nonatomic, copy  ) NSString  *urlThumbnail;
@property (nonatomic, copy  ) NSString  *urlAvatar;
@property (nonatomic, strong) UIImage   *avatar;
@property (nonatomic, strong) UIImage   *thumbnail;;
@property (nonatomic, copy  ) NSString  *accessKey;
@property (nonatomic        ) CGFloat   leftAvatar;
@property (nonatomic        ) CGFloat   topAvatar;
@property (nonatomic        ) CGFloat   widthAvatar;
@property (nonatomic        ) CGFloat   heightAvatar;
@property (nonatomic        ) CGFloat   scaleAvatar;
@property (nonatomic, copy  ) NSString  *timeServer;
@property (nonatomic        ) NSInteger keySendMessenger;
@property (nonatomic        ) int       countPosts;
@property (nonatomic        ) int       isPublic;
@end
