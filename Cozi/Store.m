//
//  Store.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize user;
@synthesize friends;
@synthesize friendsRequest;
@synthesize sendAmazon;
@synthesize recent;

+ (id) shareInstance{
    static Store   *shareIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns = [[Store alloc] init];
    });
    
    return shareIns;
}

- (id) init{
    self = [super init];
    if (self) {
        [self setup];
        
        [self initLocation];
    }
    
    return self;
}

- (void) setup{
    
    helperIns = [Helper shareInstance];
    coziCoreDataIns = [CoziCoreData shareInstance];
    
    dataLocation = [[NSMutableData alloc] init];
    self.walls = [NSMutableArray new];
    self.noises = [NSMutableArray new];
    self.receiveLocation = [[NSMutableArray alloc] init];
    self.sendAmazon = [[NSMutableArray alloc] init];
    self.recent = [[NSMutableArray alloc] init];
    self.user = [[User alloc] init];
    self.friends = [[NSMutableArray alloc] init];
    self.friendsRequest = [[NSMutableArray alloc] init];
    
    urlAssetsImage = [[NSMutableArray alloc] init];
    assetsThumbnail = [[NSMutableArray alloc] init];
    
    [self loadAssets];
    
    _longitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"Longitude"];
    _latitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"];
}

- (void) initLocation{
    locationManager = [[CLLocationManager alloc] init];

    BOOL isEnable = [CLLocationManager locationServicesEnabled];
    if (isEnable) {
        geoCoder = [[CLGeocoder alloc] init];
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
            
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [locationManager performSelector:@selector(requestWhenInUseAuthorization)];
            }
            
            [locationManager startUpdatingLocation];
        }
    }
}

-(void) loadAssets{
    
    __block ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSInteger numberAss = [group numberOfAssets];
            if (numberAss == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAssetsComplete" object:nil];
                });
            }
            
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                        CGImageRef iref = [result aspectRatioThumbnail];
                        
                        UIImage *img =  [UIImage imageWithCGImage:iref];
                        
                        if (img) {
                            
                            [assetsThumbnail addObject:img];
                            
                            [urlAssetsImage addObject:[[result defaultRepresentation] url]];
                            
                        }else{
                            
                            NSLog(@"image error");
                            
                        }
                }
            }];
            
        } failureBlock:^(NSError *error) {
            NSLog(@"No groups: %@", error);
        }];
        
    });
}

- (NSInteger) getKeyMessage{
    return self.user.keySendMessenger;
}

- (NSInteger) incrementKeyMessage:(int)friendID{
//    keyMessage +=1;
    self.user.keySendMessenger += 1;
    int keyUser = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
//    int random = arc4random_uniform(10000);
//    NSInteger keySend = [[NSString stringWithFormat:@"%i%i%i", keyUser, (int)keyMessage, random] integerValue];
    NSInteger keySend = [[NSString stringWithFormat:@"%i%i%i", keyUser, friendID, (int)self.user.keySendMessenger] integerValue];
    
    if (keySend >= NSIntegerMax) {
//        keyMessage = 0;
        self.user.keySendMessenger =0;
    }
    
//    [[NSUserDefaults standardUserDefaults] setInteger:keyMessage forKey:@"keyMessage"];
    
//    self.user.keySendMessenger = keyMessage;
    
    [coziCoreDataIns updateUser:self.user];
    
    return keySend;
}

- (NSMutableArray*) getAssetsThumbnail{
    return assetsThumbnail;
}

- (NSMutableArray*) getAssetsLibrary{
    return urlAssetsImage;
}

- (void) updateMessageFriend:(Messenger *)_newMessage withFriendID:(int)_friendID{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _friendID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([[friend.friendMessage objectAtIndex:j] keySendMessage] == _newMessage.keySendMessage) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTypeMessage:_newMessage.typeMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStatusMessage:_newMessage.statusMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setSenderID: _newMessage.senderID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setFriendID: _newMessage.friendID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStrMessage: _newMessage.strMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setKeySendMessage:_newMessage.keySendMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeServerMessage: _newMessage.timeServerMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeMessage:_newMessage.timeMessage];
                            //                            NSURL *imgUrl = [NSURL URLWithString:_newMessage.strMessage];
                            //                            NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                            //                            UIImage *img = [UIImage imageWithData:imgData];
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setThumnail:_newMessage.thumnail];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setDataImage:_newMessage.dataImage];
                            
                            break;
                        }
                    }
                }
                
                break;
            }
        }
    }
}

