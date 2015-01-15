//
//  DataMap.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "Messenger.h"
#import "Friend.h"
#import "NewUser.h"
#import "PersonContact.h"
#import "CoziCoreData.h"
#import "SDWebImageDownloader.h"
#import "DataWall.h"
#import "PostComment.h" 
#import "PostLike.h"
#import "AmazonInfoPost.h"

@interface DataMap : NSObject
{
    CoziCoreData *coziCoreDataIns;
}

@property (nonatomic, strong) Helper                        *helperIns;
@property (nonatomic, strong) Store                         *storeIns;

+ (id) shareInstance;

- (NSString*) loginCommand:(NSString*) phone withHashPass:(NSString*)hashPass withToken:(NSString*)deviceToken withLongitude:(NSString*)longitude withLatitude:(NSString*)latitude;
- (int) mapLogin:(NSString*)str;

- (NSString*) reconnectCommand:(NSString*)userID withHashPass:(NSString*)hashPass;
- (int) mapReconnect:(NSString*)str;

- (NSString*) sendMessageCommand:(int)userReceive withKeyMessage:(NSInteger)_keyMessage withMessage:(NSString*)message withTimeout:(int)_timeOut;
- (int) mapSendMessage:(NSString*)str;
- (Messenger *) mapReceiveMessage:(NSString*)str;
- (Friend*) processReceiveMessage:(Messenger *)sms;
- (NSString *) sendIsReadMessage:(int)_friendID withKeyMessage:(NSInteger)_keyMessage;
- (NSString *) sendIsReadPhoto:(int)_friendID withKeyMessage:(NSInteger)_keyMessage;
- (NSString *) sendIsReadLocation:(int)_friendID withKeyMessage:(NSInteger)_keyMessage;
- (NSString *) removeMessage:(int)_userReceive withKeyMessage:(int)_keyMessenger;
- (NSString *) removePhoto:(int)_userReceive withKeyMessage:(int)_keyMessenger;
- (NSString *) removeLocation:(int)_userReceive withKeyMessage:(int)_keyMessenger;

- (NSString*) requestFriendCommand:(int)userID withDigit:(NSString*)digit;
- (int) mapRequestFriends:(NSString*)str;
- (void) resultFriendRequest:(NSString*)str;
- (void) loadData;
- (NSString*) getUploadAmazonUrl:(int)_userReciveID withMessageKye:(NSInteger)keyMessage withIsNotify:(int)_isNotify;
- (NSString *) getUploadAvatar;
- (NSString *) commandResultUploadAvatar:(int)_codeAvatar withCodeThumbnail:(int)_codeThumbnail;
- (NSString *) cmdNewUser:(NewUser*)_newUser;
- (NSString *) cmdSendAuthCode:(NSString *)_authCode;

- (AmazonInfo*) mapAmazonInfo:(NSString*)str;
- (AmazonInfo*) mapAmazonUploadAvatar:(NSString *)str;
- (AmazonInfoPost*) mapAmazonUploadPost:(NSString *)str;

- (NSString *) sendResultUploadAmazon:(int)code withFriendID:(int)_friendID withKeyMessage:(NSInteger)_keyMessage;
- (NSString *) commandSendPhoto:(int)userReceive withKey:(NSString*)key withKeyMessage:(NSInteger)_keyMessage withTimeout:(int)_timeOut;

- (NSString *) regPhone:(NSString *)strPhone;
- (NSString *)sendLocation:(int)userReceiveID withLong:(NSString*)_long withLati:(NSString*)_lati withKeyMessage:(NSInteger)_keyMessage withTimeOut:(int)_timeOut;

//Wall Noise
- (NSMutableArray*) mapDataWall:(NSString*)_str withType:(int)type;
- (NSMutableArray*) mapDataNoises:(NSString*)_str;
@end
