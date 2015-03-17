//
//  ViewController+NetworkCommunication.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController+NetworkCommunication.h"
#import "ViewController+Notification.h"

@implementation ViewController (NetworkCommunication)

static NSString         *dataNet;
static NSString         *dataNetwork;

- (void) initNetwork{
    self.networkIns = [NetworkCommunication shareInstance];
    [self.networkIns setDelegate:self];
    [self.networkIns connectSocket];
}

- (void) notifyData:(NSString *)_data{
    
    dataNetwork = [[NSString alloc] init];
    dataNetwork = _data;
    
//    dataNetwork = [dataNetwork stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subMain = [dataNetwork componentsSeparatedByString:@"<EOF>"];
    if ([subMain count] > 0) {
        int count = (int)[subMain count];
        for (int i = 0; i < count; i++) {
            if (![[subMain objectAtIndex:i] isEqualToString:@""]) {
                
                NSArray *subCommand = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                
                //Login Result
                if ([[subCommand objectAtIndex:0] isEqualToString:@"LOGIN"]) {
                    dataNet = [[NSString alloc] init];
                    dataNet = _data;
//                    loginQueue = [NSOperationQueue new];
                    
                    int userID = -1;
                    NSString *data = [dataNet stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
                    
                    NSArray *subCommand = [data componentsSeparatedByString:@"{"];
                    NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    if ([subData count] > 0) {
                        NSArray *subParameter = [[subData objectAtIndex:0] componentsSeparatedByString:@"}"];
                        if ([[subParameter objectAtIndex:0] intValue] > 0) {
                            userID = [[subParameter objectAtIndex:0] intValue];
                            NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
                            [_default setBool:YES forKey:@"IsLogin"];
                            [_default setInteger:[[subParameter objectAtIndex:0] integerValue] forKey:@"UserID"];
                            [_default setInteger:[[subParameter objectAtIndex:0] integerValue] forKey:@"keyMessage"];
                            [_default setObject:[subParameter objectAtIndex:5] forKey:@"accessKey"];
                            [_default setObject:self.loginPageV3.txtPasswordSignIn.text forKey:@"password"];
                        }
                    }
                    
                    if (userID > 0) {

                        [self.dataMapIns mapLogin:data];
                        
                        [self.storeIns loadMessenger];
                        
                        [self.storeIns processSaveCoreData];
                        
                        [self.storeIns sortMessengerFriend];
                        
                        [self.loginPageV3 showHiddenProgress:NO];
                        
                        [self.loginPageV3.view setHidden:YES];
                        
                        [self setup];
                        
                        [self initializeGestures];
                        
                        [self.chatViewPage initLibraryImage];
                        
                        [self loadFriendComplete:nil];
                        
                        dataNet = nil;
                        
                        [self.loginPageV3 resetFormLogin];
                        
                        NSString *firstCall = @"-1";
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, [self.helperIns encodedBase64:[firstCall dataUsingEncoding:NSUTF8StringEncoding]]]];
                        
                        NSString *strKey = [self.helperIns encodedBase64:[@"-1" dataUsingEncoding:NSUTF8StringEncoding]];
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", strKey]];
                        
                        [self setStatusRequestFriend];
                    }else{
                        
                        [self.loginPageV3 resetFormLogin];
                        
                        [self.loginPageV3 showHiddenProgress:NO];
                        [self.loginPageV3 showHiddenPopupWarning:NO withWarning:@""];
                        [self.loginPageV3 showHiddenPopupWarning:YES withWarning:@"Invalid username or password"];
                        
                        [self.networkIns connectSocket];
                        
                        NSLog(@"Login that bai");
                    }
                }
                
                //Register
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
                    NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    if ([subData count] > 1) {
                        
                        NSArray *subResult = [[subData objectAtIndex:0] componentsSeparatedByString:@"}"];
                        self.storeIns.user.userID = [[subResult objectAtIndex:0] intValue];
                        self.storeIns.user.firstname = self.loginPageV3.txtFirstName.text;
                        self.storeIns.user.lastName = self.loginPageV3.txtLastName.text;
                        self.storeIns.user.nickName = [NSString stringWithFormat:@"%@ %@", self.loginPageV3.txtFirstName.text, self.loginPageV3.txtLastName.text];
                        self.storeIns.user.phoneNumber = self.loginPageV3.txtPhoneNumber.text;
                        self.storeIns.user.urlThumbnail = [NSString stringWithFormat:@"%@%@", self.loginPageV3.amazonThumbnail.url, self.loginPageV3.amazonThumbnail.key];
                        self.storeIns.user.urlAvatar = [NSString stringWithFormat:@"%@%@", self.loginPageV3.amazonAvatar.url, self.loginPageV3.amazonAvatar.key];
                        self.storeIns.user.accessKey = [subResult objectAtIndex:1];
                        self.storeIns.user.avatar = self.loginPageV3.vPreviewPhoto.imgViewCapture.image;
                        //                        [self.storeIns.user setBirthDay:[subParameter objectAtIndex:2]];
                        //                        [self.storeIns.user setGender:[self.helperIns decode:[subParameter objectAtIndex:3]]];
                        
                        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
                        [_default setBool:YES forKey:@"IsLogin"];
                        [_default setInteger:self.storeIns.user.userID forKey:@"UserID"];
                        [_default setObject:self.storeIns.user.accessKey forKey:@"accessKey"];
                        [_default setObject:self.loginPageV3.txtPassword.text forKey:@"password"];
                        
                        //Add Info User
                        
                        NSString *strThumbnail = [NSString stringWithFormat:@"%@%@", self.loginPageV3.amazonThumbnail.url, self.loginPageV3.amazonThumbnail.key];
                        
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            
                            if (image && finished) {
                                [self.storeIns.user setThumbnail:image];
                                
                                NSArray *subUrl = [strThumbnail componentsSeparatedByString:@"/"];
                                [self.helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                            }
                            
                        }];
                        
                        [self.storeIns.user setUrlThumbnail:strThumbnail];
                        
                        NSString *strAvatar = [NSString stringWithFormat:@"%@%@", self.loginPageV3.amazonAvatar.url, self.loginPageV3.amazonAvatar.key];
                        
                        if (![strAvatar isEqualToString:@""]) {
                            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strAvatar] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                
                                if (image && finished) {
                                    [self.storeIns.user setAvatar:image];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                                    
                                    NSArray *subUrl = [strThumbnail componentsSeparatedByString:@"/"];
                                    [self.helperIns saveImageToDocument:image withName:[subUrl lastObject]];
                                }
                                
                            }];
                        }else{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserComplete" object:nil];
                        }
                        
                        [self.storeIns.user setUrlAvatar:strAvatar];
                        [self.storeIns.user setIsPublic:1];
                        [self.storeIns.user setCountPosts:0];
                        
                        [self.storeIns processSaveCoreData];
                        
                        [self initRightMenu];
                        
                        [self.loginPageV3 showHiddenProgress:NO];
                        
                        [self.loginPageV3.view setHidden:YES];
                        
                        [self setup];
                        
                        [self initializeGestures];
                        
                        [self.chatViewPage initLibraryImage];
                        
                        dataNet = nil;
                        
                        [self.loginPageV3 resetFormLogin];
                        
                        NSString *firstCall = @"-1";
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, [self.helperIns encodedBase64:[firstCall dataUsingEncoding:NSUTF8StringEncoding]]]];
                        
                        NSString *strKey = [self.helperIns encodedBase64:[@"-1" dataUsingEncoding:NSUTF8StringEncoding]];
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", strKey]];
                    }else{
                        NSLog(@"new user error");
                        
                        [self.loginPageV3 resetFormLogin];
                        
                        [self.loginPageV3 showHiddenProgress:NO];
                        [self.loginPageV3 showHiddenPopupWarning:NO withWarning:@""];
                        [self.loginPageV3 showHiddenPopupWarning:YES withWarning:@"Invalid username or password"];
                        
                        [self.networkIns connectSocket];
                    }
                }
                
                //Reconnect To Server
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECONNECT"]) {
                    
                    if ([[subCommand objectAtIndex:1] intValue] > 0) {
                        [self.dataMapIns mapReconnect:[subMain objectAtIndex:i]];
                        
                        NSTimer *_timerTick = [[NSTimer alloc] initWithFireDate:self.storeIns.timeServer interval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
                        NSRunLoop *runner = [NSRunLoop currentRunLoop];
                        [runner addTimer:_timerTick forMode:NSDefaultRunLoopMode];
                        
                        if (!isEnterBackground) {
                            //add home page
                            [self.homePageV6 setHidden:NO];
                            
//                            [self.homePageV6.scCollection reloadData];
                            
                            [self.view bringSubviewToFront:self.homePageV6];
                        }
                        
//                        [self.storeIns sortMessengerFriend];
                    
                        [self.homePageV6.scCollection reloadData];

                        NSString *firstCall = @"-1";
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, [self.helperIns encodedBase64:[firstCall dataUsingEncoding:NSUTF8StringEncoding]]]];
                        
                        
//                        CGFloat columns = self.bounds.size.width / (self.itemSize.width + self.itemInsets.left + self.interItemSpacingY);
//                        CGFloat _columnFlood = floor(columns);
//                        CGFloat _columnMinus = columns - _columnFlood;
//                        CGFloat _columnResult = 0.0;
//                        if (_columnMinus > 0.8) {
//                            _columnResult = round(columns);
//                        }else{
//                            _columnResult = _columnFlood;
//                        }
//                        
//                        CGFloat widthCell = ((self.bounds.size.width - ((_columnResult -1) * 4)) / _columnResult);
//                        widthCell = widthCell < 100 ? 100 : widthCell;
//                        
//                        self.itemSize = CGSizeMake(widthCell, widthCell);
                        CGFloat w = self.noisePageV6.itemSize.width;
                        CGFloat r = (roundf(mainScroll.bounds.size.height / w) * 2) + 1;
                        int iItem = r * self.noisePageV6.numberOfColumns;
                        
                        NSString *strKey = [self.helperIns encodedBase64:[@"-1" dataUsingEncoding:NSUTF8StringEncoding]];
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{%i}%@<EOF>", iItem, strKey]];
                        
                        [self.view endEditing:YES];
                    }else{
                        [self logout];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDMESSAGE"]) {
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        if ([[subValue objectAtIndex:1] intValue] < 0) {
                            
                            Messenger *_lastMessage = [self.chatViewPage.recentIns.friendIns.friendMessage lastObject];
                            
                            [_lastMessage setStatusMessage:3];
                            
                        }else{
                            
                            NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            Friend *_tempFriend = [self.storeIns getFriendByID:[[subParameter objectAtIndex:1] intValue]];
                            
                            [self progressRecent:_tempFriend];
                            
                            [self.storeIns updateStatusMessageFriend:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[subParameter objectAtIndex:2] withStatus:1 withTime:[subParameter objectAtIndex:0]];
                            
                            Messenger *_messenger =[self.storeIns getMessageFriendID:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[subParameter objectAtIndex:2]];
                            
                            [self.coziCoreDataIns saveMessenger:_messenger];
                            
                            [self.chatViewPage autoScrollTbView];
                        }
                    }
                }
                
                //Receive Message Text
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEMESSAGE"]) {
                    Messenger *_newMessage = [self.dataMapIns mapReceiveMessage:[subMain objectAtIndex:i]];
                    
                    Friend *_tempFriend = [self.dataMapIns processReceiveMessage:_newMessage];
                    
                    Recent *_recent = [Recent new];
                    [_recent setRecentID:_tempFriend.friendID];
                    [_recent setTypeRecent:0];
                    [_recent setThumbnail:_tempFriend.thumbnail];
                    [_recent setUrlThumbnail:_tempFriend.urlThumbnail];
                    [_recent setNameRecent:_tempFriend.nickName];
                    [_recent setFriendIns:_tempFriend];
                    _recent.friendRecent = [NSMutableArray new];
                    _recent.messengerRecent = [NSMutableArray new];
                    
                    if (self.chatViewPage != nil && self.chatViewPage.recentIns.friendIns.friendID > 0 && isVisibleChatView) {
                        if (_tempFriend.friendID == self.chatViewPage.recentIns.friendIns.friendID) {
                            
                            [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                            
                            self.chatViewPage.recentIns = _recent;
//                            [self.chatViewPage addFriendIns:_tempFriend];
                            
                            [self.chatViewPage autoScrollTbView];
                            
                        }else{
                            
                            [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                            
                            [self progressRecent:_tempFriend];
                            
                        }
                    }else{
                        [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                        
                        [self progressRecent:_tempFriend];
                        
                    }
                    
                    [self.homePageV6.scCollection reloadData];
                    
                    [self vibrate];
                    
                    [self playSoundSystem];
                    
                    [self.coziCoreDataIns saveMessenger:_newMessage];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDLOCATION"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    
                    [self.storeIns updateStatusMessageFriend:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[subParameter objectAtIndex:2] withStatus:1 withTime:[subParameter objectAtIndex:0]];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[subParameter objectAtIndex:2]];
                    
//                    [self.chatViewPage autoScrollTbView];
                    
                    [self.coziCoreDataIns saveMessenger:_messenger];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVELOCATION"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    Messenger *_newMessage = [[Messenger alloc] init];
                    
                    [_newMessage setThumnail:nil];
                    [_newMessage setDataImage:nil];
                    [_newMessage setStatusMessage:1];
                    [_newMessage setTypeMessage:2];
                    [_newMessage setSenderID:[[subParameter objectAtIndex:0] intValue]];
                    [_newMessage setFriendID:[[subParameter objectAtIndex:0] intValue]];
                    _newMessage.longitude = [subParameter objectAtIndex:1];
                    _newMessage.latitude = [subParameter objectAtIndex:2];
                    _newMessage.keySendMessage = [subParameter objectAtIndex:3];
                    [_newMessage setUserID:self.storeIns.user.userID];
                    
                    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                    NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:4]];
                    NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                    
                    [_newMessage setTimeOutMessenger:[[subParameter objectAtIndex:5] intValue]];
                    
                    [_newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subParameter objectAtIndex:4]]];
                    [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                    
                    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _newMessage.latitude, _newMessage.longitude, @"%7c" , _newMessage.latitude, _newMessage.longitude];
                    _newMessage.urlImage = url;
                    
                    //process show message in chatview
                    Friend *_tempFriend = [self.dataMapIns processReceiveMessage:_newMessage];
                    
                    Recent *_recent = [Recent new];
                    [_recent setRecentID:_tempFriend.friendID];
                    [_recent setTypeRecent:0];
                    [_recent setThumbnail:_tempFriend.thumbnail];
                    [_recent setUrlThumbnail:_tempFriend.urlThumbnail];
                    [_recent setNameRecent:_tempFriend.nickName];
                    [_recent setFriendIns:_tempFriend];
                    _recent.friendRecent = [NSMutableArray new];
                    _recent.messengerRecent = [NSMutableArray new];
                    
                    [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                    
                    if (self.chatViewPage && self.chatViewPage.recentIns.friendIns.friendID > 0 && isVisibleChatView) {
                        if (_tempFriend.friendID == self.chatViewPage.recentIns.friendIns.friendID) {
                            
                            self.chatViewPage.recentIns = _recent;
//                            [self.chatViewPage addFriendIns:_tempFriend];
                            
                            [self.chatViewPage autoScrollTbView];
                            
                        }else{

                            [self progressRecent:_tempFriend];
                            
                        }
                    }else{
                        
                        [self progressRecent:_tempFriend];
                        
                    }
                    
                    [self.homePageV6.scCollection reloadData];
                    
                    [self vibrate];
                    
                    [self playSoundSystem];
                    
                    [self.coziCoreDataIns saveMessenger:_newMessage];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"LOCATIONISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[subParameter objectAtIndex:1] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[subParameter objectAtIndex:1]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    if (self.chatViewPage && self.chatViewPage.recentIns.friendIns.friendID == _messenger.friendID && isVisibleChatView) {
                        [self.chatViewPage.tbView reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"MESSAGEISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[subParameter objectAtIndex:1] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[subParameter objectAtIndex:1]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    if (self.chatViewPage && self.chatViewPage.recentIns.friendIns.friendID == _messenger.friendID && isVisibleChatView) {
                        [self.chatViewPage.tbView reloadData];
                    }
                }
                
                //Get Url Upload Image to Amazon
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADAMAZONEURL"]) {
                    AmazonInfo *amazonInfomation = [self.dataMapIns mapAmazonInfo:[subMain objectAtIndex:i]];
                    
                    if (amazonInfomation != nil) {
                        
                        [self.storeIns fillAmazonInfomation:amazonInfomation];
                        
                        [self.storeIns updateKeyAmazone:amazonInfomation.userReceiveID withKeyMessage:amazonInfomation.keyMessage withKeyAmazon:amazonInfomation.key withUrl:[NSString stringWithFormat:@"%@%@", amazonInfomation.url, amazonInfomation.key]];
                    }
                }
                
                //Result Upload Photo
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADPHOTO"]) {
                    NSArray *subCommand = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        if ([[subCommand objectAtIndex:1] intValue] < 0) {
                            //send to friend
                            
                        }else{
                            
                            NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            int userReceiveID = [[subParameter objectAtIndex:0] intValue];
                            NSString *keyMessage = [subParameter objectAtIndex:1];
                            
                            [self.storeIns updateStatusMessageFriendWithKey:userReceiveID withMessageID:keyMessage  withStatus:1];
                            Messenger *lastMessage = [self.storeIns getMessageFriendID:userReceiveID withKeyMessage:keyMessage];
                            
                            NSString *cmd = [self.dataMapIns commandSendPhoto:userReceiveID withKey:lastMessage.amazonKey withKeyMessage:keyMessage withTimeout:0];
                            [self.networkIns sendData:cmd];
                            
                            [self.storeIns updateStatusSendImage];
                        }
                    }
                }
                
                //Send Photo to friend
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDPHOTO"]) {
                    NSArray *subCommand = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        
                        NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                        
                        if (![[subParameter objectAtIndex:1] isEqualToString:@"1"]) {
                            
                            int friendID = [[subParameter objectAtIndex:1] intValue];
                            NSString *keyMessage = [subParameter objectAtIndex:2];
                            [self.storeIns updateStatusMessageFriend:friendID withKeyMessage:keyMessage withStatus:1 withTime:[subParameter objectAtIndex:0]];
                            
                            [self.chatViewPage autoScrollTbView];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                Messenger *_messenger = [self.storeIns getMessageFriendID:friendID withKeyMessage:keyMessage];
                                [self.coziCoreDataIns saveMessenger:_messenger];
                            });
                            
                            //Get Friend
                            Friend *_tempFriend = [self.storeIns getFriendByID:friendID];
                            
                            [self progressRecent:_tempFriend];
                            
                            
                            [self.homePageV6.scCollection reloadData];

                        }else{
                            
                            //Send Photo Failse
                            NSLog(@"Send Photo Failed");
                        }
                    }
                
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"BEGINRECEIVEPHOTO"]) {
                    
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                            
                            Messenger *newMessage = [[Messenger alloc] init];
                            [newMessage setSenderID:[[subParameter objectAtIndex:0] intValue]];
                            [newMessage setFriendID:[[subParameter objectAtIndex:0] intValue]];
                            [newMessage setKeySendMessage:[subParameter objectAtIndex:1]];
                            [newMessage setTypeMessage:1];
                            [newMessage setStatusMessage:0];
                            [newMessage setDataImage:nil];
                            [newMessage setThumnail:nil];
                            [newMessage setIsTimeOut:YES];
                            [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
                            
                            Friend *_tempFriend = [self.dataMapIns processReceiveMessage:newMessage];
                            
                            Recent *_recent = [Recent new];
                            _recent.recentID = _tempFriend.friendID;
                            _recent.typeRecent = 0;
                            _recent.thumbnail = _tempFriend.thumbnail;
                            _recent.urlThumbnail = _tempFriend.urlThumbnail;
                            _recent.nameRecent = _tempFriend.nickName;
                            _recent.friendIns = _tempFriend;
                            _recent.friendRecent = [NSMutableArray new];
                            _recent.messengerRecent = [NSMutableArray new];
                            
                            if (self.chatViewPage != nil && self.chatViewPage.recentIns.friendIns.friendID > 0 && isVisibleChatView) {
                                if (self.chatViewPage.recentIns.friendIns.friendID == _tempFriend.friendID) {
                                    Messenger *_lastMessage = [self.chatViewPage.recentIns.friendIns.friendMessage lastObject];
                                    [_lastMessage setStatusMessage:1];
                                    
                                    [self.storeIns updateStatusMessageFriend:_lastMessage.friendID withStatus:1];
                                    
                                    if (self.chatViewPage.recentIns.friendIns.friendID == _tempFriend.friendID) {
                                        
                                        self.chatViewPage.recentIns = _recent;
//                                        [self.chatViewPage addFriendIns:_tempFriend];
                                        
                                        [self.chatViewPage autoScrollTbView];
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"STOPRECEIVEPHOTO"]) {
                    
                }
                
                //Receive Photo Message
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEPHOTO"]) {
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                
                            Messenger *newMessage = [[Messenger alloc] init];
                            [newMessage setTypeMessage:1];
                            [newMessage setStatusMessage:1];
                            [newMessage setSenderID: [[subParameter objectAtIndex:0] intValue]];
                            [newMessage setFriendID: [[subParameter objectAtIndex:0] intValue]];
                            [newMessage setStrMessage: [self.helperIns decode:[subParameter objectAtIndex:1]]];
                            [newMessage setUrlImage: [self.helperIns decode:[subParameter objectAtIndex:1]]];
                            [newMessage setKeySendMessage:[subParameter objectAtIndex:2]];
                            [newMessage setUserID:self.storeIns.user.userID];
                            
                            NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                            NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:3]];
                            NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                            
                            [newMessage setTimeOutMessenger:[[subParameter objectAtIndex:4] intValue]];
                            
                            [newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subParameter objectAtIndex:3]]];
                            [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                            
                            Friend *_tempFriend = [self.storeIns getFriendByID:[[subParameter objectAtIndex:0] intValue]];
                            
                            Recent *_recent = [Recent new];
                            _recent.recentID = _tempFriend.friendID;
                            _recent.typeRecent = 0;
                            _recent.thumbnail = _tempFriend.thumbnail;
                            _recent.urlThumbnail = _tempFriend.urlThumbnail;
                            _recent.nameRecent = _tempFriend.nickName;
                            _recent.friendIns = _tempFriend;
                            _recent.friendRecent = [NSMutableArray new];
                            _recent.messengerRecent = [NSMutableArray new];
                            
                            if (self.chatViewPage && self.chatViewPage.recentIns.friendIns.friendID > 0 && isVisibleChatView) {
                                
                                if (self.chatViewPage.recentIns.friendIns.friendID == _tempFriend.friendID) {
                                    
//                                    [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                                    
                                    [self.storeIns updateMessageFriend:newMessage withFriendID:_tempFriend.friendID];
                                    
                                    self.chatViewPage.recentIns = _recent;
//                                    [self.chatViewPage addFriendIns:_tempFriend];
                                    
                                    [self.chatViewPage autoScrollTbView];

                                }else{
//                                    [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                                    [self.storeIns updateMessageFriend:newMessage withFriendID:_tempFriend.friendID];
                                    
                                    [self progressRecent:_tempFriend];
                                    
                                }
                            }else{
//                                [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                                [self.storeIns updateMessageFriend:newMessage withFriendID:_tempFriend.friendID];
                                
                                [self progressRecent:_tempFriend];
                            }
                            
                            [self.homePageV6.scCollection reloadData];
                            
                            [self vibrate];
                            
                            [self playSoundSystem];
                            
                            [self.coziCoreDataIns saveMessenger:newMessage];
                            
                        }
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"PHOTOISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[subParameter objectAtIndex:1] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[subParameter objectAtIndex:1]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    if (self.chatViewPage && self.chatViewPage.recentIns.friendIns.friendID == _messenger.friendID && isVisibleChatView) {
                        [self.chatViewPage.tbView reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"DIS"]) {
                    [self logout];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FRIENDLOGIN"]) {
                    int friendID = [[subCommand objectAtIndex:1] intValue];
                    [self.storeIns updateStatusFriend:friendID withStatus:1];
                    
                    [self.homePageV6.scCollection reloadData];
                    [tbContact reloadData];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FRIENDLOGOUT"]) {
                    int friendID = [[subCommand objectAtIndex:1] intValue];
                    [self.storeIns updateStatusFriend:friendID withStatus:0];
                    
                    [self.homePageV6.scCollection reloadData];
                    
                    [tbContact reloadData];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REG"]) {

                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"AUTHCODE"]) {

                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADAVATARURL"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADAVATAR"]) {
                    [netController setResult:_data];
                }
                
