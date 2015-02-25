//
//  NetworkController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cozi/DataWall.h"
#import "Cozi/Helper.h"
#import "Cozi/NetworkCommunication.h"
#import "PNetworkCommunication.h"

@interface NetworkController : NSObject <PNetworkCommunication>
{
    Helper          *helperIns;
    NetworkCommunication *networkIns;
    
    NSMutableArray      *instances;
}

+ (id) shareInstance;

//Login page
- (void) registerPhone:(NSString*)_cmdPhone;
- (void) sendAuthCode:(NSString*)_cmdAuthCode;
- (void) getUploadAvatar:(NSString*)_cmdUploadAvatar;
- (void) sendResultUploadAvatar:(NSString*)_cmdResultUpload;
- (void) createNewUser:(NSString*)_cmdCreateUser;
- (void) login:(NSString*)_strUserName withPassword:(NSString*)_strPassword;

- (void) addListener:(id)instance;
- (void) removeListener:(id)instance;

- (void) getUploadPostUrl;
- (void) resultUploadImagePost:(int)code withCodeThumb:(int)codeThumb;
- (void) addPost:(NSString*)_content withImage:(NSString*)_image withImageThumb:(NSString*)_imageThumb withVideo:(NSString*)_video withLocation:(NSString*)_location withClientKey:(NSString*)clientKey withCode:(int)code;
- (void) addMood:(NSString*)_content withClientKey:(NSString*)clientKey withCode:(int)code;
- (void) getWall:(int)_countPost withClientKeyStart:(NSString*)_startClientKey;
- (void) getWallByUser:(int)_countPost withClientKeyStart:(NSString*)_startClientKey withUserID:(int)_userID;
- (void) getNoise:(int)_countPost withClientKeyStart:(NSString*)_startClientKey;

//LIKE
- (void) addPostLike:(DataWall*)_wall;
- (void) removePostLike:(DataWall*)_wall;

- (void) addComment:(NSString*)_content withImageName:(NSString*)_imgName withPostClientKey:(NSString*)_postClientKey withCommentClientKey:(NSString*)_commentClientKey withUserPostID:(int)_userPostComment;

- (void) getUserProfile:(int)_userID;
- (void) getUserFollower:(int)_userID;
- (void) getUserFollowing:(int)_userID;
- (void) getUserPost:(int)_userID withCountPost:(int)_countPost withClientKey:(NSString*)_clientKey;

- (void) addFollow:(int)_userFollowID;
- (void) removeFollow:(int)_userFollowID;

- (void) getUserByString:(NSString*)_strSearch;
- (void) addFriend:(int)_userID withDigit:(NSString*)_digit;
- (void) acceptOrDenyAddFriend:(int)_userRequestID withIsAllow:(int)_isAllow;
- (void) findUserInRanger:(CGFloat)_ranger;
@end
