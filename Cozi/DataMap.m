//
//  DataMap.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "DataMap.h"
#import "SDWebImage/SDWebImageDownloader.h"

@implementation DataMap

+ (id) shareInstance{
    static DataMap   *shareIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns = [[DataMap alloc] init];
    });
    
    return shareIns;
}

- (id) init{
    self = [super init];
    if (self) {
        [self setupVariable];
    }
    
    return self;
}

- (void) setupVariable{
    coziCoreDataIns = [CoziCoreData shareInstance];
    self.helperIns = [Helper shareInstance];
    self.storeIns = [Store shareInstance];
}

- (NSString*) loginCommand:(NSString*) phone withHashPass:(NSString*)hashPass withToken:(NSString*)deviceToken withLongitude:(NSString*)longitude withLatitude:(NSString*)latitude{
    return [NSString stringWithFormat:@"LOGIN{%@}%@}%@}%@}%@}1<EOF>", phone, hashPass, deviceToken, longitude, latitude];
}

- (NSString *) cmdNewUser:(NewUser*)_newUser{
    NSString *cmd = [NSString stringWithFormat:@"NEWUSER{%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}%@}1¿",
                     [self.helperIns encodedBase64:[_newUser.nickName dataUsingEncoding:NSUTF8StringEncoding]],
                     _newUser.birthDay, _newUser.birthMonth, _newUser.birthYear,
                     [self.helperIns encodedBase64:[_newUser.gender dataUsingEncoding:NSUTF8StringEncoding]] ,
                     [self.helperIns encodedBase64:[_newUser.avatarKey dataUsingEncoding:NSUTF8StringEncoding]],
                     [self.helperIns encodedBase64:[_newUser.avatarFullKey dataUsingEncoding:NSUTF8StringEncoding]],
                     [self.helperIns encodedBase64:[_newUser.password dataUsingEncoding:NSUTF8StringEncoding]],
                     _newUser.deviceToken, _newUser.longitude, _newUser.latitude,
                     [self.helperIns encodedBase64:[_newUser.userName dataUsingEncoding:NSUTF8StringEncoding]],
                     [self.helperIns encodedBase64:[_newUser.firstName dataUsingEncoding:NSUTF8StringEncoding]],
                     [self.helperIns encodedBase64:[_newUser.lastName dataUsingEncoding:NSUTF8StringEncoding]],
                     _newUser.leftAvatar, _newUser.topAvatar, _newUser.widthAvatar, _newUser.heightAvatar, _newUser.scaleAvatar];
    
    if (_newUser.contacts != nil) {
        int count = (int)[_newUser.contacts count];
        for (int i = 0; i < count; i++) {
            PersonContact *_person = (PersonContact*)[_newUser.contacts objectAtIndex:i];

            NSString *enFullName = [self.helperIns encodedBase64:[_person.fullName dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *cmdContact = [[NSString stringWithFormat:@"%@}%@µ", enFullName, _person.phone] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            cmd = [cmd stringByAppendingString:cmdContact];
        }
    }
    
    cmd = [cmd stringByAppendingString:@"<EOF>"];
    
    return cmd;
}

- (int) mapLogin:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subCommand = [str componentsSeparatedByString:@"{"];
    if ([subCommand count] == 2) {
        if ([[subCommand objectAtIndex:1] length] > 0) {
            NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
            if ([subData count] > 0) {
                //Map user info
                if ([[subData objectAtIndex:0] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:0] componentsSeparatedByString:@"}"];
                    if ([subParameter count] > 1) {
                        [self.storeIns.user setUserID:[[subParameter objectAtIndex:0] intValue]];
                        [self.storeIns.user setNickName:[self.helperIns decode:[subParameter objectAtIndex:1]]];
                        [self.storeIns.user setBirthDay:[subParameter objectAtIndex:2]];
                        [self.storeIns.user setGender:[self.helperIns decode:[subParameter objectAtIndex:3]]];
                        
                        NSString *strThumbnail = [self.helperIns decode:[subParameter objectAtIndex:4]];
                       
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            
                            if (image && finished) {
                                [self.storeIns.user setThumbnail:image];
                                
                                NSArray *subUrl = [strThumbnail componentsSeparatedByString:@"/"];
                                [self.helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                            }

                        }];
                        
                        [self.storeIns.user setUrlThumbnail:strThumbnail];
                        
                        [self.storeIns.user setAccessKey:[subParameter objectAtIndex:5]];
                        [self.storeIns.user setPhoneNumber:[subParameter objectAtIndex:6]];
                        [self.storeIns.user setFirstname:[self.helperIns decode:[subParameter objectAtIndex:7]]];
                        [self.storeIns.user setLastName:[self.helperIns decode:[subParameter objectAtIndex:8]]];
                        [self.storeIns.user setLeftAvatar:[[subParameter objectAtIndex:9] floatValue]];
                        [self.storeIns.user setTopAvatar: [[subParameter objectAtIndex:10] floatValue]];
                        [self.storeIns.user setWidthAvatar: [[subParameter objectAtIndex:11] floatValue]];
                        [self.storeIns.user setHeightAvatar: [[subParameter objectAtIndex:12] floatValue]];
                        [self.storeIns.user setScaleAvatar: [[subParameter objectAtIndex:13] floatValue]];
                        
                        NSString *strAvatar = [self.helperIns decode:[subParameter objectAtIndex:14]];
                        
                        if (![strAvatar isEqualToString:@""]) {
                            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strAvatar] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                
                                if (image && finished) {
                                    [self.storeIns.user setAvatar:image];
                                    
                                    NSArray *subUrl = [strAvatar componentsSeparatedByString:@"/"];
                                    [self.helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                                }
                                
                            }];
                        }else{
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                            
                        }
                        
                        NSDate *serverDate = [self.helperIns convertStringToDate:[subParameter objectAtIndex:15]];
                        
                        [self.storeIns setTimeServer:serverDate];
                        [self.storeIns.user setUrlAvatar:strAvatar];
                        [self.storeIns.user setIsPublic:[[subParameter objectAtIndex:16] intValue]];
                        [self.storeIns.user setCountPosts:[[subParameter objectAtIndex:17] intValue]];
                    }
                }
                
                //map list friend
                if ([[subData objectAtIndex:1] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        
                        for (int i = 0; i < count; i++) {
                            
                            NSArray *subFriend = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFriend count] > 1) {
                                Friend *_newFriend = [[Friend alloc] init];
                                [_newFriend setFriendID:[[subFriend objectAtIndex:0] intValue]];
                                [_newFriend setNickName:[self.helperIns decode:[subFriend objectAtIndex:1]]];
                                [_newFriend setUserName:[self.helperIns decode:[subFriend objectAtIndex:1]]];
                                [_newFriend setGender:[self.helperIns decode:[subFriend objectAtIndex:3]]];
                                [_newFriend setStatusAddFriend:0];
                                
                                NSString *strThumbnail = [self.helperIns decode:[subFriend objectAtIndex:2]];
                                
                                if (![strThumbnail isEqualToString:@""]) {
                                    
                                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strThumbnail] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        
                                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                        if (image && finished) {
                                            _newFriend.thumbnail = image;
                                            
                                            NSArray *subUrl = [strThumbnail componentsSeparatedByString:@"/"];
                                            [self.helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                                        }
                                    }];
                                    
                                }else{
                                    
                                    UIImage *imgThumbnail = [self.helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"];
                                    [_newFriend setThumbnail:imgThumbnail];
                                    [_newFriend setThumbnailOffline:imgThumbnail];
                                    
                                }
                                
                                [_newFriend setUrlThumbnail:strThumbnail];
                                
                                if ([[[subFriend objectAtIndex:9] uppercaseString] isEqualToString:@"TRUE"]) {
                                    [_newFriend setStatusFriend:1];
                                }else{
                                    [_newFriend setStatusFriend:0];
                                }
                                
                                [_newFriend setUserID:self.storeIns.user.userID];
                                [_newFriend setPhoneNumber:[subFriend objectAtIndex:11]];
                                
                                [self.storeIns.friends addObject:_newFriend];
                            }
                        }
                    }
                }
                
                //map message offline
                if ([[subData objectAtIndex:2] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:2] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        for (int i = 0; i < count; i++) {
                            NSArray *subMessageOffline = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subMessageOffline count] > 1) {
                                
                                Messenger *_newMessage = [[Messenger alloc] init];
                                [_newMessage setSenderID:[[subMessageOffline objectAtIndex:0] intValue]];
                                [_newMessage setFriendID:[[subMessageOffline objectAtIndex:0] intValue]];
                                [_newMessage setStrMessage:[self.helperIns decode:[subMessageOffline objectAtIndex:1]]];
                                [_newMessage setKeySendMessage:[subMessageOffline objectAtIndex:2]];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setTypeMessage:0];
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subMessageOffline objectAtIndex:3]];
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                                
                                [_newMessage setTimeMessage: [self.helperIns getDateFormatMessage:_dateTimeMessage]];
                                [_newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subMessageOffline objectAtIndex:3]]];
                                
                                [_newMessage setTimeOutMessenger:[[subMessageOffline objectAtIndex:4] intValue]];
                                
                                [self addMessageToFriend:_newMessage];
                                
                                [coziCoreDataIns saveMessenger:_newMessage];
                                
                            }
                        }
                    }
                }
                
                //map message photo offline
                if ([[subData objectAtIndex:3] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:3] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        for (int i = 0 ; i < count; i++) {
                            NSArray *subPhotoOffline = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subPhotoOffline count] > 1) {
                                Messenger *_messagePhoto = [[Messenger alloc] init];
                                [_messagePhoto setSenderID:[[subPhotoOffline objectAtIndex:0] intValue]];
                                [_messagePhoto setFriendID:[[subPhotoOffline objectAtIndex:0] intValue]];
                                [_messagePhoto setStrMessage:[self.helperIns decode:[subPhotoOffline objectAtIndex:1]]];
                                [_messagePhoto setUrlImage:[self.helperIns decode:[subPhotoOffline objectAtIndex:1]]];
                                [_messagePhoto setTypeMessage:1];
                                [_messagePhoto setStatusMessage:1];
                                [_messagePhoto setKeySendMessage:[subPhotoOffline objectAtIndex:2]];
                                
//                                NSURL *imgUrl = [NSURL URLWithString:_messagePhoto.strMessage];
//                                NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
//                                UIImage *img = [UIImage imageWithData:imgData];
                                
//                                [_messagePhoto setThumnail:img];
//                                [_messagePhoto setDataImage:imgData];
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subPhotoOffline objectAtIndex:3]];
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                                [_messagePhoto setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                                [_messagePhoto setTimeServerMessage: [self.helperIns convertStringToDate:[subPhotoOffline objectAtIndex:3]]];
                                [_messagePhoto setTimeOutMessenger:[[subPhotoOffline objectAtIndex:4] intValue]];
                                
                                [self addMessageToFriend:_messagePhoto];
                                
                                [coziCoreDataIns saveMessenger:_messagePhoto];
                            }
                        }
                    }
                }
                
                //map list friend request
                if ([[subData objectAtIndex:4] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:4] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFriendRequest = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFriendRequest count] > 1) {

                                Friend *_friend = [Friend new];
                                _friend.isFriendWithYour = 1;
                                [_friend setUserID:self.storeIns.user.userID];
                                _friend.friendID = [[subFriendRequest objectAtIndex:0] intValue];
                                [_friend setNickName:[self.helperIns decode:[subFriendRequest objectAtIndex:1]]];
                                [_friend setUrlThumbnail:[self.helperIns decode:[subFriendRequest objectAtIndex:2]]];
                                [_friend setUrlAvatar:[self.helperIns decode:[subFriendRequest objectAtIndex:3]]];
                                
                                //Add Default Messenger
                                NSString *_keyMessage = [self.storeIns randomKeyMessenger];
                                Messenger *_newMessage = [[Messenger alloc] init];
                                [_newMessage setStrMessage: [NSString stringWithFormat:@"%@ %@", _friend.nickName, @"want to chat with you"]];
                                _newMessage.senderID = _friend.friendID;
                                [_newMessage setTypeMessage:0];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setKeySendMessage:_keyMessage];
                                [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
                                [_newMessage setDataImage:nil];
                                [_newMessage setThumnail:nil];
                                [_newMessage setFriendID:_friend.friendID];
                                [_newMessage setUserID:self.storeIns.user.userID];
                                
                                _friend.friendMessage = [NSMutableArray new];
                                [_friend.friendMessage addObject:_newMessage];
                                
                                [self progressRecent:_friend];
                                
                            }
                        }
                    }
                }
                
                //Map IsRead Message Offline
                if ([[subData objectAtIndex:5] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:5] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];

                            }

                        }
                    }
                }
                
                //Map IsRead Photo Offline
                if ([[subData objectAtIndex:6] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:5] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];
                                
                            }
                        }
                    }
                    
                }
                
                //Map Location Offline
                if ([[subData objectAtIndex:7] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:7] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count =(int)[subParameter count];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        for (int i = 0; i < count; i++) {
                            NSArray *subLocation = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subLocation count] > 1) {
                                Messenger *_newMessage = [[Messenger alloc] init];
                                
                                [_newMessage setThumnail:nil];
                                [_newMessage setDataImage:nil];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setTypeMessage:2];
                                [_newMessage setSenderID:[[subLocation objectAtIndex:0] intValue]];
                                [_newMessage setFriendID:[[subLocation objectAtIndex:0] intValue]];
                                _newMessage.longitude = [subLocation objectAtIndex:1];
                                _newMessage.latitude = [subLocation objectAtIndex:2];
                                _newMessage.keySendMessage = [subLocation objectAtIndex:3];
                                
                                NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessage.latitude, _newMessage.longitude, @"%7c" , _newMessage.latitude, _newMessage.longitude];
                                _newMessage.urlImage = url;
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subLocation objectAtIndex:4]];
                                
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                                
                                _newMessage.timeServerMessage = [self.helperIns convertStringToDate:[subLocation objectAtIndex:4]];
                                _newMessage.timeMessage = [self.helperIns convertNSDateToString:_dateTimeMessage];
                                _newMessage.timeOutMessenger = [[subLocation objectAtIndex:5] intValue];
                                
                                [self addMessageToFriend:_newMessage];
                            }
                        }
                    }
                }
                
                //Map IsRead Location Offline
                if ([[subData objectAtIndex:8] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:5] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];

                            }
                            
                        }
                    }
                    
                }
                
                //Map Message Remove Offline
                if ([[subData objectAtIndex:9] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:9] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                int userReceiveID = [[subValue objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subValue objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                            }

                        }
                    }
                    
                }
                
                //Map Photo Remove Offline
                if ([[subData objectAtIndex:10] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:9] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                int userReceiveID = [[subValue objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subValue objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                
                //Map Location Remove Offline
                if ([[subData objectAtIndex:11] length] > 1) {
                    
                    NSArray *subParameter = [[subData objectAtIndex:9] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                int userReceiveID = [[subValue objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subValue objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
                
                //Map Follower(Follow This User)
                if ([[subData objectAtIndex:12] length] > 1) {
                    //save Follower
                    NSArray *subParameter = [[subData objectAtIndex:12] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFollower = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFollower count] > 1) {
                                FollowerUser *newFollowerUser = [FollowerUser new];
                                [newFollowerUser setUserID:[[subFollower objectAtIndex:0] intValue]];
                                [newFollowerUser setFirstName:[self.helperIns decode:[subFollower objectAtIndex:1]]];
                                [newFollowerUser setLastName:[self.helperIns decode:[subFollower objectAtIndex:2]]];
                                [newFollowerUser setUrlAvatar:[self.helperIns decode:[subFollower objectAtIndex:3]]];
                                [newFollowerUser setParentUserID:self.storeIns.user.userID];
                                
                                [self.storeIns addNewFollower:newFollowerUser];
                                
                                [self.storeIns.listFollower addObject:newFollowerUser];
                            }
                        }
                    }
                }
                
                //Map Following(This User Follow)
                if ([[subData objectAtIndex:13] length] > 1) {
                    NSArray *subParameter = [[subData objectAtIndex:12] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFollower = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFollower count] > 1) {
                                FollowerUser *newFollowerUser = [FollowerUser new];
                                [newFollowerUser setUserID:[[subFollower objectAtIndex:0] intValue]];
                                [newFollowerUser setFirstName:[self.helperIns decode:[subFollower objectAtIndex:1]]];
                                [newFollowerUser setLastName:[self.helperIns decode:[subFollower objectAtIndex:2]]];
                                [newFollowerUser setUrlAvatar:[self.helperIns decode:[subFollower objectAtIndex:3]]];
                                
                                [self.storeIns.listFollowing addObject:newFollowerUser];
                            }
                        }
                    }
                }
                
                //Map FollowRequest
                if ([[subData objectAtIndex:14] length] > 0) {
                    NSArray *subParameter = [[subData objectAtIndex:12] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFollower = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFollower count] > 1) {
                                FollowerUser *newFollowerUser = [FollowerUser new];
                                [newFollowerUser setUserID:[[subFollower objectAtIndex:0] intValue]];
                                [newFollowerUser setFirstName:[self.helperIns decode:[subFollower objectAtIndex:1]]];
                                [newFollowerUser setLastName:[self.helperIns decode:[subFollower objectAtIndex:2]]];
                                [newFollowerUser setUrlAvatar:[self.helperIns decode:[subFollower objectAtIndex:3]]];
                                
                                [self.storeIns.listFollowRequest addObject:newFollowerUser];
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    return 0;
}

- (NSString*) reconnectCommand:(NSString *)userID withHashPass:(NSString *)hashPass{
    return [NSString stringWithFormat:@"RECONNECT{%@}%@<EOF>", userID, [self.helperIns encoded:hashPass]];
}

- (int) mapReconnect:(NSString *)str{
    
    if ([str length] > 0) {
        NSArray *subCommand = [str componentsSeparatedByString:@"{"];
        if ([subCommand count] == 2) {
            NSArray *subValue = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
            if ([subValue count] > 1) {
                
                //Map time Server
                if ([[subValue objectAtIndex:0] length] > 0) {
                    self.storeIns.timeServer = [self.helperIns convertStringToDate:[subValue objectAtIndex:0]];
                }
                
                //Map list message offline
                if ([[subValue objectAtIndex:1] length] > 1) {
                    NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        
                        for (int i = 0; i < count; i++) {
                            NSArray *subMessageOffline = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subMessageOffline count] > 1) {
                                Messenger *_newMessage = [[Messenger alloc] init];
                                [_newMessage setSenderID:[[subMessageOffline objectAtIndex:0] intValue]];
                                [_newMessage setFriendID:[[subMessageOffline objectAtIndex:0] intValue]];
                                [_newMessage setStrMessage: [self.helperIns decode:[subMessageOffline objectAtIndex:1]]];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setTypeMessage:0];
                                [_newMessage setKeySendMessage:[subMessageOffline objectAtIndex:2]];
                                [_newMessage setUserID:self.storeIns.user.userID];
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subMessageOffline objectAtIndex:3]];
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                                
                                [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                                [_newMessage setTimeServerMessage: [self.helperIns convertStringToDate:[subMessageOffline objectAtIndex:3]]];
                                [_newMessage setTimeOutMessenger:[[subMessageOffline objectAtIndex:4] intValue]];
                                
                                [self addMessageToFriend:_newMessage];
                                
                                [coziCoreDataIns saveMessenger:_newMessage];
                            }
                        }
                    }
                }
                
                //Map list photo offline
                //map message photo offline
                if ([[subValue objectAtIndex:2] length] > 0) {
                    NSArray *subParameter = [[subValue objectAtIndex:2] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 1) {
                        int count = (int)[subParameter count];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        for (int i = 0 ; i < count; i++) {
                            NSArray *subPhotoOffline = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subPhotoOffline count] > 1) {
                                
                                Messenger *_messagePhoto = [[Messenger alloc] init];
                                [_messagePhoto setSenderID:[[subPhotoOffline objectAtIndex:0] intValue]];
                                [_messagePhoto setFriendID:[[subPhotoOffline objectAtIndex:0] intValue]];
                                [_messagePhoto setStrMessage:[self.helperIns decode:[subPhotoOffline objectAtIndex:1]]];
                                [_messagePhoto setUrlImage:[self.helperIns decode:[subPhotoOffline objectAtIndex:1]]];
                                [_messagePhoto setKeySendMessage:[subPhotoOffline objectAtIndex:2]];
                                [_messagePhoto setStatusMessage:1];
                                [_messagePhoto setTypeMessage:1];
                                [_messagePhoto setUserID:self.storeIns.user.userID];
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subPhotoOffline objectAtIndex:3]];
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];

                                [_messagePhoto setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                                [_messagePhoto setTimeServerMessage: [self.helperIns convertStringToDate:[subPhotoOffline objectAtIndex:3]]];
                                [_messagePhoto setTimeOutMessenger:[[subPhotoOffline objectAtIndex:4] intValue]];
                                
                                [self addMessageToFriend:_messagePhoto];
                                
                                [coziCoreDataIns saveMessenger:_messagePhoto];
                            }
                        }
                    }
                }
                
                //map list friend request
                if ([[subValue objectAtIndex:3] length] > 0) {
                    NSArray *subParameter = [[subValue objectAtIndex:3] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 1) {
                        self.storeIns.friendsRequest = [NSMutableArray new];
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFriendRequest = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFriendRequest count] > 1) {
                                
                                Friend *_friend = [Friend new];
                                _friend.isFriendWithYour = 1;
                                [_friend setUserID:self.storeIns.user.userID];
                                _friend.friendID = [[subFriendRequest objectAtIndex:0] intValue];
                                [_friend setNickName:[self.helperIns decode:[subFriendRequest objectAtIndex:1]]];
                                [_friend setUrlThumbnail:[self.helperIns decode:[subFriendRequest objectAtIndex:2]]];
                                [_friend setUrlAvatar:[self.helperIns decode:[subFriendRequest objectAtIndex:3]]];
                                
                                //Add Default Messenger
                                NSString *_keyMessage = [self.storeIns randomKeyMessenger];
                                Messenger *_newMessage = [[Messenger alloc] init];
                                [_newMessage setStrMessage: [NSString stringWithFormat:@"%@ %@", _friend.nickName, @"want to chat with you"]];
                                _newMessage.senderID = _friend.friendID;
                                [_newMessage setTypeMessage:0];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setKeySendMessage:_keyMessage];
                                [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
                                [_newMessage setDataImage:nil];
                                [_newMessage setThumnail:nil];
                                [_newMessage setFriendID:_friend.friendID];
                                [_newMessage setUserID:self.storeIns.user.userID];
                                
                                _friend.friendMessage = [NSMutableArray new];
                                [_friend.friendMessage addObject:_newMessage];
                                
                                [self progressRecent:_friend];

                            }
                        }
                    }
                }
                
                //Map isReadMessage
                if ([[subValue objectAtIndex:4] length] > 1) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:4] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];

                            if ([subValue count] > 1) {
                                
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];

                            }
                        }
                    }
                }
                
                //Map isReadPhoto
                if ([[subValue objectAtIndex:5] length] > 1) {
                    NSArray *subParameter = [[subValue objectAtIndex:5] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];

                            if ([subValue count] > 1) {
                                
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];

                            }
                        }
                    }
                    
                }
                
                //map frined online
                if ([[subValue objectAtIndex:6] length] > 1) {
                    NSArray *subFriend = [[subValue objectAtIndex:6] componentsSeparatedByString:@"$"];
                    if ([subFriend count] > 1) {
                        int count = (int)[subFriend count];
                        for (int i = 0; i < count; i++) {
                            [self.storeIns updateStatusFriend:[[subFriend objectAtIndex:i] intValue] withStatus:1];
                        }
                    }
                }
                
                //Map Location Offline
                if ([[subValue objectAtIndex:7] length] > 1) {
                    NSArray *subLocation = [[subValue objectAtIndex:7] componentsSeparatedByString:@"$"];
                    if ([subLocation count] > 1) {
                        int count = (int)[subLocation count];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        for (int i = 0; i < count; i++) {
                            NSArray *subParameter = [[subLocation objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subParameter count] > 1) {
                                Messenger *_newMessage = [[Messenger alloc] init];
                                
                                [_newMessage setThumnail:nil];
                                [_newMessage setDataImage:nil];
                                [_newMessage setStatusMessage:1];
                                [_newMessage setTypeMessage:2];
                                [_newMessage setSenderID:[[subParameter objectAtIndex:0] intValue]];
                                [_newMessage setFriendID:[[subParameter objectAtIndex:0] intValue]];
                                [_newMessage setUserID:self.storeIns.user.userID];
                                _newMessage.longitude = [subParameter objectAtIndex:1];
                                _newMessage.latitude = [subParameter objectAtIndex:2];
                                _newMessage.keySendMessage = [subParameter objectAtIndex:3];
                                
                                NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessage.latitude, _newMessage.longitude, @"%7c" , _newMessage.latitude, _newMessage.longitude];
                                
                                _newMessage.urlImage = url;
                                
                                NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:4]];
                                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                                
                                _newMessage.timeServerMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:4]];
                                _newMessage.timeMessage = [self.helperIns getDateFormatMessage:_dateTimeMessage];
                                _newMessage.timeOutMessenger = [[subParameter objectAtIndex:5] intValue];
                                [self addMessageToFriend:_newMessage];
                                
                                [coziCoreDataIns saveMessenger:_newMessage];
                                
                            }
                            
                        }
                    }
                }
                
                //Map IsRead Location Offline
                if ([[subValue objectAtIndex:8] length] > 1) {
                    NSArray *subParameter = [[subValue objectAtIndex:8] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subValue count] > 1) {
                                
                                [self.storeIns updateStatusMessageFriendWithKey:[[subValue objectAtIndex:0] intValue] withMessageID:[subValue objectAtIndex:1] withStatus:2];
                                
                                Messenger *_messenger = [self.storeIns getMessageFriendID:[[subValue objectAtIndex:0] intValue] withKeyMessage:[subValue objectAtIndex:1]];
                                
                                [coziCoreDataIns updateMessenger:_messenger];
                                
                            }
                        }
                    }
                }
                
                //Map Messenger Remove Offline
                if ([[subValue objectAtIndex:9] length] > 1) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:9] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subValue count] > 1) {
                                
                                int userReceiveID = [[subParameter objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subParameter objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
                
                //Map Photo Remove Offline
                if ([[subValue objectAtIndex:10] length] > 1) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:9] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            
                            if ([subValue count] > 1) {
                                int userReceiveID = [[subValue objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subValue objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                            }

                        }
                    }
                    
                }
                
                //Map Location Remove Offline
                if ([[subValue objectAtIndex:11] length] > 1) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:9] componentsSeparatedByString:@"$"];
                    
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subValue = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subValue count] > 1) {
                                int userReceiveID = [[subValue objectAtIndex:0] intValue];
                                if (userReceiveID > 0) {
                                    
                                    NSString *keyMessage = [subValue objectAtIndex:1];
                                    
                                    BOOL isDelete = [self.storeIns deleteMessenger:userReceiveID withKeyMessenger:keyMessage];
                                    
                                    if (isDelete) {
                                        [coziCoreDataIns deleteMessenger:keyMessage];
                                    }
                                    
                                }
                            }

                        }
                    }
                    
                }
                
                //Map This User Follow(Following)
                if ([[subValue objectAtIndex:12] length] > 0) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:12] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        self.storeIns.listFollowing = [NSMutableArray new];
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFollower = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFollower count] > 1) {
                                FollowerUser *newFollowerUser = [FollowerUser new];
                                [newFollowerUser setUserID:[[subFollower objectAtIndex:0] intValue]];
                                [newFollowerUser setFirstName:[self.helperIns decode:[subFollower objectAtIndex:1]]];
                                [newFollowerUser setLastName:[self.helperIns decode:[subFollower objectAtIndex:2]]];
                                [newFollowerUser setUrlAvatar:[self.helperIns decode:[subFollower objectAtIndex:3]]];
                                
                                [self.storeIns.listFollowing addObject:newFollowerUser];
                            }
                        }
                    }

                }
                
                //Map Follow Request Offline
                if ([[subValue objectAtIndex:13] length] > 0) {
                    
                    NSArray *subParameter = [[subValue objectAtIndex:12] componentsSeparatedByString:@"$"];
                    if ([subParameter count] > 0) {
                        int count = (int)[subParameter count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subFollower = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                            if ([subFollower count] > 1) {
                                FollowerUser *newFollowerUser = [FollowerUser new];
                                [newFollowerUser setUserID:[[subFollower objectAtIndex:0] intValue]];
                                [newFollowerUser setFirstName:[self.helperIns decode:[subFollower objectAtIndex:1]]];
                                [newFollowerUser setLastName:[self.helperIns decode:[subFollower objectAtIndex:2]]];
                                [newFollowerUser setUrlAvatar:[self.helperIns decode:[subFollower objectAtIndex:3]]];
                                
                                [self.storeIns.listFollowRequest addObject:newFollowerUser];
                            }
                        }
                    }
    
                }
                
                //Map User Change Profile
                if ([[subValue objectAtIndex:14] length] > 0) {
                    
                }
                
                //Count Post
                [self.storeIns.user setCountPosts:[[subValue objectAtIndex:15] intValue]];
            }
        }
    }
    
    return 0;
}

