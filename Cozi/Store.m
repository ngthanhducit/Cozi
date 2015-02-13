//
//  Store.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "Store.h"
#import "SDWebImage/SDWebImageDownloader.h"

@implementation Store

@synthesize user;
@synthesize friends;
@synthesize walls;
@synthesize friendsRequest;
@synthesize sendAmazon;
@synthesize recent;
@synthesize keyGoogleMaps;

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
    
    self.isConnected = NO;
    
    dataLocation = [[NSMutableData alloc] init];
//    self.walls = [NSMutableArray new];
    self.listHistoryPost = [NSMutableArray new];
    self.noises = [NSMutableArray new];
    self.listFollower = [NSMutableArray new];
    self.listFollowing = [NSMutableArray new];
    self.listFollowRequest = [NSMutableArray new];
    self.receiveLocation = [[NSMutableArray alloc] init];
    self.sendAmazon = [[NSMutableArray alloc] init];
    self.recent = [[NSMutableArray alloc] init];
    self.user = [[User alloc] init];
    self.friends = [[NSMutableArray alloc] init];
    self.friendsRequest = [[NSMutableArray alloc] init];
    self.contactList = [NSMutableArray new];
    
    urlAssetsImage = [[NSMutableArray alloc] init];
    assetsThumbnail = [[NSMutableArray alloc] init];
    
    [self loadAssets];
    
    [self addressBookValidation];
    
    _longitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"Longitude"];
    _latitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"];
    
    self.keyGoogleMaps = @"AIzaSyDMAeGF4cEXZKjs9MEsXY6vHci3jIjpfaw";
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
        }else{
            //Show warning
        }
    }else{
        //Show warning
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

- (void) addressBookValidation{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    ABAddressBookRef addressbook;
    
    //    __block BOOL accessGranted = NO;
    addressbook = ABAddressBookCreateWithOptions(nil, nil);
    ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            CFErrorRef error = nil;
            ABAddressBookRef _addressBookRef = ABAddressBookCreateWithOptions(nil, &error);
            
            NSArray* allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
            
            NSMutableArray* _allItems = [[NSMutableArray alloc] initWithCapacity:[allPeople count]]; // capacity is only a rough guess, but better than nothing
            for (id record in allPeople) {
                CFTypeRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonPhoneProperty);
                CFTypeRef lastName = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonLastNameProperty);
                NSString *strLastName = (__bridge NSString*)lastName;
                NSString *strFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonFirstNameProperty);
                NSString *strMidleName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonMiddleNameProperty);
                
                if (strMidleName == nil) {
                    strMidleName = @"";
                }
                
                if (strFirstName == nil) {
                    strFirstName = @"";
                }
                
                if (strLastName == nil) {
                    strLastName = @"";
                }
                
                NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
                CFRelease(phoneProperty);
                for (NSString *phone in phones) {
                    NSString* compositeName = (__bridge NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)record);
                    
                    PersonContact *newPerson = [[PersonContact alloc] init];
                    [newPerson setFirstName:strFirstName];
                    [newPerson setLastName:strLastName];
                    [newPerson setMidName:strMidleName];
                    [newPerson setFullName:[NSString stringWithFormat:@"%@ %@ %@", strFirstName, strMidleName, strLastName]];
                    [newPerson setPhone:phone];
                    
                    [self.contactList addObject:newPerson];
                    
                    NSString *field = [NSString stringWithFormat:@"%@: %@", compositeName, phone];
                    [_allItems addObject:field];
                }
            }
            
            [prefs synchronize];
            CFRelease(addressbook);
            
        }
    });
    
    //    if (ABAddressBookRequestAccessWithCompletion != NULL)
    //    {
    //        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    //        {
    //            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error)
    //                                                     {
    //                                                         accessGranted = granted;
    //                                                         dispatch_semaphore_signal(sema);
    //                                                     });
    //            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //        }
    //        else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    //        {
    //            accessGranted = YES;
    //        }
    //        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusDenied)
    //        {
    //            accessGranted = NO;
    //        }
    //        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusRestricted){
    //            accessGranted = NO;
    //        }
    //        else
    //        {
    //            accessGranted = YES;
    //        }
    //    }
    //    else
    //    {
    //        accessGranted = YES;
    //    }
    //    
    //    if (accessGranted) {
    //        
    //        
    //    }
}

