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
#import "User.h"
#import "Messenger.h"
#import "AmazonInfo.h"
#import "Friend.h"
#import "NetworkCommunication.h"
#import "ReceiveLocation.h"
#import "CoziCoreData.h"
#import "ImageRender.h"
#import "GPUImageGrayscaleFilter.h"
#import "DataWall.h"
#import "FollowerUser.h"
#import <AddressBook/ABPerson.h>
#import <AddressBook/AddressBook.h>
#import "PersonContact.h"

@protocol StoreDelegate <NSObject>

@required
- (void) reloadChatView;

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
- (void) processSaveData;

//Core Data Follower
- (BOOL) addNewFollower:(FollowerUser*)_follower;
- (void) loadFollower:(int)_userID;
- (BOOL) checkFollowerExists:(int)_userID withParentID:(int)_parentID;

//Core Data
- (void) loadUser:(int)_userID;
- (void) loadFriend:(int)_userID;
- (void) loadMessenger;
- (void) processSaveCoreData;

- (void) fillAmazonInfomation:(AmazonInfo *)_amazon;
- (void) updateStatusSendImage;

- (BOOL) getInReceiveLocation;
- (void) processReceiveLocation;
- (NSString *)getLongitude;
- (NSString *)getlatitude;
- (void) updateLocation;
- (void) initLocation;

- (void) sortMessengerFriend;
- (NSString*) geturlThumbnailFriend:(NSString*)_phoneNumber;

- (void) getPostHistory:(int)_userPostID;
- (void) insertWallData:(DataWall*)_dataWall;
- (void) addWallData:(DataWall *)_dataWall;
- (void) addNoisesData:(DataWall *)_dataWall;
- (void) updateWall:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall;
- (void) updateNoise:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall;
- (DataWall *) getWall:(NSString*)_clientKey withUserPost:(int)_userPostID;

- (BOOL) isFollowing:(int)_userID;
- (BOOL) isFollower:(int)_userID;
- (BOOL) isFriend:(int)_userID;

//Friend Request
- (void) loadFriendRequest:(int)_userID;
- (void) removeFriendRequest:(int)_friendRequestID;
- (void) progressResultAddFriend:(int)_friendID withIsAllow:(BOOL)_isAllow;
@end
