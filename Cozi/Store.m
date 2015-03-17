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
    
    dicColor = [NSDictionary new];
    
    dataLocation = [[NSMutableData alloc] init];
    self.listHistoryPost = [NSMutableArray new];
    self.walls = [NSMutableArray new];
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

- (void) initColor{
    
//    dicColor setValue:<#(id)#> forKey:<#(NSString *)#>
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
            
            if (group == nil) {
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
    NSLog(@"Total Image send: %i", (int)[self.sendAmazon count]);
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
 *  @param signature ;
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
        
        if (info.typeAmazon == 0) {
            NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADPHOTO{%i}%i}%@<EOF>", code, info.userReceiveID, info.keyMessage];
            NSLog(@"upload amazone success: %@", cmd);
            
            [net sendData:cmd];
        }else if (info.typeAmazon == 1){
            NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADGROUPPHOTO{%i}%i}%@<EOF>", code, info.userReceiveID, info.keyMessage];
            NSLog(@"upload group amazone success: %@", cmd);
            
            [net sendData:cmd];
        }

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
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placeMark = [placemarks lastObject];
                
                NSString *_address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\%@",
                                      placeMark.subThoroughfare, placeMark.thoroughfare,
                                      placeMark.postalCode, placeMark.locality,
                                      placeMark.administrativeArea,
                                      placeMark.country];
                
                NSLog(@"%@", _address);
                //Notification update location
                if (completeUpdate) {
                    completeUpdate(YES);
                }
            }else{
                NSLog(@"%@", error.debugDescription);
            }

        }];
        
        [locationManager stopUpdatingLocation];
    }
}

- (void) updateLocation{
    [locationManager startUpdatingLocation];
}

- (void) updateLocationcomplete:(void (^)(BOOL finish))completeHandler{
    [locationManager startUpdatingLocation];
//    completeHandler = completeUpdate;
    completeUpdate = completeHandler;
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
                    
                    Messenger *_messenger = [self getMessageFriendID:_receiveLoca.senderID withKeyMessage:_receiveLoca.keySendMessage];
                    
                    UIImage *newImageSize = [helperIns resizeImage:image resizeSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
                    
                    if (_receiveLoca.senderID > 0) {
                        
                        _messenger.thumnail = newImageSize;
                        _messenger.dataImage = dataLocation;
                        
                        [self updateMessageFriend:_messenger withFriendID:_receiveLoca.senderID];
                        
                    }else{
                        
                        Messenger *_messenger = [self getMessageFriendID:_receiveLoca.friendID withKeyMessage:_receiveLoca.keySendMessage];
                        //Resize Image
                        _messenger.thumnail = newImageSize;
                        _messenger.dataImage = dataLocation;
                        
                        [self updateMessageFriend:_messenger withFriendID:_receiveLoca.friendID];
                    }
                    
                    Messenger *_notifyMessage = [self getMessageFriendID:_receiveLoca.friendID withKeyMessage:_receiveLoca.keySendMessage];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadChatView:)]) {
                        [self.delegate reloadChatView:_notifyMessage];
                    }
                    
                    [self.receiveLocation removeObjectAtIndex:0];
                    inReceiveLocation = NO;
                    [self processReceiveLocation];
                    
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

- (UIImage*) getAvatarThumbFriend:(int)_friendID{
    UIImage *img;
    if (self.friends != nil) {
        int count = (int)[self.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.friends objectAtIndex:i] friendID] == _friendID) {
                img = ((Friend*)[self.friends objectAtIndex:i]).thumbnail;
            }
        }
    }
    
    return img;
}