- (void) updateStatusMessageFriend:(int)friendID withStatus:(int)_statusID{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                [[[[self.friends objectAtIndex:i] friendMessage] lastObject] setStatusMessage:_statusID];
                break;
            }
        }
    }
}

- (void) updateStatusMessageFriend:(int)friendID withKeyMessage:(NSInteger)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_timeServer{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    
                    for (int j = 0; j < countMessage; j++) {
                        if ([[friend.friendMessage objectAtIndex:j] keySendMessage] == _keyMessage) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStatusMessage:_statusID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeServerMessage: [helperIns convertStringToDate:_timeServer]];
                            
                            break;
                        }
                    }
                }
                
                
                break;
            }
        }
    }
}

- (Messenger *) getMessageFriendID:(int)_friendID withKeyMessage:(NSInteger)_keyMessage{
    Messenger *result = nil;
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _friendID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([[friend.friendMessage objectAtIndex:j] keySendMessage] == _keyMessage) {
                            
                            result = [friend.friendMessage objectAtIndex:j];
                            
                            break;
                        }
                    }
                }
                
                break;
            }
        }
    }
    
    return result;
}

- (BOOL) deleteMessenger:(int)friendID withKeyMessenger:(NSInteger)_keyMessenger{
    
    BOOL result = NO;
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                
                Friend *_friend = [self.friends objectAtIndex:i];
                if ([[_friend friendMessage] count] > 0) {
                    int countMessenger = (int)[[[self.friends objectAtIndex:i] friendMessage] count];
                    for (int j = 0; j < countMessenger; j++) {
                        
                        Messenger *_messenger = [_friend.friendMessage objectAtIndex:j];
                        
                        if (_messenger.keySendMessage == _keyMessenger) {
                            
                            [[[self.friends objectAtIndex:i] friendMessage] removeObjectAtIndex:j];
                            
                            result = YES;
                            
                            break;
                        }
                        
                    }
                }
                
                
                break;
            }
        }
    }
    
    return result;
}

- (void) updateStatusMessageFriendWithKey:(int)friendID withMessageID:(NSInteger)_keyMessage withStatus:(int)_statusID{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                Friend *_friend = [self.friends objectAtIndex:i];
                
                if (_friend.friendMessage != nil) {
                    int countMessage = (int)[_friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([[_friend.friendMessage objectAtIndex:j] keySendMessage] == _keyMessage) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStatusMessage:_statusID];
                            
                            return;
                        }
                    }
                }
            }
        }
    }
}

- (void) updateStatusFriend:(int)friendID withStatus:(int)_statusFriend{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                [[self.friends objectAtIndex:i] setStatusFriend:_statusFriend];
                break;
            }
        }
    }
}

- (void) updateKeyAmazone:(int)userReceiveID withKeyMessage:(NSInteger)_keyMessage withKeyAmazon:(NSString *)_keyAmazon{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == userReceiveID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        
                        if ([[friend.friendMessage objectAtIndex:j] keySendMessage] == _keyMessage) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setAmazonKey:_keyAmazon];
                            
                            break;
                        }
                    }
                }
                
                break;
            }
        }
    }
}

- (Friend *) getFriendByID:(int)friendID{
    Friend *result = nil;
    if (self.friends != nil) {
        int count= (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                result = [self.friends objectAtIndex:i];
                
                break;
            }
        }
    }
    
    return result;
}

- (void) processCutAvatar{
    NSOperationQueue    *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(proCutAvatar) object:nil];
    [queue addOperation:operation];
    [operation setThreadPriority:0.1];
    [operation setQueuePriority:NSOperationQueuePriorityVeryLow];
        [operation setCompletionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cutAvatarComplete" object:nil];
        }];
}

