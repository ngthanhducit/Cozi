//
//  Store+CoreData.m
//  Cozi
//
//  Created by ChjpCoj on 3/10/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "Store+CoreData.h"

@implementation Store (CoreData)

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
        
        if ([self.user.nickName isEqualToString:@""]) {
            self.user.nickName = [NSString stringWithFormat:@"%@ %@", self.user.firstname, self.user.lastName];
        }
        
        //        if (![self.user.urlAvatar isEqualToString:@""]) {
        //            NSArray *subUrl = [self.user.urlAvatar componentsSeparatedByString:@"/"];
        //            UIImage *imgAvatar = [helperIns loadImage:[subUrl lastObject]];
        //
        //            if (imgAvatar) {
        //
        //            }
        //        }else{
        //
        //        }
        
        if (![self.user.urlAvatar isEqualToString:@""]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                UIImage *imgAvatar = [SDWebImageManager.sharedManager.imageCache imageFromDiskCacheForKey:self.user.urlAvatar];
                //                NSArray *subUrl = [self.user.urlAvatar componentsSeparatedByString:@"/"];
                UIImage *imgAvatar = [helperIns loadImage:self.user.urlAvatar];
                
                if (imgAvatar) {
                    [self.user setAvatar:imgAvatar];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                }else{
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.user.urlAvatar] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                        if (image && finished) {
                            [self.user setAvatar:image];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                            
                            NSArray *subUrl = [self.user.urlAvatar componentsSeparatedByString:@"/"];
                            [helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                        }
                        
                    }];
                }
            });
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
        }
        
        [self.user setUrlThumbnail:[_user valueForKey:@"url_thumbnail"]];
        
        if (![self.user.urlThumbnail isEqualToString:@""]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *subUrl = [self.user.urlThumbnail componentsSeparatedByString:@"/"];
                UIImage *imgAvatar = [helperIns loadImage:[subUrl lastObject]];
                
                if (imgAvatar) {
                    [self.user setThumbnail:imgAvatar];
                }else{
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.user.urlThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        if (image && finished) {
                            [self.user setThumbnail:image];
                            
                            NSArray *subUrl = [self.user.urlThumbnail componentsSeparatedByString:@"/"];
                            [helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                        }
                        
                    }];
                }
                
            });
        }else{
            [self.user setThumbnail:[helperIns getDefaultAvatar]];
        }
        
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
            //            [_newFriend setHeightAvatar:[[_friend valueForKey:@"height_avatar"] floatValue]];
            [_newFriend setLastName:[_friend valueForKey:@"last_name"]];
            //            [_newFriend setLeftAvatar:[[_friend valueForKey:@"left_avatar"] floatValue]];
            [_newFriend setNickName:[_friend valueForKey:@"nick_name"]];
            //            [_newFriend setScaleAvatar:[[_friend valueForKey:@"scale_avatar"] floatValue]];
            [_newFriend setStatusFriend:[[_friend valueForKey:@"status_friend"] intValue]];
            //            [_newFriend setTopAvatar:[[_friend valueForKey:@"top_avatar"] floatValue]];
            [_newFriend setUrlAvatar:[_friend valueForKey:@"url_avatar"]];
            [_newFriend setUrlThumbnail:[_friend valueForKey:@"url_thumbnail"]];
            [_newFriend setPhoneNumber:[_friend valueForKey:@"phone_number"]];
            [_newFriend setStatusAddFriend:[[_friend valueForKey:@"status_add_friend"] intValue]];
            [_newFriend setUserName:[_friend valueForKey:@"user_name"]];
            
            NSArray *subUrl = [_newFriend.urlThumbnail componentsSeparatedByString:@"/"];
            UIImage *imgThumbnail = [helperIns loadImage:[subUrl lastObject]];
            
            if (imgThumbnail) {
                [_newFriend setThumbnail:imgThumbnail];
                [_newFriend setThumbnailOffline:imgThumbnail];
                
            }else{
                if (![_newFriend.urlThumbnail isEqualToString:@""]) {
                    
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_newFriend.urlThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                        if (image && finished) {
                            _newFriend.thumbnail = image;
                            NSArray *subUrl = [_newFriend.urlThumbnail componentsSeparatedByString:@"/"];
                            [helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                        }
                        
                    }];
                    
                }else{
                    [_newFriend setThumbnail:imgEmptyAvatar];
                    [_newFriend setThumbnailOffline:imgEmptyAvatar];
                }
            }
            
            [_newFriend setUserID:[[_friend valueForKey:@"user_id"] intValue]];
            
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
                        
                        //                        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessenger.latitude, _newMessenger.longitude, @"%7c" , _newMessenger.latitude, _newMessenger.longitude];
                        //
                        //                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        //
                        //                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        //                            _newMessenger.thumnail = image;
                        //                        }];
                        
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
                
                Recent *_recent = [Recent new];
                _recent.recentID = _newFriend.friendID;
                _recent.nameRecent = _newFriend.nickName;
                _recent.typeRecent = 0;
                _recent.urlThumbnail = _newFriend.urlThumbnail;
                _recent.thumbnail = _newFriend.thumbnail;
                _recent.friendIns = _newFriend;
                _recent.friendRecent = [NSMutableArray new];
                _recent.messengerRecent = [NSMutableArray new];
                
                [self.recent addObject:_recent];
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
                Recent *_recent = [Recent new];
                _recent.recentID = _friend.friendID;
                _recent.nameRecent = _friend.nickName;
                _recent.typeRecent = 0;
                _recent.thumbnail = _friend.thumbnail;
                _recent.urlThumbnail = _friend.urlThumbnail;
                _recent.friendIns = _friend;
                _recent.friendRecent = [NSMutableArray new];
                _recent.messengerRecent = [NSMutableArray new];
                
                [self.recent addObject:_recent];
                
            }
        }
    }
    
}