//                if ([[subCommand objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
//                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
//                    
//                    //process data
//                    NSArray *subCommand = [[subParameter objectAtIndex:0] componentsSeparatedByString:@"}"];
//                    int userID = [[subCommand objectAtIndex:0] intValue];
//                    if (userID > 0) {
//                        
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsLogin"];
//                        [[NSUserDefaults standardUserDefaults] setInteger:[[subCommand objectAtIndex:0] integerValue] forKey:@"UserID"];
//                        [[NSUserDefaults standardUserDefaults] setInteger:[[subCommand objectAtIndex:1] integerValue] forKey:@"accessKey"];
//                        
//                        [self.loginPage stopLoadingView];
//                        
//                        [self.loginPage removeFromSuperview];
//                        
//                        [self setup];
//                        
//                        [self initializeGestures];
//                        
//                        [self.view bringSubviewToFront:self.homePageV6];
//                        [self.homePageV6.scCollection reloadData];
//                        
//                    }else{
//                        //alert wrong data
//                        [self.loginPage stopLoadingView];
//                        
//                    }
//                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVEMESSAGE"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVEMESSAGE"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVEPHOTO"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVEPHOTO"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVELOCATION"]) {
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVELOCATION"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    if (self.chatViewPage && isVisibleChatView) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETWALL"]) {
                    
                    if (isFirstLoadWall) {
                        
                        if (self.storeIns.walls == nil) {
                            self.storeIns.walls = [NSMutableArray new];
                        }
                        [self.storeIns.walls removeAllObjects];
                        [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:0];
                        isFirstLoadWall = NO;
                        
                    }else{
                        [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:0];
                    }
                    
                    if ([[subCommand objectAtIndex:1] isEqualToString:@"0"]) {
                        [self.wallPageV8 stopLoadWall:YES];
                    }else{
                        [self.wallPageV8 stopLoadWall:NO];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.vLineFirstStatusConnect.layer removeAllAnimations];
                        [self.vLineSecondStatusConnect.layer removeAllAnimations];
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            
//                            [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, heightStatusBar - 5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
//                            [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, heightStatusBar - 5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
                            
                            [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, (heightStatusBar + heightHeader), self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
                            [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, heightStatusBar + heightHeader, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];

                            
                        } completion:^(BOOL finished) {
                            
//                            [self setStatusRequestFriend];
                            
                            [self.vLineFirstStatusConnect setHidden:YES];
                            [self.vLineSecondStatusConnect setHidden:YES];
                            
                            [self.vLineFirstStatusConnect setFrame:CGRectMake(0, (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];
                            [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];
                            
                        }];
                        
                    });
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETNOISE"]) {
                    if (isFirstLoadNoise) {
                        [self.storeIns.noises removeAllObjects];
                        NSMutableArray *result = [self.dataMapIns mapDataNoises:[subCommand objectAtIndex:1]];
//                        self.storeIns.noises = result;
                        isFirstLoadNoise = NO;
//                        [self.noisePageV6.scCollection stopLoadNoise:NO];
                    }else{
                        NSMutableArray *result = [self.dataMapIns mapDataNoises:[subCommand objectAtIndex:1]];
//                        [self.noisePageV6.scCollection reloadVisibleCell:result];
                    }
                    
                    if ([[subCommand objectAtIndex:1] isEqualToString:@"0"]) {
                        [self.noisePageV6.scCollection stopLoadNoise:YES];
                    }else{
                        [self.noisePageV6.scCollection stopLoadNoise:NO];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADPOSTURL"]) {

                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADPOSTIMAGE"]) {

                    [netController setResult:_data];
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"ADDPOST"]) {

                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"ADDPOSTLIKE"]) {
                
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] > 1) {
                        NSString *decodeClientKey = [self.helperIns decode:[subParameter objectAtIndex:1]];
                        
                        int userPost = [[subParameter objectAtIndex:2] intValue];
                        DataWall *_wall = [self.storeIns getWall:decodeClientKey withUserPost:userPost];
                        if (_wall) {
                            [_wall setTimeLike:[subParameter objectAtIndex:0]];
                            [_wall setIsLike:YES];
                            
                            PostLike *_newLike = [PostLike new];
                            _newLike.dateLike = [subParameter objectAtIndex:0];
                            _newLike.userLikeId =self.storeIns.user.userID;
                            _newLike.firstName = self.storeIns.user.firstname;
                            _newLike.lastName = self.storeIns.user.lastName;
                            _newLike.urlAvatarThumb = self.storeIns.user.urlThumbnail;
                            _newLike.urlAvatarFull = self.storeIns.user.urlAvatar;
                            
                            [_wall.likes addObject:_newLike];
                            
                            [self.storeIns updateWall:decodeClientKey withUserPost:userPost withData:_wall];
                        }
                        
                        DataWall *noise = [self.storeIns getPostFromNoise:decodeClientKey withUserPostID:userPost];
                        if (noise) {
                            [noise setTimeLike:[subParameter objectAtIndex:0]];
                            [noise setIsLike:YES];
                            
                            PostLike *_newLike = [PostLike new];
                            _newLike.dateLike = [subParameter objectAtIndex:0];
                            _newLike.userLikeId =self.storeIns.user.userID;
                            _newLike.firstName = self.storeIns.user.firstname;
                            _newLike.lastName = self.storeIns.user.lastName;
                            _newLike.urlAvatarThumb = self.storeIns.user.urlThumbnail;
                            _newLike.urlAvatarFull = self.storeIns.user.urlAvatar;
                            
                            [noise.likes addObject:_newLike];
                            
                            [self.storeIns updateNoise:decodeClientKey withUserPost:userPost withData:noise];;
                        }

                        [self.wallPageV8 stopLoadWall:NO];
                        
                        [netController setResult:_data];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NTFPOSTLIKE"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    NSString *decodeClientKey = [self.helperIns decode:[subParameter objectAtIndex:1]];
                    
                    int userPost = [[subParameter objectAtIndex:2] intValue];
                    DataWall *_wall = [self.storeIns getWall:decodeClientKey withUserPost:userPost];

                    PostLike *_newLike = [PostLike new];
                    _newLike.dateLike = [subParameter objectAtIndex:0];
                    _newLike.userLikeId = [[subParameter objectAtIndex:3] intValue];
                    _newLike.firstName = [self.helperIns decode:[subParameter objectAtIndex:4]];
                    _newLike.lastName = [self.helperIns decode:[subParameter objectAtIndex:5]];
                    _newLike.urlAvatarThumb = [self.helperIns decode:[subParameter objectAtIndex:6]];
                    _newLike.urlAvatarFull  = [self.helperIns decode:[subParameter objectAtIndex:7]];
                    
                    [_wall.likes addObject:_newLike];
                    
                    [self.storeIns updateWall:decodeClientKey withUserPost:(int)[subParameter objectAtIndex:2] withData:_wall];
                    
                    [self reloadWall];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVEPOSTLIKE"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] > 1) {
                        NSString *decodeClientKey = [self.helperIns decode:[subParameter objectAtIndex:1]];
                        
                        int userPost = [[subParameter objectAtIndex:2] intValue];
                        DataWall *_wall = [self.storeIns getWall:decodeClientKey withUserPost:userPost];
                        if (_wall == nil) {
                            _wall = [self.storeIns getPostFromNoise:decodeClientKey withUserPostID:userPost];
                        }
                        
                        [_wall setTimeLike:[subParameter objectAtIndex:0]];
                        [_wall setIsLike:NO];
                        
                        PostLike *_newLike = [PostLike new];
                        _newLike.dateLike = [subParameter objectAtIndex:0];
                        _newLike.userLikeId = self.storeIns.user.userID;
                        _newLike.firstName = self.storeIns.user.firstname;
                        _newLike.lastName = self.storeIns.user.lastName;
                        
                        if (_wall.likes != nil && [_wall.likes count] > 0) {
                            int count = (int)[_wall.likes count];
                            for (int i = 0; i < count; i++) {
                                if ([[_wall.likes objectAtIndex:i] userLikeId] == _newLike.userLikeId) {
                                    
                                    [_wall.likes removeObjectAtIndex:i];
                                    break;
                                }
                            }
                        }
                        [_wall.likes removeObject:_newLike];
                        
                        [self.storeIns updateWall:decodeClientKey withUserPost:(int)[subParameter objectAtIndex:2] withData:_wall];
                        [self.storeIns updateNoise:decodeClientKey withUserPost:userPost withData:_wall];
                        
                        [self.wallPageV8 stopLoadWall:NO];

                        [netController setResult:_data];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NTFPOSTUNLIKE"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    NSString *decodeClientKey = [self.helperIns decode:[subParameter objectAtIndex:1]];
                    
                    int userPost = [[subParameter objectAtIndex:2] intValue];
                    DataWall *_wall = [self.storeIns getWall:decodeClientKey withUserPost:userPost];
                    
                    [_wall setTimeLike:[subParameter objectAtIndex:0]];
                    if (userPost == self.storeIns.user.userID) {
                        [_wall setIsLike:NO];
                    }
                    
                    PostLike *_newLike = [PostLike new];
                    _newLike.dateLike = [subParameter objectAtIndex:0];
                    _newLike.userLikeId = [[subParameter objectAtIndex:3] intValue];
                    _newLike.firstName = [self.helperIns decode:[subParameter objectAtIndex:4]];
                    _newLike.lastName = [self.helperIns decode:[subParameter objectAtIndex:5]];
                    
                    if (_wall.likes != nil && [_wall.likes count] > 0) {
                        int count = (int)[_wall.likes count];
                        for (int i = 0; i < count; i++) {
                            if ([[_wall.likes objectAtIndex:i] userLikeId] == _newLike.userLikeId) {
                                
                                [_wall.likes removeObjectAtIndex:i];
                                break;
                            }
                        }
                    }
                    
                    [self.storeIns updateWall:decodeClientKey withUserPost:(int)[subParameter objectAtIndex:2] withData:_wall];
                    
                    [self.wallPageV8 stopLoadWall:NO];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERPROFILE"]) {

                    [netController setResult:_data];
                    
                    //if is friend request then update info use
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    Friend *_friend = [Friend new];
                    int friendID = [[subParameter objectAtIndex:4] intValue];
                    if (self.storeIns.recent) {
                        int count = (int)[self.storeIns.recent count];
                        for (int i = 0; i < count; i++) {
                            if ([[self.storeIns.recent objectAtIndex:i] recentID] == friendID && [[[self.storeIns.recent objectAtIndex:i] friendIns] isFriendWithYour] == 1) {
                                _friend = [[self.storeIns.recent objectAtIndex:i] friendIns];
//                                [self.storeIns.recent removeObjectAtIndex:i];
                     
                                if (_friend && _friend.friendID > 0) {
                                    _friend.birthDay = [subParameter objectAtIndex:10];
                                    _friend.gender = [self.helperIns decode:[subParameter objectAtIndex:11]];
                                    _friend.relationship = [self.helperIns decode:[subParameter objectAtIndex:12]];
                                    _friend.userName = [self.helperIns decode:[subParameter objectAtIndex:5]];
                                    _friend.firstName = [self.helperIns decode:[subParameter objectAtIndex:6]];
                                    _friend.lastName = [self.helperIns decode:[subParameter objectAtIndex:7]];
                                    [_friend setStatusAddFriend:0];
                                    _friend.isFriendWithYour = 0;
                                    _friend.userID = self.storeIns.user.userID;
                                    
                                    [self.storeIns.friends addObject:_friend];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationReloadListFriend" object:nil userInfo:nil];
                                    
                                    CoziCoreData *cz = [CoziCoreData shareInstance];
                                    
                                    [cz saveFriend:_friend];
                                }
                                
                                break;
                            }
                        }
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERPOST"]) {
                    
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"USERADDFOLLOW"]) {
                    
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"ADDCOMMENT"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NTFCOMMENT"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] > 1) {
                        
                        PostComment *_newComment = [PostComment new];
                        _newComment.dateComment = [self.helperIns convertStringToDate:[subParameter objectAtIndex:0]];
                        _newComment.postClientKey = [subParameter objectAtIndex:1];
                        _newComment.userCommentId = [[subParameter objectAtIndex:3] intValue];
                        _newComment.firstName = [subParameter objectAtIndex:4];
                        _newComment.lastName = [subParameter objectAtIndex:5];
                        _newComment.urlAvatarThumb = [subParameter objectAtIndex:6];
                        _newComment.urlAvatarFull = [subParameter objectAtIndex:7];
                        
                        if (self.storeIns.walls) {
                            int count = (int)[self.storeIns.walls count];
                            for (int i = 0; i < count; i++) {
                                if ([[[self.storeIns.walls objectAtIndex:i] clientKey] isEqualToString:_newComment.postClientKey]) {
                                    if ([[self.storeIns.walls objectAtIndex:i] comments] == nil) {
                                        ((DataWall*)[self.storeIns.walls objectAtIndex:i]).comments = [NSMutableArray new];
                                    }
                                    [[[self.storeIns.walls objectAtIndex:i] comments] addObject:_newComment];
                                    break;
                                }
                            }
                        }
                        
                        if (self.storeIns.noises) {
                            int count = (int)[self.storeIns.noises count];
                            for (int i = 0; i < count; i++) {
                                if ([[[self.storeIns.noises objectAtIndex:i] clientKey] isEqualToString: _newComment.postClientKey]) {
                                    if ([[self.storeIns.noises objectAtIndex:i] comments] == nil) {
                                        ((DataWall*)[self.storeIns.noises objectAtIndex:i]).comments = [NSMutableArray new];
                                    }
                                    [[[self.storeIns.noises objectAtIndex:i] comments] addObject:_newComment];
                                    break;
                                }
                            }
                        }
                    
                        
                    }

                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERFOLLOWER"]) {
                    [netController setResult:_data];
                }

                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERFOLLOWING"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"USERREMOVEFOLLOW"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"LOGOUT"]) {
                    [self.networkIns connectSocket];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERBYSTRING"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDFRIENDREQUEST"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEFRIENDREQUEST"]) {
                    
