//
//  CoziCoreData.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/4/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Messenger.h"
#import "Friend.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "Helper.h"

@interface CoziCoreData : NSObject
{
    Helper *helperIns;
}

+ (id) shareInstance;

- (NSMutableArray *) getMessenger;
- (NSMutableArray *) getMessengerWithFriendID:(int)_friendID withUserID:(int)_userID;
- (BOOL) isExistsMessenger:(int)_keyMessenger;
- (BOOL) saveMessenger:(Messenger*)_messenger;
- (BOOL) updateMessenger:(Messenger*)_messenger;
- (void) deleteMessenger:(int)_keyMessenger;

- (NSMutableArray *) getFriends;
- (NSMutableArray *) getFriendsWithUserID:(int)_userID;
- (BOOL)isExistsFriend:(int)_friendID withUserID:(int)_userID;
- (BOOL) saveFriend:(Friend *)_friend;
- (BOOL) updateFriend:(Friend *)_friend;
- (void) deleteFriend:(int)_friendID;

- (NSMutableArray *) getUser;
- (NSManagedObject*) getUserByUserID:(int)_userID;
- (BOOL) isExistsUser:(int)_userID;
- (BOOL) saveUser:(User *)_user;
- (BOOL) updateUser:(User*)_user;
- (void) deleteUser:(int)_userID;
@end
