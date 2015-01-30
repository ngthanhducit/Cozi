//
//  Friend.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize friendID;
@synthesize nickName;
@synthesize firstName;
@synthesize lastName;
@synthesize gender;
@synthesize avatar;
@synthesize statusFriend;
@synthesize leftAvatar;
@synthesize topAvatar;
@synthesize widthAvatar;
@synthesize heightAvatar;
@synthesize scaleAvatar;
@synthesize friendMessage;
@synthesize userID;
@synthesize phoneNumber;

- (id) init{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    self.friendMessage = [[NSMutableArray alloc] init];
}
@end