- (UIImage*) renderGroupImageWithFriend:(NSMutableArray*)_friends{
    CGSize newSize = { 160, 160 };
    
    NSMutableArray *listImage = [NSMutableArray new];
    int index = (int)([_friends count] - 1);
    
    while ([listImage count] < 3) {
        
        if (index < 0) {
            break;
        }
        
        Friend *_friend = [_friends objectAtIndex:index];
        
        BOOL isExists = FALSE;
        int count = (int)[listImage count];
        for (int i = 0; i < count; i++) {
            if ([[listImage objectAtIndex:i] friendID] == _friend.friendID) {
                isExists = YES;
                break;
            }
        }
        
        if (!isExists) {
            [listImage addObject:_friend];
        }
        
        index--;
    }
    
    if ([listImage count] == 3) {
        UIImage *img1 = [(Friend*)[listImage objectAtIndex:0] thumbnail];
        UIImage *img2 = [(Friend*)[listImage objectAtIndex:1] thumbnail];
        UIImage *img3 = [(Friend*)[listImage objectAtIndex:2] thumbnail];
        
        UIImage *img1Crop = [helperIns cropImage:img1 withFrame:CGRectMake(img1.size.width / 4, 0, img1.size.width / 2, img1.size.height)];
        
        UIGraphicsBeginImageContext(newSize);
        
        [img1Crop drawInRect:CGRectMake(0, 0, img1Crop.size.width - 1, img1Crop.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [img2 drawInRect:CGRectMake(81, 0, 79, 79) blendMode:kCGBlendModeNormal alpha:1.0f];
        [img3 drawInRect:CGRectMake(81, 82, 79, 79) blendMode:kCGBlendModeNormal alpha:1.0f];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        return newImage;
    }
    
    return nil;
}

- (UIImage*) renderGroupImageWithMessage:(NSMutableArray*)_messenger{
    CGSize newSize = { 160, 160 };
    
    NSMutableArray *listImage = [NSMutableArray new];
    int index = (int)([_messenger count] - 1);
    
    while ([listImage count] < 4) {
        
        if (index < 0) {
            break;
        }
        
        Messenger *_sms = [_messenger objectAtIndex:index];
        Friend *_friend = [self getFriendByID:_sms.friendID];
        
        if (_friend && _friend.friendID > 0) {
            BOOL isExists = FALSE;
            int count = (int)[listImage count];
            for (int i = 0; i < count; i++) {
                if ([[listImage objectAtIndex:i] friendID] == _friend.friendID) {
                    isExists = YES;
                    break;
                }
            }
            
            if (!isExists) {
                [listImage addObject:_friend];
            }
        }
        
        index--;
    }
    
    if ([listImage count] == 3) {
        UIImage *img1 = [[listImage objectAtIndex:0] thumnail];
        UIImage *img2 = [[listImage objectAtIndex:1] thumnail];
        UIImage *img3 = [[listImage objectAtIndex:2] thumnail];
        
        UIImage *img1Crop = [helperIns cropImage:img1 withFrame:CGRectMake(img1.size.width / 4, 0, img1.size.width / 2, img1.size.height)];
        
        UIGraphicsBeginImageContext(newSize);
        
        [img1Crop drawInRect:CGRectMake(0, 0, img1Crop.size.width, img1Crop.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [img2 drawInRect:CGRectMake(81, 0, 79, 79) blendMode:kCGBlendModeNormal alpha:1.0f];
        [img3 drawInRect:CGRectMake(81, 80, 79, 80) blendMode:kCGBlendModeNormal alpha:1.0f];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        return newImage;
    }
    
    return nil;
}

#pragma -mark GROUP CHAT
- (Recent *) getRecentByRecentID:(int)_recentID{
    Recent *result = nil;
    
    if (self.recent) {
        int count = (int)[self.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recent objectAtIndex:i] recentID] == _recentID) {
                result = [self.recent objectAtIndex:i];
                
                break;
            }
        }
    }
    
    return result;
}

- (Recent *) getGroupChatByGroupID:(int)groupID{
    Recent *result = nil;
    
    if (self.recent) {
        int count = (int)[self.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recent objectAtIndex:i] typeRecent] == 1) {
                if ([[self.recent objectAtIndex:i] recentID] == groupID) {
                    result = [self.recent objectAtIndex:i];
                    
                    break;
                }
            }
        }
    }
    
    return result;
}

- (Messenger *) getMessageGroupID:(int)groupID withKeyMessage:(NSString*)keySendMessage{
    Messenger *result = nil;
    
    if (self.recent) {
        int count = (int)[self.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recent objectAtIndex:i] typeRecent] == 1) {
                if ([[self.recent objectAtIndex:i] recentID] == groupID) {
                    if ([[[self.recent objectAtIndex:i] messengerRecent] count] > 0) {
                        int countMessage = (int)[[[self.recent objectAtIndex:i] messengerRecent] count];
                        for (int j = 0; j < countMessage; j++) {
                            Messenger *_message = [[[self.recent objectAtIndex:i] messengerRecent] objectAtIndex:j];
                            
                            if ([_message.keySendMessage isEqualToString:keySendMessage]) {
                                result = _message;
                                
                                break;
                            }
                        }
                    }
                    
                    break;
                }
            }
        }
    }
    
    return result;
}

- (void) updateStatusGroupMessage:(int)groupID withKeyMessage:(NSString*)_keyMessage withStatus:(int)_statusID withTime:(NSString*)_time{
    if (self.recent) {
        int count = (int)[self.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recent objectAtIndex:i] recentID] == groupID) {
                if ([[[self.recent objectAtIndex:i] messengerRecent] count] > 0) {
                    int countMessage = (int)[[[self.recent objectAtIndex:i] messengerRecent] count];
                    for (int j = 0; j < countMessage; j++) {
                        Messenger *_message = [[[self.recent objectAtIndex:i] messengerRecent] objectAtIndex:j];
                        if (_message.keySendMessage == _keyMessage) {
                            [_message setStatusMessage:_statusID];
                            [_message setTimeServerMessage:[helperIns convertStringToDate:_time]];
                            
                            break;
                        }
                    }
                }
                
                break;
            }
        }
    }
}

- (void) updateKeyAmazoneForGroupChat:(int)_groupID withKeyMessage:(NSString*)_keyMessage withKeyAmazon:(NSString *)_keyAmazon withUrl:(NSString *)_urlImage{
    if (self.recent) {
        int count = (int)[self.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.recent objectAtIndex:i] recentID] == _groupID) {
                
                if ([[[self.recent objectAtIndex:i] messengerRecent] count] > 0) {
                    int countMessage = (int)[[[self.recent objectAtIndex:i] messengerRecent] count];
                    for (int j = 0; j < countMessage; j++) {
                        if ([[[[[self.recent objectAtIndex:i] messengerRecent] objectAtIndex:j] keyMessage] isEqualToString:_keyMessage]) {
                            
                            [[[[self.recent objectAtIndex:i] messengerRecent] objectAtIndex:j] setAmazonKey:_keyMessage];
                            [[[[self.recent objectAtIndex:i] messengerRecent] objectAtIndex:j] setUrlImage:_urlImage];
                            
                            break;
                        }
                    }
                }
                break;
            }
        }
    }
}

- (void) playSoundPress{
    AudioServicesPlaySystemSound(1105);
}

- (void) playSoundTouchOne{
    AudioServicesPlaySystemSound(1200);
}
@end