- (void) addMessageToFriend:(Messenger *)_message{
    if (self.storeIns.friends != nil && [self.storeIns.friends count] > 0) {
        int count = (int)[self.storeIns.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.storeIns.friends objectAtIndex:i] friendID] == _message.friendID ||
                [[self.storeIns.friends objectAtIndex:i] friendID] == _message.senderID) {
                
                [[[self.storeIns.friends objectAtIndex:i] friendMessage] addObject:_message];
                break;
                
            }
        }
    }
}

- (void) loadData{
    NSString *strFriends = [self.helperIns loadFriends];
    NSString *strUser = [self.helperIns loaduser];
    
    if (strUser != nil && [strUser length] > 0) {
        NSArray *subCommand = [strUser componentsSeparatedByString:@"$"];
        if ([subCommand count] == 2) {
            NSArray *subValue = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"{"];
            if ([subValue count] > 0) {
                [self.storeIns.user setUserID:[[subValue objectAtIndex:0] intValue]];
                [self.storeIns.user setNickName:[subValue objectAtIndex:1]];
                [self.storeIns.user setBirthDay:[subValue objectAtIndex:2]];
                [self.storeIns.user setGender:[subValue objectAtIndex:3]];
                
                
                NSURL *urlThumbnail = [NSURL URLWithString:[subValue objectAtIndex:4]];
                NSData *dataThumbnail = [NSData dataWithContentsOfURL:urlThumbnail];
                UIImage *imgThumbnail = [UIImage imageWithData:dataThumbnail];
                [self.storeIns.user setThumbnail:imgThumbnail];
                [self.storeIns.user setUrlThumbnail:[subValue objectAtIndex:4]];
                
                [self.storeIns.user setAccessKey:[subValue objectAtIndex:5]];
                [self.storeIns.user setPhoneNumber:[subValue objectAtIndex:6]];
                [self.storeIns.user setFirstname:[subValue objectAtIndex:7]];
                [self.storeIns.user setLastName:[subValue objectAtIndex:8]];
                [self.storeIns.user setLeftAvatar:[[subValue objectAtIndex:9] floatValue]];
                [self.storeIns.user setTopAvatar:[[subValue objectAtIndex:10] floatValue]];
                [self.storeIns.user setWidthAvatar:[[subValue objectAtIndex:11] floatValue]];
                [self.storeIns.user setHeightAvatar:[[subValue objectAtIndex:12] floatValue]];
                [self.storeIns.user setScaleAvatar:[[subValue objectAtIndex:13] floatValue]];

                NSURL *urlAvatar = [NSURL URLWithString:[subValue objectAtIndex:14]];
                NSData *dataAvatar = [NSData dataWithContentsOfURL:urlAvatar];
                UIImage *imgAvatar = [UIImage imageWithData:dataAvatar];

                [self.storeIns.user setAvatar:imgAvatar];
                [self.storeIns.user setUrlAvatar:[subValue objectAtIndex:14]];
            }
        }
    }
    
    if (strFriends != nil && [strFriends length] > 0) {
        NSArray *subCommand = [strFriends componentsSeparatedByString:@"$"];
        if ([subCommand count] == 2) {
            NSArray *subValue = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subValue count] > 0) {
                //                self.storeIns.friends = [[NSMutableArray alloc] init];
                int count = (int)[subValue count];
                for (int i = 0; i < count; i++) {
                    if ([[subValue objectAtIndex:i] length] > 1) {
                        //Map friends list
                        NSArray *subFriends = [[subValue objectAtIndex:i] componentsSeparatedByString:@"{"];
                        BOOL isExists = NO;
                        
                        if ([self.storeIns.friends count] > 0) {
                            int countFriend = (int)[self.storeIns.friends count];
                            for (int j = 0; j < countFriend; j++) {
                                if ([[self.storeIns.friends objectAtIndex:j] friendID] == [[subFriends objectAtIndex:0] intValue]) {
                                    isExists = YES;
                                }
                            }
                        }
                        
                        if (!isExists) {
                            Friend *_newFriend = [[Friend alloc] init];
                            [_newFriend setFriendID:[[subFriends objectAtIndex:0] intValue]];
                            [_newFriend setNickName:[subFriends objectAtIndex:1]];
                            
                            NSURL *urlThumbnail = [NSURL URLWithString:[subFriends objectAtIndex:2]];
                            NSData *dataThumbnail = [NSData dataWithContentsOfURL:urlThumbnail];
                            UIImage *imgThumbnail = [UIImage imageWithData:dataThumbnail];
                            [_newFriend setThumbnail:imgThumbnail];
                            [_newFriend setUrlThumbnail:[subFriends objectAtIndex:2]];
                            
                            [_newFriend setGender:[subFriends objectAtIndex:3]];
                            [_newFriend setUrlAvatar:[subFriends objectAtIndex:9]];
                            
                            [self.storeIns.friends addObject:_newFriend];
                        }
                        
                        //get cache message
                        int friendID = [[subFriends objectAtIndex:0] intValue];
                        NSUserDefaults *_defaultUser = [NSUserDefaults standardUserDefaults];
                        NSData *nsDataMessage = [_defaultUser objectForKey:[NSString stringWithFormat:@"%i", friendID]];
                        
                        if (nsDataMessage != nil) {
                            NSMutableDictionary *dicMessage = [NSKeyedUnarchiver unarchiveObjectWithData:nsDataMessage];
                            
                            for(id key in dicMessage) {
                                NSMutableArray *messageArr = ((NSMutableArray*)[dicMessage objectForKey:key]);
                                if (messageArr != nil) {
                                    int countMessage = (int)[messageArr count];
                                    for (int j = 0; j < countMessage; j++) {
                                        NSString *strCacheMessage = [messageArr objectAtIndex:j];
                                        NSArray *subCommand = [strCacheMessage componentsSeparatedByString:@"}"];
                                        //SenderID}strMessage}TypeMessage}StatusMessage}dataImage}ThumImage}FriendID}TimeMessage}TimeServer
                                        if ([[subCommand objectAtIndex:2] isEqualToString:@"0"]) {
                                            Messenger *_newMessage = [[Messenger alloc] init];
                                            _newMessage.senderID = [[subCommand objectAtIndex:0] intValue];
                                            _newMessage.strMessage = [subCommand objectAtIndex:1];
                                            _newMessage.typeMessage = [[subCommand objectAtIndex:2] intValue];
                                            _newMessage.statusMessage = [[subCommand objectAtIndex:3] intValue];
                                            _newMessage.dataImage = [self.helperIns decodeBase64:[subCommand objectAtIndex:4]];
                                            UIImage *imgThum = [UIImage imageWithData:_newMessage.dataImage];
                                            
                                            _newMessage.thumnail = [self.helperIns resizeImage:imgThum resizeSize:CGSizeMake(80, 80)];
                                            _newMessage.friendID = [[subCommand objectAtIndex:6] intValue];
                                            
                                            _newMessage.timeMessage = [subCommand objectAtIndex:7];
                                            _newMessage.keySendMessage = [subCommand objectAtIndex:8];
                                            _newMessage.timeServerMessage = [self.helperIns convertStringToDate:[subCommand objectAtIndex:9]];
                                            [self addMessageToFriend:_newMessage];
                                        }else{
                                            Messenger *_newMessage = [[Messenger alloc] init];
                                            _newMessage.senderID = [[subCommand objectAtIndex:0] intValue];
                                            _newMessage.strMessage = [subCommand objectAtIndex:1];
                                            if ([[subCommand objectAtIndex:2] isEqualToString:@"1"]) {
                                                _newMessage.typeMessage = 1;
                                            }else{
                                                _newMessage.typeMessage = 2;
                                            }

                                            _newMessage.statusMessage = [[subCommand objectAtIndex:3] intValue];
                                            _newMessage.dataImage = [self.helperIns decodeBase64:[subCommand objectAtIndex:4]];
                                            UIImage *imgThum = [UIImage imageWithData:_newMessage.dataImage];

                                            _newMessage.thumnail = imgThum;
                                            
                                            _newMessage.friendID = [[subCommand objectAtIndex:6] intValue];
                                            
                                            _newMessage.timeMessage = [subCommand objectAtIndex:7];
                                            _newMessage.keySendMessage = [subCommand objectAtIndex:8];
                                            _newMessage.timeServerMessage = [self.helperIns convertStringToDate:[subCommand objectAtIndex:9]];
                                            [self addMessageToFriend:_newMessage];
                                        }
                                    }
                                }
                            }
                        }//end get cache message
                        
                        
                        
                    }
                }
            }
        }
    }
}

