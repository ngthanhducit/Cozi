//
//  Store+CoreData.h
//  Cozi
//
//  Created by ChjpCoj on 3/10/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "Store.h"
#import "Recent.h"

@interface Store (CoreData)
{
    
}

//Core Data Follower
- (BOOL) addNewFollower:(FollowerUser*)_follower;
- (void) loadFollower:(int)_userID;
- (BOOL) checkFollowerExists:(int)_userID withParentID:(int)_parentID;

//Core Data
- (void) loadUser:(int)_userID;
- (void) loadFriend:(int)_userID;
- (void) loadMessenger;
- (void) processSaveCoreData;

//Friend Request
- (void) loadFriendRequest:(int)_userID;
- (void) removeFriendRequest:(int)_friendRequestID;
- (void) progressResultAddFriend:(int)_friendID withIsAllow:(BOOL)_isAllow;

//Post
- (void) getPostHistory:(int)_userPostID;
- (void) insertWallData:(DataWall*)_dataWall;
- (void) addWallData:(DataWall *)_dataWall;
- (void) addNoisesData:(DataWall *)_dataWall;
- (void) insertNoisesData:(DataWall *)_dataWall;
- (void) updateWall:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall;
- (void) updateNoise:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall;
- (DataWall *) getWall:(NSString*)_clientKey withUserPost:(int)_userPostID;
- (DataWall*) getPostFromNoise:(NSString*)_clientKey withUserPostID:(int)_userPostID;

//Group Chat
- (NSMutableArray*) getGroupChatByUserID:(int)_userID;
- (void) insertGroupChat:(Recent*)_recent;
- (void) updateGroupChat:(Recent*)_recent;

//Group Chat Friend
- (NSMutableArray*) getGroupChatFriendByGroupID:(int)_groupID;
- (void) insertGroupChatFriend:(Recent*)_recent;
- (void) updateGroupChatFriend:(Friend*)_friend withGroupChatID:(int)_groupChatID;

//Group Chat Message
- (NSMutableArray *) getGroupChatMessageByGroupID:(int)_groupID;
- (NSMutableArray *) getGroupChatMessageWithFriend:(int)_groupID withFriendID:(int)_friendID;
- (void) insertGroupChatMessage:(Messenger*)_message withGroupID:(int)_groupID;
- (void) updateGroupChatMessage:(Messenger*)_message;
- (void) deleteGroupChatMessage:(NSString*)_keyMessage;
@end
