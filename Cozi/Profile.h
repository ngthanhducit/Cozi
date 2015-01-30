//
//  Profile.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/20/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Profile : NSObject
{
    
}

@property (nonatomic        ) BOOL     isPublic;
@property (nonatomic        ) int      countFollower;
@property (nonatomic        ) int      countFollowing;
@property (nonatomic        ) int      countPost;
@property (nonatomic        ) int      userID;
@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, copy  ) NSString *firstName;
@property (nonatomic, copy  ) NSString *lastName;
@property (nonatomic, copy  ) NSString *thumbAvatar;
@property (nonatomic, copy  ) NSString *avatar;
@property (nonatomic, copy  ) NSString *birthDay;
@property (nonatomic, copy  ) NSString *gender;
@property (nonatomic, copy  ) NSString *relationship;
@property (nonatomic, strong) UIImage  *imgAvatar;
@property (nonatomic, strong) UIImage  *imgThumbnail;
@end