- (NSString*) searchFriendCommand:(NSString *)nickName{
    return [NSString stringWithFormat:@"SEARCHUSER{%@<EOF>", nickName];
}

- (NSString*) sendMessageCommand:(int)userReceive withKeyMessage:(NSString*)_keyMessage withMessage:(NSString*)message withTimeout:(int)_timeOut{
    return [NSString stringWithFormat:@"SENDMESSAGE{%i}%@}%@}%i<EOF>", userReceive, [self.helperIns encodedBase64:[message dataUsingEncoding:NSUTF8StringEncoding]], _keyMessage, _timeOut];
}

- (NSString *) sendIsReadMessage:(int)_friendID withKeyMessage:(NSString*)_keyMessage{
    return [NSString stringWithFormat:@"MESSAGEISREAD{%i}%@<EOF>", _friendID, _keyMessage];
}

- (NSString *) sendIsReadPhoto:(int)_friendID withKeyMessage:(NSString*)_keyMessage{
    return [NSString stringWithFormat:@"PHOTOISREAD{%i}%@<EOF>", _friendID, _keyMessage];
}

- (NSString *) sendIsReadLocation:(int)_friendID withKeyMessage:(NSString*)_keyMessage{
    return [NSString stringWithFormat:@"LOCATIONISREAD{%i}%@<EOF>", _friendID, _keyMessage];
}