- (NSString*) randomKeyMessenger{
    
    long long timeInterval = (long long)[[NSDate date] timeIntervalSince1970] * 1000.0;
    NSString *_key = [NSString stringWithFormat:@"%i%lld", self.user.userID, timeInterval];
    
    return _key;
    
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
                        if ([((Messenger*)[friend.friendMessage objectAtIndex:j]).keySendMessage isEqualToString: _newMessage.keySendMessage]) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTypeMessage:_newMessage.typeMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStatusMessage:_newMessage.statusMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setSenderID: _newMessage.senderID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setFriendID: _newMessage.friendID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStrMessage: _newMessage.strMessage];
                            [((Messenger*)[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j]) setKeySendMessage:_newMessage.keySendMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeServerMessage: _newMessage.timeServerMessage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeMessage:_newMessage.timeMessage];
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setThumnail:_newMessage.thumnail];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setDataImage:_newMessage.dataImage];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setUrlImage:_newMessage.urlImage];
                            
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

- (void) updateStatusMessageFriend:(int)friendID withKeyMessage:(NSString*)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_time{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    
                    for (int j = 0; j < countMessage; j++) {
                        if ([((Messenger*)[friend.friendMessage objectAtIndex:j]).keySendMessage isEqualToString:_keyMessage]) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setStatusMessage:_statusID];
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setTimeServerMessage: [helperIns convertStringToDate:_time]];
                            
                            break;
                        }
                    }
                }
                
                
                break;
            }
        }
    }
}

