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
#import "FollowerUser.h"
#import "DataWall.h"
#import "UserSearch.h"
#import "Recent.h"

@interface CoziCoreData : NSObject
{
    Helper *helperIns;
}

+ (id) shareInstance;

//Messenger
- (NSMutableArray *) getMessenger;
- (NSMutableArray *) getMessengerWithFriendID:(int)_friendID withUserID:(int)_userID;
- (BOOL) isExistsMessenger:(NSString*)_keyMessenger;
- (BOOL) saveMessenger:(Messenger*)_messenger;
- (BOOL) updateMessenger:(Messenger*)_messenger;
- (void) deleteMessenger:(NSString*)_keyMessenger;

- (NSMutableArray *) getFriends;
- (NSMutableArray *) getFriendsWithUserID:(int)_userID;
- (BOOL)isExistsFriend:(int)_friendID withUserID:(int)_userID;
- (BOOL) saveFriend:(Friend *)_friend;
- (BOOL) updateFriend:(Friend *)_friend;
- (void) deleteFriend:(int)_friendID withUserID:(int)_userID;

- (NSMutableArray *) getUser;
- (NSManagedObject*) getUserByUserID:(int)_userID;
- (BOOL) isExistsUser:(int)_userID;
- (BOOL) saveUser:(User *)_user;
- (BOOL) updateUser:(User*)_user;
- (void) deleteUser:(int)_userID;

- (NSMutableArray*) getFollower;
- (NSMutableArray*) getFollowerByUserID:(int)_userID;
- (NSMutableArray*) getFollowerByParentUserID:(int)_userID;
- (BOOL) isExistsFollower:(int)_userID withParentID:(int)_parentID;
- (BOOL) saveFollower:(FollowerUser *)_follower;
- (BOOL) updateFollower:(FollowerUser*)_follower;
- (void) deleteFollower:(int)_userID;

//POST
- (NSMutableArray*) getPosts;
- (NSMutableArray*) getPostsByUserID:(int)_userID;
- (NSMutableArray*) getPostsByUserID:(int)_userID withClientKey:(NSString*)_clientKey;
- (BOOL) isExistsPost:(int)_userID withClientKey:(NSString*)_clientKey;
- (BOOL) savePosts:(DataWall*)_posts;
- (BOOL) updatePost:(DataWall*)_posts;
- (BOOL) deletePost:(int)_userID withClientKey:(NSString*)_clientKey;

//Friend Request
- (NSMutableArray*) getFriendRequest;
- (NSMutableArray*) getFriendRequestWithUserID:(int)_userID;
- (NSMutableArray*) getFriendRequestWithID:(int)_userID withFriendRequestID:(int)_friendRequestID;
- (BOOL) isExistsFriendRequest:(int)_userID withFriendRequestID:(int)_friendRequestID;
- (BOOL) saveFriendRequest:(UserSearch*)_friendRequest;
- (BOOL) updateFriendRequest:(UserSearch*)_friendRequest;
- (void) deleteFriendRequest:(int)_userID withFriendRequestID:(int)_friendRequestID;

//Group Chat
- (NSMutableArray*) getGroupChat;
- (NSMutableArray*) getGroupChatWithUserID:(int)_userID;
- (NSMutableArray*) getGroupChatWithID:(int)_userID withGroupChatID:(int)_groupChatID;
- (BOOL) isExistsGroupChat:(int)_userID withGroupChatID:(int)_groupChatID;
- (BOOL) saveGroupChat:(Recent*)_recent;
- (BOOL) updateGroupChat:(Recent*)_recent;
- (void) deleteGroupChat:(int)_userID withGroupChatID:(int)_groupChatID;

//Group Chat Friend
- (NSMutableArray*) getGroupChatFriend;
- (NSMutableArray*) getGroupChatFriendWithGroupID:(int)_groupID;
- (BOOL) isExistsGroupChatFriend:(int)_groupChatFriendID;
- (BOOL) saveGroupChatFriend:(Recent*)_recent;
- (BOOL) updateGroupChatFriend:(Friend*)_friend withGroupChatID:(int)_groupChatID;
- (void) deleteGroupChatFriend:(int)_groupID withFriendID:(int)_friendID;

//Group Chat Message
- (NSMutableArray*) getGroupChatMessage;
- (NSMutableArray*) getGroupChatMessageWithGroupID:(int)_groupID;
- (NSMutableArray*) getGroupChatMessageWithUserID:(int)_groupID withFriendID:(int)_friendID;
- (BOOL) isExistsGroupChatMessage:(NSString*)_keyMessage;
- (BOOL) saveGroupChatMessage:(Messenger*)_message withGroupID:(int)_groupID;
- (BOOL) updateGroupChatMessage:(Messenger*)_message;
- (void) deleteGroupChatMessage:(NSString*)_keyMessage;
@end