- (NSString *) removeMessage:(int)_userReceive withKeyMessage:(NSString*)_keyMessenger{
    return [NSString stringWithFormat:@"REMOVEMESSAGE{%i}%@<EOF>", _userReceive, _keyMessenger];
}

- (NSString *) removePhoto:(int)_userReceive withKeyMessage:(NSString*)_keyMessenger{
    return [NSString stringWithFormat:@"REMOVEPHOTO{%i}%@<EOF>", _userReceive, _keyMessenger];
}

- (NSString *) removeLocation:(int)_userReceive withKeyMessage:(NSString*)_keyMessenger{
    return [NSString stringWithFormat:@"REMOVELOCATION{%i}%@<EOF>", _userReceive, _keyMessenger];
}

- (int) mapSendMessage:(NSString*)str{
    int result = -1;
    if ([str length] > 0) {
        NSArray *subValue = [str componentsSeparatedByString:@"{"];
        result = [[subValue objectAtIndex:1] intValue];
    }
    
    return result;
}

- (Messenger *) mapReceiveMessage:(NSString*)str{
    Messenger *result = [[Messenger alloc] init];
    if ([str length] > 0) {
        NSArray *subCommand = [str componentsSeparatedByString:@"{"];
        if ([subCommand count] == 2) {
            NSArray *subValue = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subValue count] > 1) {
                
                [result setSenderID:[[subValue objectAtIndex:0] intValue]];
                [result setFriendID:[[subValue objectAtIndex:0] intValue]];
                [result setStrMessage:[self.helperIns decode:[subValue objectAtIndex:1]]];
                [result setStatusMessage:0];
                [result setTypeMessage:0];
                [result setKeySendMessage:[subValue objectAtIndex:2]];
                [result setDataImage:nil];
                [result setThumnail:nil];
                [result setUrlImage:@""];
                [result setUserID:self.storeIns.user.userID];
                
                NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                NSDate *timeMessage = [self.helperIns convertStringToDate:[subValue objectAtIndex:3]];
                NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                
                [result setTimeOutMessenger:[[subValue objectAtIndex:4] intValue]];
                [result setTimeServerMessage:[self.helperIns convertStringToDate:[subValue objectAtIndex:3]]];
                [result setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                
            }
        }
    }
    
    return result;
}