- (Messenger *) getMessageFriendID:(int)_friendID withKeyMessage:(NSString*)_keyMessage{
    Messenger *result = nil;
    
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _friendID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([((Messenger*)[friend.friendMessage objectAtIndex:j]).keySendMessage isEqualToString: _keyMessage]) {
                            
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

- (BOOL) deleteMessenger:(int)friendID withKeyMessenger:(NSString*)_keyMessenger{
    
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
                        
                        if ([_messenger.keySendMessage isEqualToString:_keyMessenger]) {
                            
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

- (void) updateStatusMessageFriendWithKey:(int)friendID withMessageID:(NSString*)_keyMessage withStatus:(int)_statusID{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == friendID) {
                Friend *_friend = [self.friends objectAtIndex:i];
                
                if (_friend.friendMessage != nil) {
                    int countMessage = (int)[_friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([((Messenger*)[_friend.friendMessage objectAtIndex:j]).keySendMessage isEqualToString:_keyMessage]) {
                            
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

- (void) updateKeyAmazone:(int)userReceiveID withKeyMessage:(NSString*)_keyMessage withKeyAmazon:(NSString *)_keyAmazon withUrl:(NSString *)_urlImage{
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == userReceiveID) {
                
                Friend *friend = [self.friends objectAtIndex:i];
                
                if (friend.friendMessage != nil) {
                    int countMessage = (int)[friend.friendMessage count];
                    for (int j = 0; j < countMessage; j++) {
                        
                        if ([[[friend.friendMessage objectAtIndex:j] keySendMessage] isEqualToString: _keyMessage]) {
                            
                            [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setAmazonKey:_keyAmazon];
                            
                            if (![_urlImage isEqualToString:@""]) {
                                [[[[self.friends objectAtIndex:i] friendMessage] objectAtIndex:j] setUrlImage:_urlImage];
                            }
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

#pragma mark- Follower Core Data

- (BOOL) addNewFollower:(FollowerUser*)_follower{
    BOOL isExists = [coziCoreDataIns isExistsFollower:_follower.userID withParentID:_follower.parentUserID];
    if (!isExists) {
        return [coziCoreDataIns saveFollower:_follower];
    }
    
    return FALSE;
}

- (void) loadFollower:(int)_userID{
    NSMutableArray *followers = [coziCoreDataIns getFollowerByParentUserID:_userID];
    
    if ([followers count] > 0) {
        int count = (int)[followers count];
        for (int i = 0; i < count; i++) {
            NSManagedObject *_follower = (NSManagedObject*)[followers objectAtIndex:i];
            FollowerUser *_newFollower = [FollowerUser new];
            [_newFollower setUserID:[[_follower valueForKey:@"user_id"] intValue]];
            [_newFollower setFirstName:[_follower valueForKey:@"first_name"]];
            [_newFollower setLastName:[_follower valueForKey:@"last_name"]];
            [_newFollower setUrlAvatar:[_follower valueForKey:@"url_avatar"]];
            [_newFollower setUrlAvatarFull:[_follower valueForKey:@"url_avatar_full"]];
            
            [self.listFollower addObject:_newFollower];
        }
    }

}

- (BOOL) checkFollowerExists:(int)_userID withParentID:(int)_parentID{
    return [coziCoreDataIns isExistsFollower:_userID withParentID:_parentID];
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
                [coziCoreDataIns saveFriend:_friend];
            }
            
            //check Messenger
            if ([[_friend friendMessage] count] > 0) {
                int countMessenger = (int)[_friend.friendMessage count];
                for (int j = 0; j < countMessenger; j++) {
                    Messenger *_messenger = [_friend.friendMessage objectAtIndex:j];
                    BOOL _isExistsMessenger = [coziCoreDataIns isExistsMessenger:_messenger.keySendMessage];
                    if (_isExistsMessenger) {
                        //Update Messenger
                    }else{
                        //Add new Messenger
                        [coziCoreDataIns saveMessenger:_messenger];
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
        
        if (![self.user.urlAvatar isEqualToString:@""]) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.user.urlAvatar] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                if (image && finished) {
                    [self.user setAvatar:image];
                }
                
            }];

        }
        
        [self.user setUrlThumbnail:[_user valueForKey:@"url_thumbnail"]];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.user.urlThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [self.user setThumbnail:image];
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
        UIImage *imgEmptyAvatar = [helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"];
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
            [_newFriend setStatusAddFriend:[[_friend valueForKey:@"status_add_friend"] intValue]];
            [_newFriend setUserName:[_friend valueForKey:@"user_name"]];

            if (![_newFriend.urlThumbnail isEqualToString:@""]) {
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_newFriend.urlThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (image && finished) {
                        _newFriend.thumbnail = image;
                    }
                    
//                    GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
//                    
//                    UIImage *grayscaleImage = [grayscaleFilter imageByFilteringImage:image];
//                    
//                    [_newFriend setThumbnailOffline:grayscaleImage];
                    
                }];
                
            }else{
                [_newFriend setThumbnail:imgEmptyAvatar];
                [_newFriend setThumbnailOffline:imgEmptyAvatar];
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
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
//                        [_newMessenger setUrlImage:[messengerObj valueForKey:@"str_messenger"]];
                        
//                        __weak NSString *strImage = [messengerObj valueForKey:@"strImage"];
//                        
//                        __weak NSData *dataImage = [helperIns decodeBase64:strImage];
//                        _newMessenger.dataImage = dataImage;
                        
                        [_newMessenger setUserID:[[messengerObj valueForKey:@"user_id"] intValue]];
                        
                        [_newFriend.friendMessage addObject:_newMessenger];
                    }else if (_type == 2){
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessenger.latitude, _newMessenger.longitude, @"%7c" , _newMessenger.latitude, _newMessenger.longitude];
                        
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            _newMessenger.thumnail = image;
                        }];
                        
                        [_newFriend.friendMessage addObject:_newMessenger];
                    }else{
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
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
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
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
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
                        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessenger.latitude, _newMessenger.longitude, @"%7c" , _newMessenger.latitude, _newMessenger.longitude];
                        
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            _newMessenger.thumnail = image;
                        }];
                        
                        [_friend.friendMessage addObject:_newMessenger];
                    }else{
                        Messenger *_newMessenger = [Messenger new];
                        [_newMessenger setAmazonKey:[messengerObj valueForKey:@"amazon_key"]];
                        [_newMessenger setFriendID:[[messengerObj valueForKey:@"friend_id"] intValue]];
                        [_newMessenger setKeySendMessage:[messengerObj valueForKey:@"key_send_message"]];
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
//                        [_newMessenger setIsTimeOut:[messengerObj valueForKey:@"is_timeout"]];
                        
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
            if ([[[self.sendAmazon objectAtIndex:i] keyMessage] isEqualToString:_amazon.keyMessage]) {
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
    
    if ([self.sendAmazon count] > 0) {
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
        
        NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADPHOTO{%i}%i}%@<EOF>", code, info.userReceiveID, info.keyMessage];
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

//        }];
        
        [locationManager stopUpdatingLocation];
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
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                if (finished) {
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
                
                _url = [[self.friends objectAtIndex:i] urlThumbnail];
                
            }
        }
    }
    
    return _url;
}

- (void) getPostHistory:(int)_userPostID{
    NSMutableArray *result = [coziCoreDataIns getPostsByUserID:_userPostID];
    if (result) {
        int count = (int)[result count];
        for (int i = 0; i < count; i++) {
            NSManagedObject *_post = [result objectAtIndex:i];
            DataWall *_newPost = [DataWall new];
            [_newPost setUserPostID:[[_post valueForKey:@"user_post_id"] intValue]];
            [_newPost setClientKey:[_post valueForKey:@"client_key"]];
            [_newPost setCodeType:[[_post valueForKey:@"code_type"] intValue]];
            [_newPost setContent:[_post valueForKey:@"content_post"]];
            [_newPost setFirstName:[_post valueForKey:@"first_name"]];
            [_newPost setIsLike:[[_post valueForKey:@"is_like"] boolValue]];
            [_newPost setLastName:[_post valueForKey:@"last_name"]];
            NSString *location = [_post valueForKey:@"location"];
            NSArray *subLocation = [location componentsSeparatedByString:@"|"];
            if ([subLocation count] == 2) {
                _newPost.longitude = [subLocation objectAtIndex:0];
                _newPost.latitude = [subLocation objectAtIndex:1];
            }

            [_newPost setTimeLike:[_post valueForKey:@"time_like"]];
            [_newPost setTime:[_post valueForKey:@"time_post"]];
            [_newPost setUrlAvatarFull:[_post valueForKey:@"url_avatar_full"]];
            [_newPost setUrlAvatarThumb:[_post valueForKey:@"url_avatar_thumb"]];
            [_newPost setUrlFull:[_post valueForKey:@"url_image_full"]];
            [_newPost setUrlThumb:[_post valueForKey:@"url_image_thumb"]];
            [_newPost setVideo:[_post valueForKey:@"url_video"]];

            [self.listHistoryPost insertObject:_newPost atIndex:0];
        }
    }
}

- (DataWall *) getWall:(NSString*)_clientKey withUserPost:(int)_userPostID{
    DataWall *result = nil;
    if (self.walls != nil) {
        int count = (int)[self.walls count];
        for (int i = 0; i < count; i++) {
            
            if ([[[self.walls objectAtIndex:i] clientKey] isEqualToString:_clientKey] && [[self.walls objectAtIndex:i] userPostID] == _userPostID) {
                
                result = [self.walls objectAtIndex:i];
                break;
            }
        }
    }
    
    return result;
}

- (void) insertWallData:(DataWall*)_dataWall{
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
            [self.walls insertObject:_dataWall atIndex:0];
            //insert to coredata
            [coziCoreDataIns savePosts:_dataWall];
        }
    }
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

- (void) updateWall:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall *)_wall{
    
    if (self.walls != nil) {
        int count = (int)[self.walls count];
        for (int i = 0; i < count; i++) {
            if ([[[self.walls objectAtIndex:i] clientKey] isEqualToString:_clientKey] && [[self.walls objectAtIndex:i] userPostID] == _userPostID) {
                
                [[self.walls objectAtIndex:i] setUserPostID:_wall.userPostID];
                [[self.walls objectAtIndex:i] setContent:_wall.content];
                [[self.walls objectAtIndex:i] setImages:_wall.images];
                [[self.walls objectAtIndex:i] setVideo:_wall.video];
                [[self.walls objectAtIndex:i] setLongitude:_wall.longitude];
                [[self.walls objectAtIndex:i] setLatitude:_wall.latitude];
                [[self.walls objectAtIndex:i] setTime:_wall.time];
                [[self.walls objectAtIndex:i] setClientKey:_wall.clientKey];
                [[self.walls objectAtIndex:i] setFirstName:_wall.firstName];
                [[self.walls objectAtIndex:i] setLastName:_wall.lastName];
                [[self.walls objectAtIndex:i] setComments:_wall.comments];
                [[self.walls objectAtIndex:i] setLikes:_wall.likes];
//                [[self.walls objectAtIndex:i] setTypePost:_wall.codeType];
                [[self.walls objectAtIndex:i] setIsLike:_wall.isLike];
                [[self.walls objectAtIndex:i] setTimeLike:_wall.timeLike];
                
                break;
                
            }
        }
    }
}

- (void) updateNoise:(NSString*)_clientKey withUserPost:(int)_userPostID withData:(DataWall*)_wall{
    if (self.noises != nil) {
        int count = (int)[self.noises count];
        for (int i = 0; i < count; i++) {
            if ([[[self.noises objectAtIndex:i] clientKey] isEqualToString:_clientKey] && [[self.noises objectAtIndex:i] userPostID] == _userPostID) {
                
                [[self.noises objectAtIndex:i] setUserPostID:_wall.userPostID];
                [[self.noises objectAtIndex:i] setContent:_wall.content];
                [[self.noises objectAtIndex:i] setImages:_wall.images];
                [[self.noises objectAtIndex:i] setVideo:_wall.video];
                [[self.noises objectAtIndex:i] setLongitude:_wall.longitude];
                [[self.noises objectAtIndex:i] setLatitude:_wall.latitude];
                [[self.noises objectAtIndex:i] setTime:_wall.time];
                [[self.noises objectAtIndex:i] setClientKey:_wall.clientKey];
                [[self.noises objectAtIndex:i] setFirstName:_wall.firstName];
                [[self.noises objectAtIndex:i] setLastName:_wall.lastName];
                [[self.noises objectAtIndex:i] setComments:_wall.comments];
                [[self.noises objectAtIndex:i] setLikes:_wall.likes];
//                [[self.noises objectAtIndex:i] setTypePost:_wall.codeType];
                [[self.noises objectAtIndex:i] setIsLike:_wall.isLike];
                [[self.noises objectAtIndex:i] setTimeLike:_wall.timeLike];
                
                break;
                
            }
        }
    }
}

- (BOOL) isFollowing:(int)_userID{

    if (self.listFollowing) {
        int count = (int)[self.listFollowing count];
        for (int i = 0; i < count; i++) {
            if ([[self.listFollowing objectAtIndex:i] userID] == _userID) {
                
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL) isFollower:(int)_userID{
    
    if (self.listFollower) {
        int count = (int)[self.listFollower count];
        for (int i = 0; i < count; i++) {
            if ([[self.listFollower objectAtIndex:i] userID] == _userID) {
                
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL) isFriend:(int)_userID{
    if (self.friends) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _userID) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void) loadFriendRequest:(int)_userID{
    NSMutableArray *_friendRequest = [coziCoreDataIns getFriendRequestWithUserID:_userID];
    if (_friendRequest) {
        int count = (int)[_friendRequest count];
        for (int i = 0; i < count; i++) {
            NSManagedObject *_friend = (NSManagedObject*)[_friendRequest objectAtIndex:i];
            UserSearch *_request = [UserSearch new];
            [_request setUserID:[[_friend valueForKey:@"user_id"] intValue]];
            [_request setFriendID:[[_friend valueForKey:@"friend_request_id"] intValue]];
            [_request setNickName:[_friend valueForKey:@"nick_name"]];
            [_request setFirstName:@""];
            [_request setLastName:@""];
            [_request setUrlAvatar:[_friend valueForKey:@"url_thumbnail"]];
            [_request setUrlAvatarFull:[_friend valueForKey:@"url_avatar"]];
            [_request setUserName:[_friend valueForKey:@"user_name"]];
            
            [self.friendsRequest addObject:_request];
        }
    }
}

- (void) removeFriendRequest:(int)_friendRequestID{
    if (self.friendsRequest) {
        int count = (int)[self.friendsRequest count];
        for (int i = 0; i < count; i++) {
            if ([[self.friendsRequest objectAtIndex:i] friendID] == _friendRequestID) {
                [self.friendsRequest removeObjectAtIndex:i];
                
                break;
            }
        }
    }
}

- (void) progressResultAddFriend:(int)_friendID withIsAllow:(BOOL)_isAllow{
    if (self.friends) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _friendID) {
                
                if ([[self.friends objectAtIndex:i] statusAddFriend] == 1) { //check Status add friend in request
                    
                    if (_isAllow) {
                        [[self.friends objectAtIndex:i] setStatusAddFriend:0];
                        
                        [coziCoreDataIns updateFriend:[self.friends objectAtIndex:i]];
                    }
                    
                    if (!_isAllow) {
                        [coziCoreDataIns deleteFriend:_friendID withUserID:self.user.userID];
                        
                        [self.friends removeObjectAtIndex:i];
                    }
                    
                }
                
                break;
                
            }
        }
    }
}
@end