//                    [netController setResult:_data];
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] == 1) {//Deny
//                        int _friendID = [[subParameter objectAtIndex:0] intValue];
                    }
                    
                    if ([subParameter count] == 2) { //Error Code
//                        int friendID = [[subParameter objectAtIndex:1] intValue];
//                        int errorCode = [[subParameter objectAtIndex:0] intValue];
                    }
                    
                    if ([subParameter count] == 3) {
                        int friendID = [[subParameter objectAtIndex:2] intValue];
                        NSString *phoneNumber = [subParameter objectAtIndex:0];
                        int isOnline = [[subParameter objectAtIndex:1] intValue];
                        
                        if (self.storeIns.recent) {
                            int count = (int)[self.storeIns.recent count];
                            for (int i = 0; i < count; i++) {
                                if ([[self.storeIns.recent objectAtIndex:i] recentID] == friendID) {
                                    
                                    [[[self.storeIns.recent objectAtIndex:i] friendIns] setPhoneNumber:phoneNumber];
                                    [[[self.storeIns.recent objectAtIndex:i] friendIns] setStatusFriend:isOnline];
                                    
                                    //call get user profile
                                    [netController getUserProfile:friendID];
                                    
                                    break;
                                }
                            }
                        }
                        
                        if (isVisibleChatView) { //Chat View is visible
                            [self.chatViewPage.vRequestChat setHidden:YES];
                            [self.chatViewPage.chatToolKit setHidden:NO];
                        }
                        
                    }
                    
                    if ([[subCommand objectAtIndex:1] isEqualToString:@"0"]) {
                        
//                        [netController getUserProfile:friendRequest.friendID];
                        
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FRIENDREQUEST"]) {
                    NSArray *subFriendRequest = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subFriendRequest count] > 1) {
                        
                        Friend *_friend = [Friend new];
                        _friend.isFriendWithYour = 1;
                        [_friend setUserID:self.storeIns.user.userID];
                        _friend.friendID = [[subFriendRequest objectAtIndex:0] intValue];
                        _friend.firstName = [self.helperIns decode:[subFriendRequest objectAtIndex:1]];
                        _friend.lastName = [self.helperIns decode:[subFriendRequest objectAtIndex:2]];
                        [_friend setNickName:[NSString stringWithFormat:@"%@ %@", _friend.firstName, _friend.lastName]];
                        [_friend setUrlThumbnail:[self.helperIns decode:[subFriendRequest objectAtIndex:3]]];
                        [_friend setUrlAvatar:[self.helperIns decode:[subFriendRequest objectAtIndex:4]]];
                    
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
                        
//                        if (self.storeIns.recent == nil) {
//                            self.storeIns.recent = [NSMutableArray new];
//                        }
//                        
//                        //find friend recent list
//                        int indexRecent = -1;
//                        BOOL isExists = NO;
//                        
//                        int count = (int)[self.storeIns.recent count];
//                        for (int i = 0; i < count; i++) {
//                            if ([[self.storeIns.recent objectAtIndex:i] recentID] == _friend.friendID) {
//                                isExists = YES;
//                                indexRecent = i;
//                                break;
//                            }
//                        }
//                        
//                        if (!isExists) {
//                            [self.storeIns.recent addObject:_friend];
//                            [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
//                        }else{
//                            Friend *_tempFriend = [self.storeIns.recent objectAtIndex:indexRecent];
//                            [self.storeIns.recent removeObjectAtIndex:indexRecent];
//                            [self.storeIns.recent insertObject:_tempFriend atIndex:0];
//                            
//                            [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
//                            
//                        }
                        
                        [self.homePageV6.scCollection reloadData];

                        [self playSoundSystem];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTFRIENDREQUEST"]) {
                    //Notifi allow add friend
                    NSArray *subResutlAddFriend = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subResutlAddFriend count] > 1) {
                        int status = [[subResutlAddFriend objectAtIndex:1] intValue];
                        
                        if (status == 0) {//Denies
                            [self.storeIns progressResultAddFriend:[[subResutlAddFriend objectAtIndex:0] intValue] withIsAllow:NO];
                        }
                        
                        if (status == 1) {//Accept
                            [self.storeIns progressResultAddFriend:[[subResutlAddFriend objectAtIndex:0] intValue] withIsAllow:YES];
                        }
                        
                        [tbContact initData:self.storeIns.friends];
                        [tbContact reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FINDUSERINRANGE"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"ADDGROUP"]) {
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"USERADDGROUP"]) {
                    NSArray *subValue = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    if ([subValue count] == 2) {
                        NSArray *subGroup = [[subValue objectAtIndex:0] componentsSeparatedByString:@"}"];
                        NSArray *subFriend = [[subValue objectAtIndex:1] componentsSeparatedByString:@"$"];
                        
                        Recent *_newRecent = [Recent new];
                        _newRecent.recentID = [[subGroup objectAtIndex:0] intValue];
                        _newRecent.nameRecent = [self.helperIns decode:[subGroup objectAtIndex:1]];
                        _newRecent.typeRecent = 1;
                        _newRecent.friendRecent = [NSMutableArray new];
                        _newRecent.userID = self.storeIns.user.userID;
                        _newRecent.messengerRecent = [NSMutableArray new];
                        
                        //Map Friend List
                        if ([subFriend count] > 0) {
                            int count = (int)[subFriend count];
                            for (int i = 0; i < count; i++) {
                                NSArray *subFriendInfo = [[subFriend objectAtIndex:i] componentsSeparatedByString:@"}"];
                                if ([subFriendInfo count] > 1) {
                                    Friend *_friendInfo = [Friend new];
                                    _friendInfo.friendID = [[subFriendInfo objectAtIndex:0] intValue];
                                    _friendInfo.firstName = [self.helperIns decode:[subFriendInfo objectAtIndex:1]];
                                    _friendInfo.lastName = [self.helperIns decode:[subFriendInfo objectAtIndex:2]];
                                    _friendInfo.nickName = [NSString stringWithFormat:@"%@ %@", _friendInfo.firstName, _friendInfo.lastName];
                                    _friendInfo.urlThumbnail = [self.helperIns decode:[subFriendInfo objectAtIndex:3]];
                                    _friendInfo.urlAvatar = [self.helperIns decode:[subFriendInfo objectAtIndex:4]];
                                    
                                    [_newRecent.friendRecent addObject:_friendInfo];
                                }
                            }
                        }
                        
                        //Map Default Message
                        //Add Default Messenger
                        Friend *_friendCreateGroup = [self.storeIns getFriendByID:[[subGroup objectAtIndex:2] intValue]];
                        if (_friendCreateGroup && _friendCreateGroup.friendID > 0) {
                            
                            NSString *_keyMessage = [self.storeIns randomKeyMessenger];
                            Messenger *_newMessage = [[Messenger alloc] init];
                            [_newMessage setStrMessage: [NSString stringWithFormat:@"%@ %@", _friendCreateGroup.nickName, @"start new group chat"]];
                            [_newMessage setTypeMessage:0];
                            [_newMessage setStatusMessage:1];
                            [_newMessage setKeySendMessage:_keyMessage];
                            [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
                            [_newMessage setDataImage:nil];
                            [_newMessage setThumnail:nil];
                            [_newMessage setSenderID:_friendCreateGroup.friendID];
                            [_newMessage setFriendID:_friendCreateGroup.friendID];
                            [_newMessage setUserID:self.storeIns.user.userID];
                            
                            [_newRecent.messengerRecent addObject:_newMessage];
                        }

                        [self.storeIns.recent insertObject:_newRecent atIndex:0];
                        
                        [self.homePageV6.scCollection reloadData];
                        
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDGROUPMESSAGE"]) {
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        
                        if ([[subValue objectAtIndex:1] intValue] < 0) {
                            
                            Messenger *_lastMessage = [self.chatViewPage.recentIns.friendIns.friendMessage lastObject];
                            
                            [_lastMessage setStatusMessage:3];
                            
                        }else{
                            
                            NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            Recent *_recent = [self.storeIns getGroupChatByGroupID:[[subParameter objectAtIndex:1] intValue]];

                            [self progressGroupChat:_recent];
                            
                            [self.storeIns updateStatusGroupMessage:_recent.recentID withKeyMessage:[subParameter objectAtIndex:2] withStatus:1 withTime:[subParameter objectAtIndex:0]];
                            
                            //get message and save to database
                            Messenger *_message = nil;
                            if ([_recent.messengerRecent count] > 0) {
                                int count = (int)[_recent.messengerRecent count];
                                for (int i = 0 ; i < count; i++) {
                                    if ([[[_recent.messengerRecent objectAtIndex:i] keySendMessage] isEqualToString:[subParameter objectAtIndex:2]]) {
                                        _message = [_recent.messengerRecent objectAtIndex:i];
                                        
                                        break;
                                    }
                                }
                            }
                            
                            if (_message) {
                                [self.coziCoreDataIns saveGroupChatMessage:_message withGroupID:_recent.recentID];
                            }
                            
                            [self.chatViewPage autoScrollTbView];
                        }
                    }

                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEGROUPMESSAGE"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] > 1) {
                        Messenger *_newMessage = [Messenger new];
                        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                        NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:3]];
                        NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                        
                        [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                        
                        _newMessage.statusMessage = 1;
                        _newMessage.typeMessage = 0;
                        _newMessage.userID = self.storeIns.user.userID;
                        _newMessage.friendID = [[subParameter objectAtIndex:0] intValue];
                        _newMessage.strMessage = [subParameter objectAtIndex:1];
                        _newMessage.keySendMessage = [subParameter objectAtIndex:2];
                        _newMessage.timeServerMessage = [self.helperIns convertNSStringToDate:[subParameter objectAtIndex:3]];
                        _newMessage.timeOutMessenger = [[subParameter objectAtIndex:4] intValue];
                        
                        Recent *group = [self.storeIns getGroupChatByGroupID:[[subParameter objectAtIndex:5] intValue]];
                        [group.messengerRecent addObject:_newMessage];
                        
                        if (self.chatViewPage != nil && self.chatViewPage.recentIns.recentID > 0 && isVisibleChatView) {
                            if (group.recentID == self.chatViewPage.recentIns.recentID) {
                                
                                self.chatViewPage.recentIns = group;
                                
                                [self.chatViewPage autoScrollTbView];
                                
                            }else{
                                
                                [self progressGroupChat:group];
                                
                            }
                        }else{
                            
                            [self progressGroupChat:group];
                            
                        }
                        
                        [self.homePageV6.scCollection reloadData];
                        
                        [self vibrate];
                        
                        [self playSoundSystem];
                        
                        [self.coziCoreDataIns saveGroupChatMessage:_newMessage withGroupID:group.recentID];
                        
                    }
                    
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETGROUPUPLOADAMAZONEURL"]) {
                    
                    AmazonInfo *amazonInfomation = [self.dataMapIns mapAmazonInfo:[subMain objectAtIndex:i]];
                    
                    if (amazonInfomation != nil) {
                        
                        [self.storeIns fillAmazonInfomation:amazonInfomation];
                        
                        [self.storeIns updateKeyAmazoneForGroupChat:amazonInfomation.userReceiveID withKeyMessage:amazonInfomation.keyMessage withKeyAmazon:amazonInfomation.keyMessage withUrl:[NSString stringWithFormat:@"%@%@", amazonInfomation.url, amazonInfomation.key]];
                        
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADGROUPPHOTO"]) {
                    
                    NSArray *subCommand = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        if ([[subCommand objectAtIndex:1] intValue] < 0) {
                            //send to friend
                            
                        }else{
                            
                            NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            int userReceiveID = [[subParameter objectAtIndex:0] intValue];
                            NSString *keyMessage = [subParameter objectAtIndex:1];
                            
                            Recent *group = [self.storeIns getGroupChatByGroupID:userReceiveID];
                            if ([group.messengerRecent count] > 0) {
                                int count = (int)[group.messengerRecent count];
                                for (int i = 0; i < count; i++) {
                                    if ([[[group.messengerRecent objectAtIndex:i] keySendMessage] isEqualToString:keyMessage]) {
                                        Messenger *_message = [group.messengerRecent objectAtIndex:i];
                                        NSString *cmd = [NSString stringWithFormat:@"SENDGROUPPHOTO{%i}%@}%@}%i<EOF>", userReceiveID, _message.amazonKey,keyMessage, 0];
                                        [self.networkIns sendData:cmd];
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDGROUPPHOTO"]) {
                    
                    NSArray *subCommand = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        
                        NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                        
                        if (![[subParameter objectAtIndex:1] isEqualToString:@"1"]) {
                            
                            int groupID = [[subParameter objectAtIndex:1] intValue];
                            NSString *keyMessage = [subParameter objectAtIndex:2];
                            
                            [self.storeIns updateStatusGroupMessage:groupID withKeyMessage:keyMessage withStatus:1 withTime:[subParameter objectAtIndex:0]];
                            
                            [self.chatViewPage autoScrollTbView];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                Messenger *_messenger = [self.storeIns getMessageGroupID:groupID withKeyMessage:keyMessage];
                                [self.coziCoreDataIns saveGroupChatMessage:_messenger withGroupID:groupID];
                            });
                            
                            //Get Group
                            Recent *group = [self.storeIns getGroupChatByGroupID:groupID];
                            
                            [self progressGroupChat:group];
                            
                            [self.homePageV6.scCollection reloadData];
                            
                        }else{
                            
                            //Send Photo Failse
                            NSLog(@"Send Photo Failed");
                        }
                    }
                    
                    [self.storeIns updateStatusSendImage];
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"BEGINRECEIVEGROUPPHOTO"]) {
                    
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                            
                            Messenger *newMessage = [[Messenger alloc] init];
                            [newMessage setSenderID:[[subParameter objectAtIndex:0] intValue]];
                            [newMessage setKeySendMessage:[subParameter objectAtIndex:1]];
                            [newMessage setTypeMessage:1];
                            [newMessage setStatusMessage:0];
                            [newMessage setDataImage:nil];
                            [newMessage setThumnail:nil];
                            [newMessage setIsTimeOut:YES];
                            [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
                            
                            Recent *_group = [self.storeIns getGroupChatByGroupID:[[subParameter objectAtIndex:2] intValue]];
                            [_group.messengerRecent addObject:newMessage];
                            
                            if (self.chatViewPage != nil && self.chatViewPage.recentIns.recentID > 0 && isVisibleChatView) {
                                if (self.chatViewPage.recentIns.recentID == _group.recentID) {

                                    [self.chatViewPage autoScrollTbView];
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEGROUPPHOTO"]) {
                    
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                            
                            Recent *_group = [self.storeIns getGroupChatByGroupID:[[subParameter objectAtIndex:0] intValue]];
                            Messenger *_newMessage = [self.storeIns getMessageGroupID:_group.recentID withKeyMessage:[subParameter objectAtIndex:2]];
                            [_newMessage setUrlImage:[subParameter objectAtIndex:1]];
                            
                            NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                            NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:3]];
                            NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                            
                            [_newMessage setTimeOutMessenger:[[subParameter objectAtIndex:4] intValue]];
                            
                            [_newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subParameter objectAtIndex:3]]];
                            [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                            
                            if (self.chatViewPage && self.chatViewPage.recentIns.recentID > 0 && isVisibleChatView) {
                                
                                if (self.chatViewPage.recentIns.recentID == _group.recentID) {
                                    
                                    [self.chatViewPage autoScrollTbView];
                                    
                                }else{
                                    
                                    [self progressGroupChat:_group];
                                    
                                }
                            }else{

                                [self progressGroupChat:_group];
                            }
                            
                            [self.homePageV6.scCollection reloadData];
                            
                            [self vibrate];
                            
                            [self playSoundSystem];
                            
                            [self.coziCoreDataIns saveGroupChatMessage:_newMessage withGroupID:_group.recentID];
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    
}