- (Friend*) processReceiveMessage:(Messenger *)sms{
    Friend *result = nil;

    if (self.storeIns.friends != nil && [self.storeIns.friends count] > 0) {
        int count = (int)[self.storeIns.friends count];
        for (int i = 0; i < count; i++) {
            if ([[self.storeIns.friends objectAtIndex:i] friendID] == sms.senderID) {
                [[[self.storeIns.friends objectAtIndex:i] friendMessage] addObject:sms];
                result = [self.storeIns.friends objectAtIndex:i];
                break;
            }
        }
    }
    
    return result;
}

- (NSString*) requestFriendCommand:(int)userID withDigit:(NSString*)digit{
    return [NSString stringWithFormat:@"SENDFRIENDREQUEST{%i}%@<EOF>", userID, digit];
}

//Group Chat
- (NSString *) commandSendMessageToGroup:(int)groupId withKeyMessage:(NSString*)_keyMessage withMessage:(NSString*)message withTimeout:(int)_timeout{
    return [NSString stringWithFormat:@"SENDGROUPMESSAGE{%i}%@}%@}%i<EOF>", groupId, [self.helperIns encodedBase64:[message dataUsingEncoding:NSUTF8StringEncoding]], _keyMessage, _timeout];
}

- (int) mapRequestFriends:(NSString*)str{
    int result = -1;
    
    if ([str length] > 0) {
        NSArray *subValue = [str componentsSeparatedByString:@"{"];
        result = [[subValue objectAtIndex:1] intValue];
    }
    
    return result;
}