- (void) proCutAvatar{
    if (self.friends != nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            NSString *_filePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i", i]];
            
            NSData *imgData = [NSData dataWithContentsOfFile:_filePath];
            UIImage *img = [UIImage imageWithData:imgData];
            
            if (img != nil) {
                UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(img.size.width / 2, img.size.height / 2) radius:img.size.width / 2 startAngle:0 endAngle:360 clockwise:YES];
                UIImage *avatar = [helperIns maskImage:img toPath:aPath];
                
                [[self.friends objectAtIndex:i] setAvatar:avatar];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cutAvatarComplete" object:nil];
}

#pragma -makr Process Data in sqlite
- (void) processSaveCoreData{
    //Save User Info
    BOOL _isExists = [coziCoreDataIns isExistsUser:self.user.userID];
    if (_isExists) {
        //Upate User
        NSManagedObject *userObj = [coziCoreDataIns getUserByUserID:self.user.userID];
        NSInteger _keySendMessenger = [[userObj valueForKey:@"key_send_messenger"] integerValue];
        self.user.keySendMessenger = _keySendMessenger;
        
        [coziCoreDataIns updateUser:self.user];
        
    }else{
        //Add New user
        [coziCoreDataIns saveUser:self.user];
    }
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            Friend *_friend = [self.friends objectAtIndex:i];
            BOOL _isExistsFriend = [coziCoreDataIns isExistsFriend:[[self.friends objectAtIndex:i] friendID] withUserID:self.user.userID];
            if (_isExistsFriend) {
                
            }else{
                //Add new Friend;
                BOOL _isSaveFriend = [coziCoreDataIns saveFriend:_friend];
            }
            
            //check Messenger
            if ([[_friend friendMessage] count] > 0) {
                int countMessenger = (int)[_friend.friendMessage count];
                for (int j = 0; j < countMessenger; j++) {
                    Messenger *_messenger = [_friend.friendMessage objectAtIndex:j];
                    BOOL _isExistsMessenger = [coziCoreDataIns isExistsMessenger:(int)_messenger.keySendMessage];
                    if (_isExistsMessenger) {
                        //Update Messenger
                    }else{
                        //Add new Messenger
                        BOOL _isSaveMessenger = [coziCoreDataIns saveMessenger:_messenger];
                    }
                }
            }
        }
    }
}

- (void) loadUser:(int)_userID{
    NSManagedObject *_user = [coziCoreDataIns getUserByUserID:_userID];
    if (_user != nil) {
        [self.user setAccessKey:[_user valueForKey:@"access_key"]];
        [self.user setBirthDay:[_user valueForKey:@"birth_day"]];
        [self.user setFirstname:[_user valueForKey:@"first_name"]];
        [self.user setGender:[_user valueForKey:@"gender"]];
        [self.user setHeightAvatar:[[_user valueForKey:@"height_avatar"] floatValue]];
        [self.user setLastName:[_user valueForKey:@"last_name"]];
        [self.user setLeftAvatar:[[_user valueForKey:@"left_avatar"] floatValue]];
        [self.user setNickName:[_user valueForKey:@"nick_name"]];
        [self.user setPhoneNumber:[_user valueForKey:@"phone_number"]];
        [self.user setScaleAvatar:[[_user valueForKey:@"scale_avatar"] floatValue]];
        [self.user setTimeServer:[_user valueForKey:@"time_server"]];
        [self.user setTopAvatar:[[_user valueForKey:@"top_avatar"] floatValue]];
        [self.user setUrlAvatar:[_user valueForKey:@"url_avatar"]];
        [self.user setKeySendMessenger:[[_user valueForKey:@"key_send_messenger"] integerValue]];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.user.urlAvatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [self.user setAvatar:image];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
            });

        }];
        
        [self.user setUrlThumbnail:[_user valueForKey:@"url_thumbnail"]];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.user.urlThumbnail] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [self.user setThumbnail:image];
            }
        }];
        
        [self.user setUserID:[[_user valueForKey:@"user_id"] intValue]];
        [self.user setStatusUser:[[_user valueForKey:@"user_status"] intValue]];
        [self.user setWidthAvatar:[[_user valueForKey:@"width_avatar"] floatValue]];
    }
}