#pragma Friend Request
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

#pragma -mark Post And Noise
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

- (DataWall*) getPostFromNoise:(NSString*)_clientKey withUserPostID:(int)_userPostID{
    DataWall *result = nil;
    if (self.noises != nil) {
        int count = (int)[self.noises count];
        for (int i = 0; i < count; i++) {
            
            if ([[[self.noises objectAtIndex:i] clientKey] isEqualToString:_clientKey] && [[self.noises objectAtIndex:i] userPostID] == _userPostID) {
                
                result = [self.noises objectAtIndex:i];
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

- (void) insertNoisesData:(DataWall *)_dataWall{
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
            [self.noises insertObject:_dataWall atIndex:0];
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

#pragma -mark Group Chat
- (NSMutableArray*) getGroupChatByUserID:(int)_userID{
    NSMutableArray *recents = [NSMutableArray new];
    
    NSMutableArray *result = [coziCoreDataIns getGroupChatWithUserID:_userID];
    if (result) {
        int count = (int)[result count];
        for (int i = 0; i < count; i++) {
            NSManagedObject *_post = [result objectAtIndex:i];
            Recent *_newRecent = [Recent new];
            
            [_newRecent setRecentID:[[_post valueForKey:@"recent_id"] intValue]];
            [_newRecent setNameRecent:[_post valueForKey:@"name_recent"]];
            [_newRecent setTypeRecent:[[_post valueForKey:@"type_recent"] intValue]];
            [_newRecent setUserID:[[_post valueForKey:@"user_id"] intValue]];
            [_newRecent setUrlThumbnail:[_post valueForKey:@"url_thumbnail"]];
            
            _newRecent.friendRecent = [NSMutableArray new];
            _newRecent.messengerRecent = [NSMutableArray new];
            
            NSMutableArray *groupFriends = [coziCoreDataIns getGroupChatFriendWithGroupID:_newRecent.recentID];
            if (groupFriends) {
                int countFriends = (int)[groupFriends count];
                for (int j = 0; j < countFriends; j++) {
                    
                    NSManagedObject *_chatGroupFriend = [groupFriends objectAtIndex:j];
                    int _friendID = [[_chatGroupFriend valueForKey:@"friend_id"] intValue];
                    
                    Friend *_newFriend = [self getFriendByID:_friendID];
                    if (_newFriend && _newFriend.friendID > 0) {
                        
                        [_newRecent.friendRecent addObject:_newFriend];
                        
                    }else{
                        [_newFriend setFriendID:[[_chatGroupFriend valueForKey:@"friend_id"] intValue]];
                        [_newFriend setNickName:[_chatGroupFriend valueForKey:@"nick_name"]];
                        [_newFriend setUrlAvatar:[_chatGroupFriend valueForKey:@"url_avatar"]];
                        [_newFriend setUrlThumbnail:[_chatGroupFriend valueForKey:@"url_thumbnail"]];
                        [_newFriend setUserName:[_chatGroupFriend valueForKey:@"user_name"]];
                        
                        [_newRecent.friendRecent addObject:_newFriend];
                    }
                }
            }
            
            NSMutableArray *groupMessages = [coziCoreDataIns getGroupChatMessageWithGroupID:_newRecent.recentID];
            if (groupMessages) {
                int countMessages = (int)[groupMessages count];
                for (int j = 0; j < countMessages; j++) {
                    
                    NSManagedObject *_chatGroupMessage = [groupMessages objectAtIndex:j];
                    
                    Messenger *_newMessage = [Messenger new];
                    [_newMessage setAmazonKey:[_chatGroupMessage valueForKey:@"amazon_key"]];
                    [_newMessage setFriendID:[[_chatGroupMessage valueForKey:@"friend_id"] intValue]];
                    [_newMessage setIsTimeOut:[[_chatGroupMessage valueForKey:@"is_timeout"] boolValue]];
                    [_newMessage setKeySendMessage:[_chatGroupMessage valueForKey:@"key_send_message"]];
                    [_newMessage setLatitude:[_chatGroupMessage valueForKey:@"latitude"]];
                    [_newMessage setLongitude:[_chatGroupMessage valueForKey:@"longitude"]];
                    [_newMessage setStatusMessage:[[_chatGroupMessage valueForKey:@"status_messenger"] intValue]];
                    [_newMessage setStrMessage:[_chatGroupMessage valueForKey:@"str_messenger"]];
                    [_newMessage setStrImage:[_chatGroupMessage valueForKey:@"strImage"]];
                    [_newMessage setTimeMessage:[_chatGroupMessage valueForKey:@"time_messenger"]];
                    [_newMessage setTimeServerMessage:[_chatGroupMessage valueForKey:@"time_server"]];
                    [_newMessage setTimeOutMessenger:[[_chatGroupMessage valueForKey:@"timeout_messenger"] intValue]];
                    [_newMessage setTypeMessage:[[_chatGroupMessage valueForKey:@"type_messenger"] intValue]];
                    [_newMessage setUrlImage:[_chatGroupMessage valueForKey:@"url_image"]];
                    [_newMessage setUserID:[[_chatGroupMessage valueForKey:@"user_id"] intValue]];
                    
                    [_newRecent.messengerRecent addObject:_newMessage];
                }
            }
            
            //progress thumbnail
            //check messenger > 4
            //if in 4 - 1 isexists user
            UIImage *imgGroupChatMessage = [self renderGroupImageWithMessage:_newRecent.messengerRecent];
            UIImage *imgGroupChatFriend = [self renderGroupImageWithFriend:_newRecent.friendRecent];
            
            _newRecent.thumbnail = imgGroupChatFriend;
            
            [recents addObject:_newRecent];
            
            [self.recent addObject:_newRecent];
        }
    }
    
    return recents;
}

- (void) insertGroupChat:(Recent*)_recent{
    BOOL isSave = [coziCoreDataIns saveGroupChat:_recent];
    if (isSave) {
        [coziCoreDataIns saveGroupChatFriend:_recent];
        //save message
        if (_recent.messengerRecent) {
            int count = (int)[_recent.messengerRecent count];
            for (int i = 0; i < count; i++) {
                Messenger *_message = [_recent.messengerRecent objectAtIndex:i];
                [coziCoreDataIns saveGroupChatMessage:_message withGroupID:_recent.recentID];
            }
        }
    }
}

- (void) updateGroupChat:(Recent*)_recent{
    [coziCoreDataIns updateGroupChat:_recent];
}

#pragma -mark Group Chat Friend
- (NSMutableArray*) getGroupChatFriendByGroupID:(int)_groupID{
    return [coziCoreDataIns getGroupChatFriendWithGroupID:_groupID];
}

- (void) insertGroupChatFriend:(Recent*)_recent{
    [coziCoreDataIns saveGroupChatFriend:_recent];
}

- (void) updateGroupChatFriend:(Friend*)_friend withGroupChatID:(int)_groupChatID{
    [coziCoreDataIns updateGroupChatFriend:_friend withGroupChatID:_groupChatID];
}

#pragma -mark Group Chat Messages
//Group Chat Message
- (NSMutableArray *) getGroupChatMessageByGroupID:(int)_groupID{
    return [coziCoreDataIns getGroupChatMessageWithGroupID:_groupID];
}

- (NSMutableArray *) getGroupChatMessageWithFriend:(int)_groupID withFriendID:(int)_friendID{
    return [coziCoreDataIns getGroupChatMessageWithUserID:_groupID withFriendID:_friendID];
}

- (void) insertGroupChatMessage:(Messenger*)_message withGroupID:(int)_groupID{
    [coziCoreDataIns saveGroupChatMessage:_message withGroupID:_groupID];
}

- (void) updateGroupChatMessage:(Messenger*)_message{
    [coziCoreDataIns updateGroupChatMessage:_message];
}

- (void) deleteGroupChatMessage:(NSString*)_keyMessage{
    [coziCoreDataIns deleteGroupChatMessage:_keyMessage];
}
@end