- (void) resultFriendRequest:(NSString*)str{
    if ([str length] > 0) {
        NSArray *subCommand = [str componentsSeparatedByString:@"{"];
        if ([subCommand count] == 2) {
            
        }
    }
}

- (NSString*) getUploadAmazonUrl:(int)_userReciveID withMessageKye:(NSString*)keyMessage withIsNotify:(int)_isNotify{
    return [NSString stringWithFormat:@"GETUPLOADAMAZONEURL{%i}%@}%i<EOF>", _userReciveID, keyMessage, _isNotify];
}

- (NSString *) getUploadAvatar{
    return @"GETUPLOADAVATARURL{<EOF>";
}

- (AmazonInfo*) mapAmazonInfo:(NSString *)str{
    AmazonInfo *result = [[AmazonInfo alloc] init];
    
    NSArray *subValue = [str componentsSeparatedByString:@"{"];
    if ([subValue count] == 2) {
        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
        if ([subParameter count] > 1) {
            result.key = [self.helperIns decode:[subParameter objectAtIndex:0]];
            result.policy = [self.helperIns decode:[subParameter objectAtIndex:1]];
            result.signature = [self.helperIns decode:[subParameter objectAtIndex:2]];
            result.accessKey = [self.helperIns decode:[subParameter objectAtIndex:3]];
            result.url = [self.helperIns decode:[subParameter objectAtIndex:4]];
            result.userReceiveID = [[subParameter objectAtIndex:5] intValue];
            result.keyMessage = [subParameter objectAtIndex:6];
        }
    }
    
    return result;
}

- (AmazonInfo*) mapAmazonUploadAvatar:(NSString *)str{
    AmazonInfo *result = [[AmazonInfo alloc] init];
    
    NSArray *subParameter = [str componentsSeparatedByString:@"}"];
    if ([subParameter count] > 1) {
        result.key = [self.helperIns decode:[subParameter objectAtIndex:0]];
        result.policy = [self.helperIns decode:[subParameter objectAtIndex:1]];
        result.signature = [self.helperIns decode:[subParameter objectAtIndex:2]];
        result.accessKey = [self.helperIns decode:[subParameter objectAtIndex:3]];
        result.url = [self.helperIns decode:[subParameter objectAtIndex:4]];
    }

    return result;
}

- (AmazonInfoPost*) mapAmazonUploadPost:(NSString *)str{
    AmazonInfoPost *result = [[AmazonInfoPost alloc] init];
    
    NSArray *subParameter = [str componentsSeparatedByString:@"}"];
    if ([subParameter count] > 1) {
        result.keyThumb = [self.helperIns decode:[subParameter objectAtIndex:0]];
        result.policyThumb = [self.helperIns decode:[subParameter objectAtIndex:1]];
        result.signatureThumb = [self.helperIns decode:[subParameter objectAtIndex:2]];
        result.accessKeyThumb = [self.helperIns decode:[subParameter objectAtIndex:3]];
        
        result.key = [self.helperIns decode:[subParameter objectAtIndex:4]];
        result.policy = [self.helperIns decode:[subParameter objectAtIndex:5]];
        result.signature = [self.helperIns decode:[subParameter objectAtIndex:6]];
        result.accessKey = [self.helperIns decode:[subParameter objectAtIndex:7]];
        result.url = [self.helperIns decode:[subParameter objectAtIndex:8]];
    }
    
    return result;

}

- (NSString *) sendResultUploadAmazon:(int)code withFriendID:(int)_friendID withKeyMessage:(NSString*)_keyMessage{
    return [NSString stringWithFormat:@"RESULTUPLOADPHOTO{%i}%i}%@<EOF>", code, _friendID, _keyMessage];
}

- (NSString *) commandSendPhoto:(int)userReceive withKey:(NSString*)key withKeyMessage:(NSString*)_keyMessage withTimeout:(int)_timeOut{
    return [NSString stringWithFormat:@"SENDPHOTO{%i}%@}%@}%i<EOF>", userReceive, [self.helperIns encodedBase64:[key dataUsingEncoding:NSUTF8StringEncoding]], _keyMessage, _timeOut];
}

- (NSString *) regPhone:(NSString *)strPhone{
    NSString *phoneHash = [self.helperIns encoded:strPhone];
    return [NSString stringWithFormat:@"REG{%@}%@<EOF>", strPhone, phoneHash];
}

- (NSString *) cmdSendAuthCode:(NSString *)_authCode{
    return [NSString stringWithFormat:@"AUTHCODE{%@<EOF>", _authCode];
}