- (void) loadFriend:(int)_userID{
    NSMutableArray *_friendsDB = [coziCoreDataIns getFriendsWithUserID:_userID];
    if (_friendsDB != nil) {
        int count = (int)[_friendsDB count];
        for (int i = 0; i < count; i++) {
            NSManagedObject *_friend = (NSManagedObject*)[_friendsDB objectAtIndex:i];
            Friend *_newFriend = [Friend new];
            [_newFriend setFirstName:[_friend valueForKey:@"first_name"]];
            [_newFriend setFriendID:[[_friend valueForKey:@"friend_id"] intValue]];
            [_newFriend setGender:[_friend valueForKey:@"gender"]];
            [_newFriend setHeightAvatar:[[_friend valueForKey:@"height_avatar"] floatValue]];
            [_newFriend setLastName:[_friend valueForKey:@"last_name"]];
            [_newFriend setLeftAvatar:[[_friend valueForKey:@"left_avatar"] floatValue]];
            [_newFriend setNickName:[_friend valueForKey:@"nick_name"]];
            [_newFriend setScaleAvatar:[[_friend valueForKey:@"scale_avatar"] floatValue]];
            [_newFriend setStatusFriend:[[_friend valueForKey:@"status_friend"] intValue]];
            [_newFriend setTopAvatar:[[_friend valueForKey:@"top_avatar"] floatValue]];
            [_newFriend setUrlAvatar:[_friend valueForKey:@"url_avatar"]];
            [_newFriend setUrlThumbnail:[_friend valueForKey:@"url_thumbnail"]];
            [_newFriend setPhoneNumber:[_friend valueForKey:@"phone_number"]];

            if (![_newFriend.urlThumbnail isEqualToString:@""]) {
                [[[AsyncImageDownloader alloc] initWithMediaURL:_newFriend.urlThumbnail successBlock:^(UIImage *image) {
                    _newFriend.thumbnail = image;
                    
                    GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
                    
                    UIImage *grayscaleImage = [grayscaleFilter imageByFilteringImage:image];
                    
                    [_newFriend setThumbnailOffline:grayscaleImage];
                    
                } failBlock:^(NSError *error) {
                    
                }] startDownload];
            }else{
                
                [_newFriend setThumbnail:[helperIns getImageFromSVGName:@"emptyAvatar.svg"]];
                [_newFriend setThumbnailOffline:[helperIns getImageFromSVGName:@"emptyAvatar.svg"]];
                
            }
            
            [_newFriend setUserID:[[_friend valueForKey:@"user_id"] intValue]];
            [_newFriend setWidthAvatar:[[_friend valueForKey:@"width_avatar"] floatValue]];
            
            _newFriend.friendMessage = [NSMutableArray new];
            
            //load message
            NSMutableArray *_messengerDB = [coziCoreDataIns getMessengerWithFriendID:_newFriend.friendID withUserID:self.user.userID];
            if (_messengerDB != nil) {
                int countMessenger = (int)[_messengerDB count];
                for (int j = 0; j < countMessenger; j++) {
                    NSManagedObject *messengerObj = (NSManagedObject*)[_messengerDB objectAtIndex:j];
                    int _type = [[messengerObj valueForKey:@"type_messenger"] intValue];
                    if (_type == 1) {
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *strImage = [messengerObj valueForKey:@"strImage"];
                        
                        NSData *dataImage = [helperIns decodeBase64:strImage];
                        UIImage *image = [UIImage imageWithData:dataImage];
                        UIImage *imgThum = [helperIns resizeImage:image resizeSize:CGSizeMake(320, 568)];
                        [_newMessenger setThumnail:imgThum];
                        _newMessenger.dataImage = dataImage;
                        
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        
                        [_newFriend.friendMessage addObject:_newMessenger];
                    }else if (_type == 2){
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessenger.latitude, _newMessenger.longitude, @"%7c" , _newMessenger.latitude, _newMessenger.longitude];

                        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (image && finished) {
                                _newMessenger.thumnail = image;
                            }
                        }];
                        
                        [_newFriend.friendMessage addObject:_newMessenger];
                    }else{
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        [_newFriend.friendMessage addObject:_newMessenger];
                    }
                }
            }
            
            [self.friends addObject:_newFriend];
            
            if ([_newFriend.friendMessage count] > 0) {
                [recent addObject:_newFriend];
            }
            
        }
    }
    
}

