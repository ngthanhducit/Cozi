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
#import "SDWebImageDownloader.h"
#import "AsyncImageDownloader.h"
#import "ImageRender.h"
#import "GPUImageGrayscaleFilter.h"
#import "DataWall.h"

@protocol StoreDelegate <NSObject>

@required
- (void) reloadChatView;

@end

@interface Store : NSObject <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray              *urlAssetsImage;
    NSMutableArray              *assetsThumbnail;
    Helper                      *helperIns;
//    NSInteger                   keyMessage;
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
}

@property (nonatomic, weak) id <StoreDelegate> delegate;
@property (nonatomic, strong) User           *user;
@property (nonatomic, strong) NSMutableArray        *recent;
@property (nonatomic, strong) NSMutableArray *walls;
@property (nonatomic, strong) NSMutableArray *noises;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *friendsRequest;
@property (nonatomic, strong) NSMutableArray *sendAmazon;
@property (nonatomic, strong) UIImage           *imgDemo;
@property (nonatomic, strong) NSMutableArray        *receiveLocation;
@property (nonatomic, strong)    NSDate             *timeServer;
@property (nonatomic, strong) NSString                  *keyGoogleMaps;

+ (id) shareInstance;

- (NSInteger) getKeyMessage;
- (NSInteger) incrementKeyMessage:(int)friendID;

- (void) setup;
- (Friend *) getFriendByID:(int)friendID;
- (void) updateMessageFriend:(Messenger *)_newMessage withFriendID:(int)_friendID;
- (void) updateStatusMessageFriend:(int)friendID withStatus:(int)_statusID;
- (void) updateStatusMessageFriend:(int)friendID withKeyMessage:(NSInteger)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_timeServer;
- (void) updateStatusMessageFriendWithKey:(int)friendID withMessageID:(NSInteger)_keyMessage withStatus:(int)_statusID;
- (void) updateStatusFriend:(int)friendID withStatus:(int)_statusFriend;
- (void) updateKeyAmazone:(int)userReceiveID withKeyMessage:(NSInteger)_keyMessage withKeyAmazon:(NSString*)_keyAmazon;
- (Messenger *) getMessageFriendID:(int)_friendID withKeyMessage:(NSInteger)_keyMessage;
- (BOOL) deleteMessenger:(int)friendID withKeyMessenger:(NSInteger)_keyMessenger;

- (NSMutableArray*) getAssetsLibrary;
- (NSMutableArray*) getAssetsThumbnail;
- (void) processSaveData;

//Core Data
- (void) loadUser:(int)_userID;
- (void) loadFriend:(int)_userID;
- (void) loadMessenger;
- (void) processSaveCoreData;

- (void) saveMessengerToCoreData:(Messenger*)_messenger;
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

- (void) addWallData:(DataWall *)_dataWall;
- (void) addNoisesData:(DataWall *)_dataWall;
- (void) updateWall:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall;
- (DataWall *) getWall:(NSString*)_clientKey withUserPost:(int)_userPostID;
@end