- (NSString *) commandResultUploadAvatar:(int)_codeAvatar withCodeThumbnail:(int)_codeThumbnail{
    return [NSString stringWithFormat:@"RESULTUPLOADAVATAR{%i}%i<EOF>", _codeThumbnail, _codeAvatar];
}

- (NSString *) sendLocation:(int)userReceiveID withLong:(NSString *)_long withLati:(NSString *)_lati withKeyMessage:(NSString*)_keyMessage withTimeOut:(int)_timeOut{
    return [NSString stringWithFormat:@"SENDLOCATION{%i}%@}%@}%@}%i<EOF>", userReceiveID, _long, _lati, _keyMessage, _timeOut];
}

/**
 *  <#Description#>
 *
 *  @param _str <#_str description#>
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray*) mapDataWall:(NSString*)_str withType:(int)type{
    NSMutableArray *result = [NSMutableArray new];
    
    NSArray *subData = [_str componentsSeparatedByString:@"~"];
    if ([subData count] > 0) {
        int count = (int)[subData count];
        
        for (int i = 0; i < count; i++) {
            DataWall *newDataWall = [DataWall new];
//            newDataWall.typePost = -1;
            
            NSArray *subCommand = [[subData objectAtIndex:i] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                [newDataWall setUserPostID:[[subCommand objectAtIndex:0] intValue]];
                [newDataWall setContent: [self.helperIns decode:[subCommand objectAtIndex:1]]];
                
                if ([newDataWall.content isEqualToString:@""]) {
                    [newDataWall setContent:@"Hình ảnh chi mang tính chất minh hoạ. Không phải hình thật ^tt^@Duy Anh^tt^ - Hình ảnh chi mang tính chất minh hoạ. Không phải hình thật ^tt^@Thiên Phú^tt^"];
                }
                
                Friend *_friend = [self.storeIns getFriendByID:newDataWall.userPostID];
                if (_friend != nil) {
                    newDataWall.fullName = _friend.nickName;
                }else{
                    newDataWall.fullName = self.storeIns.user.nickName;
                }
                
                //process image
                newDataWall.images = [NSMutableArray new];
                if (![[subCommand objectAtIndex:2] isEqualToString:@""]) {
                    
                    NSArray *subImage = [[subCommand objectAtIndex:2] componentsSeparatedByString:@"$"];
                    
                    if ([subImage count] > 0) {
                        
                        if (![[subImage lastObject] isEqualToString:@""]) {
                            
                            NSString *url = [self.helperIns decode:[subImage lastObject]];
                            NSString *urlThumb = [self.helperIns decode:[subImage firstObject]];
                            newDataWall.urlFull = url;
                            newDataWall.urlThumb = urlThumb;
                            
                        }
                    
                    }
                }
                
                newDataWall.video = [self.helperIns decode:[subCommand objectAtIndex:3]];
                
                //process location
                if (![[subCommand objectAtIndex:4] isEqualToString:@""]) {
                    
                    NSArray *subLocation = [[subCommand objectAtIndex:4] componentsSeparatedByString:@"|"];
                    if ([subLocation count] == 2) {
                        [newDataWall setLongitude:[subLocation objectAtIndex:0]];
                        [newDataWall setLatitude:[subLocation objectAtIndex:1]];
                    }
                }else{
                    [newDataWall setLongitude:@"0"];
                    [newDataWall setLatitude:@"0"];
                }
                
                [newDataWall setTime:[subCommand objectAtIndex:5]];
                [newDataWall setDatePost:[self.helperIns convertStringToDate:newDataWall.time]];
                
                
                [newDataWall setClientKey:[self.helperIns decode:[subCommand objectAtIndex:6]]];
                [newDataWall setFirstName:[self.helperIns decode:[subCommand objectAtIndex:7]]];
                [newDataWall setLastName: [self.helperIns decode:[subCommand objectAtIndex:8]]];
                
                newDataWall.comments = [NSMutableArray new];
                newDataWall.likes = [NSMutableArray new];
                
                //list comment
                if (![[subCommand objectAtIndex:9] isEqualToString:@"0"]) {
                    NSArray *subListComment = [[subCommand objectAtIndex:9] componentsSeparatedByString:@"$"];
                    if ([subListComment count] > 0) {
                        int countComment = (int)[subListComment count];
                        for (int i = 0; i < countComment; i++) {
                            
                            NSArray *subData = [[subListComment objectAtIndex:i] componentsSeparatedByString:@"]"];
                            if ([subData count] > 1) {
                                PostComment *_newComment = [[PostComment alloc] init];
                                _newComment.dateComment = [self.helperIns convertStringToDate:[subData objectAtIndex:0]];
                                _newComment.userCommentId = [[subData objectAtIndex:1] integerValue];
                                _newComment.firstName = [self.helperIns decode:[subData objectAtIndex:2]];
                                _newComment.lastName = [self.helperIns decode:[subData objectAtIndex:3]];
                                _newComment.contentComment = [self.helperIns decode:[subData objectAtIndex:4]];
                                _newComment.urlImageComment = [self.helperIns decode:[subData objectAtIndex:5]];
                                //object at index 6
                                _newComment.commentLikes = [NSMutableArray new];
                                //object at index 7
                                //_newComment.isLikeComment
                                
                                _newComment.commentClientKey = [self.helperIns decode:[subData objectAtIndex:8]];
                                _newComment.postClientKey = newDataWall.clientKey;
                                
                                _newComment.urlAvatarThumb = [self.helperIns decode:[subData objectAtIndex:9]];
                                _newComment.urlAvatarFull = [self.helperIns decode:[subData objectAtIndex:10]];
                                
                                //Map list like comment
                                [newDataWall.comments addObject:_newComment];
                            }
                            
                        }
                    }
                }
                
                if (![[subCommand objectAtIndex:10] isEqualToString:@"0"]) {
                    //list like
                    
                    NSArray *subListLike = [[subCommand objectAtIndex:10] componentsSeparatedByString:@"["];
                    if ([subListLike count] > 0) {
                        int count = (int)[subListLike count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subData = [[subListLike objectAtIndex:i] componentsSeparatedByString:@"&"];
                            if ([subData count] > 1) {
                                PostLike *_newLike = [PostLike new];
                                _newLike.dateLike = [self.helperIns convertStringToDate:[subData objectAtIndex:0]];
                                _newLike.userLikeId = [[subData objectAtIndex:1] integerValue];
                                _newLike.firstName = [self.helperIns decode:[subData objectAtIndex:2]];
                                _newLike.lastName = [self.helperIns decode:[subData objectAtIndex:3]];
                                _newLike.urlAvatarThumb = [self.helperIns decode:[subData objectAtIndex:4]];
                                _newLike.urlAvatarFull = [self.helperIns decode:[subData objectAtIndex:5]];
                                
                                [newDataWall.likes addObject:_newLike];
                            }
                        }
                    }
                }
                
                if ([[subCommand objectAtIndex:11] isEqualToString:@"0"]) {
                    [newDataWall setIsLike:NO];
                }else{
                    [newDataWall setIsLike:YES];
                }
                
                newDataWall.codeType = [[subCommand objectAtIndex:12] intValue];
                
                [newDataWall setUrlAvatarThumb:[self.helperIns decode:[subCommand objectAtIndex:13]]];
                [newDataWall setUrlAvatarFull:[self.helperIns decode:[subCommand objectAtIndex:14]]];
                
                if (type == 0) {
                    [self.storeIns addWallData:newDataWall];
                }else if(type == 1){
                    [self.storeIns addNoisesData:newDataWall];
                }
                
                [result addObject:newDataWall];
            }
        
        }
    }
    
    return result;
}

/**
 *  <#Description#>
 *
 *  @param _str <#_str description#>
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray*) mapDataNoises:(NSString*)_str{
    NSMutableArray *result = [NSMutableArray new];
    
    NSArray *subData = [_str componentsSeparatedByString:@"~"];
    if ([subData count] > 0) {
        int count = (int)[subData count];
        
        for (int i = 0; i < count; i++) {
            DataWall *newDataWall = [DataWall new];
            
            NSArray *subCommand = [[subData objectAtIndex:i] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                [newDataWall setUserPostID:[[subCommand objectAtIndex:0] intValue]];
                [newDataWall setContent: [self.helperIns decode:[subCommand objectAtIndex:1]]];
                
                if ([newDataWall.content isEqualToString:@""]) {
                    [newDataWall setContent:@"Hình ảnh chi mang tính chất minh hoạ. Không phải hình thật ^tt^@Duy Anh^tt^ - Hình ảnh chi mang tính chất minh hoạ. Không phải hình thật ^tt^@Thiên Phú^tt^"];
                }
                
                Friend *_friend = [self.storeIns getFriendByID:newDataWall.userPostID];
                if (_friend != nil) {
                    newDataWall.fullName = _friend.nickName;
                }else{
                    newDataWall.fullName = self.storeIns.user.nickName;
                }
                
                //process image
                newDataWall.images = [NSMutableArray new];
                if (![[subCommand objectAtIndex:2] isEqualToString:@""]) {
                    
                    NSArray *subImage = [[subCommand objectAtIndex:2] componentsSeparatedByString:@"$"];
                    
                    if ([subImage count] > 0) {
                        
                        if (![[subImage firstObject] isEqualToString:@""]) {
                            
                            NSString *url = [self.helperIns decode:[subImage firstObject]];
                            NSString *urlFull = [self.helperIns decode:[subImage lastObject]];
                            newDataWall.urlThumb = url;
                            newDataWall.urlFull = urlFull;
                            
                        }
                        
                    }
                }
                
                newDataWall.video = [self.helperIns decode:[subCommand objectAtIndex:3]];
                
                //process location
                if (![[subCommand objectAtIndex:4] isEqualToString:@""]) {
                    NSArray *subLocation = [[subCommand objectAtIndex:4] componentsSeparatedByString:@"|"];
                    if ([subLocation count] == 2) {
                        [newDataWall setLongitude:[subLocation objectAtIndex:0]];
                        [newDataWall setLatitude:[subLocation objectAtIndex:1]];
                    }
                }
                
                [newDataWall setTime:[subCommand objectAtIndex:5]];
                [newDataWall setDatePost:[self.helperIns convertStringToDate:newDataWall.time]];
                
                [newDataWall setClientKey:[self.helperIns decode:[subCommand objectAtIndex:6]]];
                [newDataWall setFirstName:[self.helperIns decode:[subCommand objectAtIndex:7]]];
                [newDataWall setLastName: [self.helperIns decode:[subCommand objectAtIndex:8]]];
                
                newDataWall.comments = [NSMutableArray new];
                newDataWall.likes = [NSMutableArray new];
                
                //list comment
                if (![[subCommand objectAtIndex:9] isEqualToString:@"0"]) {
                    NSArray *subListComment = [[subCommand objectAtIndex:9] componentsSeparatedByString:@"$"];
                    if ([subListComment count] > 0) {
                        int countComment = (int)[subListComment count];
                        for (int i = 0; i < countComment; i++) {
                            
                            NSArray *subData = [[subListComment objectAtIndex:i] componentsSeparatedByString:@"]"];
                            if ([subData count] > 1) {
                                PostComment *_newComment = [[PostComment alloc] init];
                                _newComment.dateComment = [self.helperIns convertStringToDate:[subData objectAtIndex:0]];
                                _newComment.userCommentId = [[subData objectAtIndex:1] integerValue];
                                _newComment.firstName = [self.helperIns decode:[subData objectAtIndex:2]];
                                _newComment.lastName = [self.helperIns decode:[subData objectAtIndex:3]];
                                _newComment.contentComment = [self.helperIns decode:[subData objectAtIndex:4]];
                                _newComment.urlImageComment = [self.helperIns decode:[subData objectAtIndex:5]];
                                _newComment.commentLikes = [NSMutableArray new];    //Objectatindex 6
                                
                                _newComment.isLikeComment = [[subData objectAtIndex:7] boolValue];
                                _newComment.commentClientKey = [self.helperIns decode:[subData objectAtIndex:8]];
                                _newComment.urlAvatarThumb = [self.helperIns decode:[subData objectAtIndex:9]];
                                _newComment.urlAvatarFull = [self.helperIns decode:[subData objectAtIndex:10]];
                                
                                [newDataWall.comments addObject:_newComment];
                            }
                            
                        }
                    }
                }
                
                if (![[subCommand objectAtIndex:10] isEqualToString:@"0"]) {
                    //list like
                    
                    NSArray *subListLike = [[subCommand objectAtIndex:10] componentsSeparatedByString:@"["];
                    if ([subListLike count] > 0) {
                        int count = (int)[subListLike count];
                        for (int i = 0; i < count; i++) {
                            NSArray *subData = [[subListLike objectAtIndex:i] componentsSeparatedByString:@"&"];
                            PostLike *_newLike = [PostLike new];
                            _newLike.dateLike = [self.helperIns convertStringToDate:[subData objectAtIndex:0]];
                            _newLike.userLikeId = [[subData objectAtIndex:1] integerValue];
                            _newLike.firstName = [self.helperIns decode:[subData objectAtIndex:2]];
                            _newLike.lastName = [self.helperIns decode:[subData objectAtIndex:3]];
                            _newLike.urlAvatarThumb = [self.helperIns decode:[subData objectAtIndex:4]];
                            _newLike.urlAvatarFull = [self.helperIns decode:[subData objectAtIndex:5]];
                            
                            [newDataWall.likes addObject:_newLike];
                        }
                    }
                }
                
                if ([[subCommand objectAtIndex:11] isEqualToString:@"0"]) {
                    [newDataWall setIsLike:NO];
                }else{
                    [newDataWall setIsLike:YES];
                }
                
                [newDataWall setCodeType:[[subCommand objectAtIndex:12] intValue]];
                
                [newDataWall setUrlAvatarThumb:[self.helperIns decode:[subCommand objectAtIndex:13]]];
                [newDataWall setUrlAvatarFull:[self.helperIns decode:[subCommand objectAtIndex:14]]];
                
                [self.storeIns addNoisesData:newDataWall];
//                [result addObject:newDataWall];
                
            }
            
        }
    }
    
    return result;
}

- (void) progressRecent:(Friend*)_friend{
    
    if (self.storeIns.recent == nil) {
        self.storeIns.recent = [NSMutableArray new];
    }
    
    //find friend recent list
    int indexRecent = -1;
    BOOL isExists = NO;
    
    int count = (int)[self.storeIns.recent count];
    for (int i = 0; i < count; i++) {
        if ([[self.storeIns.recent objectAtIndex:i] recentID] == _friend.friendID) {
            isExists = YES;
            indexRecent = i;
            break;
        }
    }
    
    if (!isExists) {
        Recent *_newRecent = [Recent new];
        _newRecent.recentID = _friend.friendID;
        _newRecent.typeRecent = 0;
        _newRecent.thumbnail = _friend.thumbnail;
        _newRecent.urlThumbnail = _friend.urlThumbnail;
        _newRecent.nameRecent = _friend.nickName;
        _newRecent.friendIns = _friend;
        //property group chat
        _newRecent.friendRecent = [NSMutableArray new];
        _newRecent.messengerRecent = [NSMutableArray new];
        
        [self.storeIns.recent addObject:_newRecent];
    }else{
        Recent *_recent = [self.storeIns.recent objectAtIndex:indexRecent];
        [self.storeIns.recent removeObjectAtIndex:indexRecent];
        [self.storeIns.recent insertObject:_recent atIndex:0];
    }
}

- (NSString*) getGroupUploadAmazonUrl:(int)_groupID withMessageKey:(NSString*)keyMessage withIsNotify:(int)_isNotify{
    return [NSString stringWithFormat:@"GETUPLOADAMAZONEURL{%i}%@}%i<EOF>", _groupID, keyMessage, _isNotify];
}
@end