- (void) loadMessenger{
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            Friend *_friend = [self.friends objectAtIndex:i];
            
            //load message
            NSMutableArray *_messengerDB = [coziCoreDataIns getMessengerWithFriendID:_friend.friendID withUserID:self.user.userID];
            if (_messengerDB != nil) {
                int countMessenger = (int)[_messengerDB count];
                for (int j = 0; j < countMessenger; j++) {
                    NSManagedObject *messengerObj = (NSManagedObject*)[_messengerDB objectAtIndex:j];
                    int _type = [[messengerObj valueForKey:@"type_messenger"] intValue];
                    if (_type == 1) {
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *strImage = [messengerObj valueForKey:@"strImage"];
                        
                        NSData *dataImage = [helperIns decodeBase64:strImage];
                        UIImage *image = [UIImage imageWithData:dataImage];
                        [_newMessenger setThumnail:image];
                        
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        
                        [_friend.friendMessage addObject:_newMessenger];
                    }else if (_type == 2){
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessenger.latitude, _newMessenger.longitude, @"%7c" , _newMessenger.latitude, _newMessenger.longitude];
                        
                        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (image && finished) {
                                _newMessenger.thumnail = image;
                            }
                        }];
                        
                        [_friend.friendMessage addObject:_newMessenger];
                    }else{
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[[messengerObj valueForKey:@"key_send_message"] integerValue]];
                        [_newMessenger setLatitude:[messengerObj valueForKey:@"latitude"]];
                        [_newMessenger setLongitude:[messengerObj valueForKey:@"longitude"]];
                        [_newMessenger setSenderID:[[messengerObj valueForKey:@"sender_id"] intValue]];
                        [_newMessenger setStatusMessage:[[messengerObj valueForKey:@"status_messenger"] intValue]];
                        [_newMessenger setStrMessage:[messengerObj valueForKey:@"str_messenger"]];
                        [_newMessenger setTimeMessage:[messengerObj valueForKey:@"time_messenger"]];
                        [_newMessenger setTimeServerMessage:[helperIns convertStringToDate:[messengerObj valueForKey:@"time_server"]]];
                        [_newMessenger setTypeMessage:[[messengerObj valueForKey:@"type_messenger"] intValue]];
                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"url_image"]];
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        [_newMessenger setTimeOutMessenger:[[messengerObj valueForKey:@"timeout_messenger"] intValue]];
                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        [_friend.friendMessage addObject:_newMessenger];
                        
                    }
                }
            }
            
            if ([_friend.friendMessage count] > 0) {
                [self.recent addObject:_friend];
            }
        }
    }
    
}

#pragma -mark NSUserDefault
- (void) processSaveData{
    NSOperationQueue    *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(proSaveData) object:nil];
    [operation setThreadPriority:0.1];
    [queue addOperation:operation];
    [operation setCompletionBlock:^{
        NSLog(@"complete process save data");
    }];
}

- (void) proSaveData{
    
    //UserInfo$userID{NickName{birthDay{Gender{fullUrlAvatar{accessKey{phoneNumber{firstName{lastName{leftAvatar{
    //topAvatar{widthAvatar{heightAvatar{scaleAvatar{urlThumbnail
    NSString *strSave = @"UserInfo$";
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"%i", self.user.userID]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.nickName]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.birthDay]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.gender]];
//    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", [helperIns encodedBase64:self.user.dataAvatar]]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.urlThumbnail]];

    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.accessKey]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.phoneNumber]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.firstname]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.lastName]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%f", self.user.leftAvatar]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%f", self.user.topAvatar]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%f", self.user.widthAvatar]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%f", self.user.heightAvatar]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%f", self.user.scaleAvatar]];
    strSave = [strSave stringByAppendingString:[NSString stringWithFormat:@"{%@", self.user.urlAvatar]];
    
    [helperIns saveUser:strSave];
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        NSString *strFriend = @"Friends$";
        for (int i = 0; i < count; i++) {
            Friend *_newFriend = [self.friends objectAtIndex:i];
            
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"%i", _newFriend.friendID]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%@", _newFriend.nickName]];
//            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%@", [helperIns encodedBase64:_newFriend.dataAvatar]]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%@", _newFriend.urlThumbnail]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%@", _newFriend.gender]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%f", _newFriend.leftAvatar]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%f", _newFriend.topAvatar]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%f", _newFriend.widthAvatar]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%f", _newFriend.heightAvatar]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%f", _newFriend.scaleAvatar]];
            strFriend = [strFriend stringByAppendingString:[NSString stringWithFormat:@"{%@", _newFriend.urlAvatar]];
            
            strFriend = [strFriend stringByAppendingString:@"}"];
        }
        
        [helperIns saveFriends:strFriend];
    }
}

