//
//  FollowerUser.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/21/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FollowerUser : NSObject
{
    
}

@property (nonatomic      ) int      userID;
@property (nonatomic      ) int      parentUserID;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *urlAvatar;
@property (nonatomic      ) int      statusFollow;//0: Accept - 1: waiting - 2: deine
@end
