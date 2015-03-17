//
//  Store.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "User.h"
#import "Messenger.h"
#import "AmazonInfo.h"
#import "Friend.h"
#import "NetworkCommunication.h"
#import "ReceiveLocation.h"
#import "CoziCoreData.h"
#import "GPUImageGrayscaleFilter.h"
#import "DataWall.h"
#import "FollowerUser.h"
#import <AddressBook/ABPerson.h>
#import <AddressBook/AddressBook.h>
#import "PersonContact.h"
#import "SDWebImage/SDImageCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import "Recent.h"

@protocol StoreDelegate <NSObject>

@required
- (void) reloadChatView:(Messenger*)_messenger;

@end

@interface Store : NSObject <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray              *urlAssetsImage;
    NSMutableArray              *assetsThumbnail;
    Helper                      *helperIns;
    BOOL                        inSendImage;
    
    NSString                    *_longitude;
    NSString                    *_latitude;
    
    CLLocationManager           *locationManager;
    CLGeocoder                  *geoCoder;
    CLPlacemark                 *placeMark;
    
    BOOL                        inReceiveLocation;
    NSMutableData               *dataLocation;
    CoziCoreData                *coziCoreDataIns;
    NSString                    *_keyGoogleMaps;
    NSMutableDictionary           *staticImageDictionary;
    NSDictionary                  *dicColor;
    
    void (^completeUpdate)(BOOL finish);
}

@property (nonatomic) BOOL              isConnected;
@property (nonatomic, weak  ) id <StoreDelegate  > delegate;
@property (nonatomic, strong) User           *user;
@property (nonatomic, strong) NSMutableArray *recent;
@property (nonatomic, strong) NSMutableArray *walls;
@property (nonatomic, strong) NSMutableArray *noises;
@property (nonatomic, strong) NSMutableArray    *listHistoryPost;
@property (nonatomic, strong) NSMutableArray *listFollower;
@property (nonatomic, strong) NSMutableArray *listFollowing;
@property (nonatomic, strong) NSMutableArray *listFollowRequest;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *friendsRequest;
@property (nonatomic, strong) NSMutableArray *sendAmazon;
@property (nonatomic, strong) NSMutableArray *receiveLocation;
@property (nonatomic, strong) NSDate         *timeServer;
@property (nonatomic, copy  ) NSString       *keyGoogleMaps;
@property (nonatomic, strong) NSMutableArray  *contactList;

+ (id) shareInstance;

- (void) addressBookValidation;
- (NSString*) randomKeyMessenger;
- (void) setup;
- (Friend *) getFriendByID:(int)friendID;
- (void) updateMessageFriend:(Messenger *)_newMessage withFriendID:(int)_friendID;
- (void) updateStatusMessageFriend:(int)friendID withStatus:(int)_statusID;
- (void) updateStatusMessageFriend:(int)friendID withKeyMessage:(NSString*)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_time;
- (void) updateStatusMessageFriendWithKey:(int)friendID withMessageID:(NSString*)_keyMessage withStatus:(int)_statusID;
- (void) updateStatusFriend:(int)friendID withStatus:(int)_statusFriend;
- (void) updateKeyAmazone:(int)userReceiveID withKeyMessage:(NSString*)_keyMessage withKeyAmazon:(NSString*)_keyAmazon withUrl:(NSString*)_urlImage;
- (Messenger *) getMessageFriendID:(int)_friendID withKeyMessage:(NSString*)_keyMessage;
- (BOOL) deleteMessenger:(int)friendID withKeyMessenger:(NSString*)_keyMessenger;

- (NSMutableArray*) getAssetsLibrary;
- (NSMutableArray*) getAssetsThumbnail;
//- (void) processSaveData;

- (void) fillAmazonInfomation:(AmazonInfo *)_amazon;
- (void) updateStatusSendImage;

- (BOOL) getInReceiveLocation;
- (void) processReceiveLocation;
- (NSString *)getLongitude;
- (NSString *)getlatitude;
- (void) updateLocation;
- (void) updateLocationcomplete:(void (^)(BOOL finish))completeHandler;

- (void) initLocation;

- (UIImage*) getAvatarThumbFriend:(int)_friendID;

- (void) sortMessengerFriend;
- (NSString*) geturlThumbnailFriend:(NSString*)_phoneNumber;

- (BOOL) isFollowing:(int)_userID;
- (BOOL) isFollower:(int)_userID;
- (BOOL) isFriend:(int)_userID;

- (UIImage*) renderGroupImageWithFriend:(NSMutableArray*)_friends;
- (UIImage*) renderGroupImageWithMessage:(NSMutableArray*)_messenger;

- (Recent *) getRecentByRecentID:(int)_recentID;
//Group Chat
- (Recent *) getGroupChatByGroupID:(int)groupID;
- (Messenger *) getMessageGroupID:(int)groupID withKeyMessage:(NSString*)keySendMessage;
- (void) updateStatusGroupMessage:(int)groupID withKeyMessage:(NSString*)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_time;
- (void) updateKeyAmazoneForGroupChat:(int)_groupID withKeyMessage:(NSString*)_keyMessage withKeyAmazon:(NSString *)_keyAmazon withUrl:(NSString *)_urlImage;

- (void) playSoundPress;
- (void) playSoundTouchOne;
@end