- (void) sortMessengerFriend{

    if (self.friends != nil) {
        
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[[self.friends objectAtIndex:i] friendMessage] count] > 0) {

                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timeServerMessage"
                                                                           ascending:YES];
                NSArray *descriptors = [NSArray arrayWithObject:descriptor];

                Friend *_friend = [self.friends objectAtIndex:i];
                NSArray *reverseOrder = [[_friend friendMessage] sortedArrayUsingDescriptors:descriptors];
                
                _friend.friendMessage = [[NSMutableArray alloc] initWithArray:reverseOrder];
                
            }
        }
    }
}

- (void) fillAmazonInfomation:(AmazonInfo *)_amazon{
    if (self.sendAmazon != nil) {
        int count = (int)[self.sendAmazon count];
        for (int i = 0; i < count; i++) {
            if ([[self.sendAmazon objectAtIndex:i] keyMessage] == _amazon.keyMessage) {
                NSLog(@"fill amazon info: %i", (int)[self.sendAmazon count]);
                [[self.sendAmazon objectAtIndex:i] setKey:_amazon.key];
                [[self.sendAmazon objectAtIndex:i] setPolicy:_amazon.policy];
                [[self.sendAmazon objectAtIndex:i] setSignature:_amazon.signature];
                [[self.sendAmazon objectAtIndex:i] setAccessKey:_amazon.accessKey];
                [[self.sendAmazon objectAtIndex:i] setUrl:_amazon.url];
                [[self.sendAmazon objectAtIndex:i] setUserReceiveID:_amazon.userReceiveID];
                
                if (!inSendImage) {
                    [self sendImageToAmazon];
                }
            }
        }
    }
}

- (void) sendImageToAmazon{
    if ([self.sendAmazon count] > 0) {
        
        inSendImage = YES;
        
        if ([[self.sendAmazon firstObject] key] == nil) {
            inSendImage = NO;
            NSLog(@"info nil");
        }else{
            NSLog(@"send photo");
            [self uploadAmazon:[self.sendAmazon firstObject] withImage:[[self.sendAmazon firstObject] imgDataSend]];
        }
    }
}

- (void) updateStatusSendImage{
    [self.sendAmazon removeObjectAtIndex:0];
    NSLog(@"Total update amazon: %i", (int)[self.sendAmazon count]);
    if ([self.sendAmazon count] > 0) {
        NSLog(@"Begin call send photo to amazon");
        [self sendImageToAmazon];
    }else{
        inSendImage = NO;
    }
}

/**
 *  ;
 *
 *  @param key       key description
 *  @param accessKey ;
 *  @param policy    ;
 *  @param signature <#signature description#>
 *  @param url       <#url description#>
 */
- (void) uploadAmazon:(AmazonInfo *)info withImage:(NSData *)imgData{
    
    dispatch_queue_t amazonQueue = dispatch_queue_create("com.myApp.myQueue", nil);
    
    dispatch_async(amazonQueue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:info.url]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString *boundary = @"***";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        // key
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:info.key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // content-type
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content-type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // AWSAccessKeyId
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AWSAccessKeyId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:info.accessKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // acl
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"acl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"public-read" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // policy
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"policy\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:info.policy] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // signature
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"signature\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:info.signature] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"jpg"];
        //    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"ios.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imgData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        //return and test
        NSHTTPURLResponse *response=nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        //        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        int code = (int)[response statusCode];
        
        NetworkCommunication *net = [NetworkCommunication shareInstance];
        
        NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADPHOTO{%i}%i}%d<EOF>", code, info.userReceiveID, info.keyMessage];
        NSLog(@"upload amazone success: %@", cmd);
        //        NSString *cmdSendResultUploadAmazon = [self.dataMapIns sendResultUploadAmazon:code withFriendID:info.userReceiveID withKeyMessage:info.keyMessage];
        [net sendData:cmd];
    });
}