- (void) notifyStatus:(int)code{
    switch (code) {
        case 1:
        {
            self.storeIns.isConnected = YES;

            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
            [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
            
            [self.scrollHeader setFrame:CGRectMake(0, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
            
            NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
            BOOL _isLogin = [_default boolForKey:@"IsLogin"];
            if (_isLogin) {
                
                NSString *accessKey = [_default stringForKey:@"accessKey"];
                
                NSString *strPass = [_default stringForKey:@"password"];
                NSString *hashPass = [self.helperIns encoded:strPass withKey:accessKey];
                NSInteger _userID = [_default integerForKey:@"UserID"];
                NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                NSString *_deviceToken = [NSString stringWithFormat:@"%@", token];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
                _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
                
                NSString *str = [NSString stringWithFormat:@"RECONNECT{%d}%@}%@}%@}%@}1<EOF>", (int)_userID, hashPass, [self.storeIns getLongitude], [self.storeIns getlatitude], _deviceToken];
                
                [self.networkIns sendData:str];
            }
        }
            break;
            
        case -1:{
            self.storeIns.isConnected = NO;
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void) progressGroupChat:(Recent*)_recent{
    
    //find friend recent list
    int indexRecent = -1;
    BOOL isExists = NO;
    
    int count = (int)[self.storeIns.recent count];
    for (int i = 0; i < count; i++) {
        if ([[self.storeIns.recent objectAtIndex:i] recentID] == _recent.recentID) {
            isExists = YES;
            indexRecent = i;
            break;
        }
    }
    
    if (!isExists) {
        //        Recent *_newRecent = [Recent new];
        //        _newRecent.recentID = _friend.friendID;
        //        _newRecent.typeRecent = 0;
        //        _newRecent.thumbnail = _friend.thumbnail;
        //        _newRecent.urlThumbnail = _friend.urlThumbnail;
        //        _newRecent.nameRecent = _friend.nickName;
        //        _newRecent.friendIns = _friend;
        //        //property group chat
        //        _newRecent.friendRecent = [NSMutableArray new];
        //        _newRecent.messengerRecent = [NSMutableArray new];
        //
        [self.storeIns.recent insertObject:_recent atIndex:0];
    }else{
        
        Recent *_recent = [self.storeIns.recent objectAtIndex:indexRecent];
        [self.storeIns.recent removeObjectAtIndex:indexRecent];
        [self.storeIns.recent insertObject:_recent atIndex:0];
        
    }
}

- (void) progressRecent:(Friend*)_tempFriend{
    
    if (self.storeIns.recent == nil) {
        self.storeIns.recent = [NSMutableArray new];
    }
    
    //find friend recent list
    int indexRecent = -1;
    BOOL isExists = NO;
    
    int count = (int)[self.storeIns.recent count];
    for (int i = 0; i < count; i++) {
        if ([[self.storeIns.recent objectAtIndex:i] recentID] == _tempFriend.friendID) {
            isExists = YES;
            indexRecent = i;
            break;
        }
    }
    
    if (!isExists) {
        Recent *_newRecent = [Recent new];
        _newRecent.recentID = _tempFriend.friendID;
        _newRecent.typeRecent = 0;
        _newRecent.thumbnail = _tempFriend.thumbnail;
        _newRecent.urlThumbnail = _tempFriend.urlThumbnail;
        _newRecent.nameRecent = _tempFriend.nickName;
        _newRecent.friendIns = _tempFriend;
        //property group chat
        _newRecent.friendRecent = [NSMutableArray new];
        _newRecent.messengerRecent = [NSMutableArray new];
        
        [self.storeIns.recent addObject:_newRecent];
        [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
    }else{
        Recent *_recent = [self.storeIns.recent objectAtIndex:indexRecent];
        //                                Friend *_tempFriend = [self.storeIns getFriendByID:_recent.recentID];
        [self.storeIns.recent removeObjectAtIndex:indexRecent];
        [self.storeIns.recent insertObject:_recent atIndex:0];
        
        [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
        
    }
}

@end