#pragma -mark CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError - CLLocationManager");
    [locationManager stopUpdatingHeading];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];

        [[NSUserDefaults standardUserDefaults] setObject:_longitude forKey:@"Longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:_latitude forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//            if (error == nil && [placemarks count] > 0) {
//                placeMark = [placemarks lastObject];
//                
//                NSString *_address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\%@",
//                                      placeMark.subThoroughfare, placeMark.thoroughfare,
//                                      placeMark.postalCode, placeMark.locality,
//                                      placeMark.administrativeArea,
//                                      placeMark.country];
//                
//                NSLog(@"%@", _address);
//            }else{
//                NSLog(@"%@", error.debugDescription);
//            }
//            
//            [locationManager stopUpdatingLocation];
//        }];
    }
}

- (void) updateLocation{
    [locationManager startUpdatingLocation];
}

- (NSString *)getLongitude{
    if (_longitude == nil)
        _longitude = @"0";
    
    return _longitude;
}

- (NSString *)getlatitude{
    if (_latitude == nil)
        _latitude = @"0";
    
    return _latitude;
}

#pragma -mark Receive Location Delegate
- (BOOL) getInReceiveLocation{
    return inReceiveLocation;
}

- (void) processReceiveLocation{
    if (self.receiveLocation != nil && [self.receiveLocation count] > 0) {
        if (!inReceiveLocation) {
            inReceiveLocation = YES;
            ReceiveLocation *_receiveLoca = (ReceiveLocation*)[self.receiveLocation objectAtIndex:0];
            NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _receiveLoca.latitude, _receiveLoca.longitude, @"%7c" , _receiveLoca.latitude, _receiveLoca.longitude];
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //process download
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    
                    ReceiveLocation *_receiveLoca = [self.receiveLocation objectAtIndex:0];
                    
                    if (_receiveLoca.senderID > 0) {
                        Messenger *_messenger = [self getMessageFriendID:_receiveLoca.senderID withKeyMessage:_receiveLoca.keySendMessage];
                        _messenger.thumnail = image;
                        _messenger.dataImage = dataLocation;
                        
                        [self updateMessageFriend:_messenger withFriendID:_receiveLoca.senderID];
                        
                    }else{
                        
                        Messenger *_messenger = [self getMessageFriendID:_receiveLoca.friendID withKeyMessage:_receiveLoca.keySendMessage];
                        _messenger.thumnail = image;
                        _messenger.dataImage = dataLocation;
                        
                        [self updateMessageFriend:_messenger withFriendID:_receiveLoca.friendID];
                    }
                    
                    [self.receiveLocation removeObjectAtIndex:0];
                    inReceiveLocation = NO;
                    [self processReceiveLocation];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadChatView)]) {
                            [self.delegate reloadChatView];
                        }
                        
                    });

                }else{
                    inReceiveLocation = NO;
                }
            }];
        }
    }
}

- (NSString*) geturlThumbnailFriend:(NSString*)_phoneNumber{
    NSString *_url = @"";
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            
            if ([[[self.friends objectAtIndex:i] phoneNumber] isEqualToString:_phoneNumber]) {
                NSLog(@"good");
                _url = [[self.friends objectAtIndex:i] urlThumbnail];
            }
        }
    }
    
    return _url;
}

- (void) addWallData:(DataWall *)_dataWall{
    if (self.walls != nil) {
        int count = (int)[self.walls count];
        BOOL isExits = NO;
        for (int i = 0; i < count; i++) {
            
            if ([((DataWall*)[self.walls objectAtIndex:i]).clientKey isEqualToString: _dataWall.clientKey ]) {
                
                isExits = YES;
                break;
            }
        }
        
        if (!isExits) {
            [self.walls addObject:_dataWall];
        }
    }
}

- (void) addNoisesData:(DataWall *)_dataWall{
    if (self.noises != nil) {
        int count = (int)[self.noises count];
        BOOL isExits = NO;
        for (int i = 0; i < count; i++) {
            
            if ([((DataWall*)[self.noises objectAtIndex:i]).clientKey isEqualToString: _dataWall.clientKey ]) {
                
                isExits = YES;
                break;
            }
        }
        
        if (!isExits) {
            [self.noises addObject:_dataWall];
        }
    }
}
@end
