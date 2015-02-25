//
//  ViewController+NetworkCommunication.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController+NetworkCommunication.h"

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
                    loginQueue = [NSOperationQueue new];
                    
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
                        }
                    }
                    
                    if (userID > 0) {
                        //Load Friend from database
//                        [waitingReconnect stopAnimating];
                        
                        [self.dataMapIns mapLogin:data];
                        
                        [self.storeIns loadMessenger];
                        
                        [self.storeIns processSaveCoreData];
                        
                        [self.storeIns sortMessengerFriend];
                        
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
                        
                        [self setStatusRequestFriend];
                    }else{
                        [self.loginPageV3 resetFormLogin];
                        
                        [self.loginPageV3 showHiddenProgress:NO];
                        [self.loginPageV3 showHiddenPopupWarning:NO withWarning:@""];
                        [self.loginPageV3 showHiddenPopupWarning:YES withWarning:@"Invalid username or password"];
                        
                        [self.networkIns connectSocket];
                    }
                }
                
                //Register
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
                    NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    if ([subData count] > 0) {
                        
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
                        
                        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
                        [_default setBool:YES forKey:@"IsLogin"];
                        [_default setInteger:self.storeIns.user.userID forKey:@"UserID"];
                        [_default setObject:self.storeIns.user.accessKey forKey:@"accessKey"];
                        [_default setObject:self.loginPageV3.txtPassword.text forKey:@"password"];
                        
                        [self initLeftMenu];
                        
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
                    }
                }
                
                //Reconnect To Server
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECONNECT"]) {
                    
                    if (![[subCommand objectAtIndex:1] isEqualToString:@"-1"]) {
                        [self.dataMapIns mapReconnect:[subMain objectAtIndex:i]];
                        
                        NSTimer *_timerTick = [[NSTimer alloc] initWithFireDate:self.storeIns.timeServer interval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
                        NSRunLoop *runner = [NSRunLoop currentRunLoop];
                        [runner addTimer:_timerTick forMode:NSDefaultRunLoopMode];
                        
                        if (!isEnterBackground) {
                            //add home page
                            [self.loginPage setHidden:YES];
                            [self.homePageV6 setHidden:NO];
                            
                            [self.homePageV6.scCollection reloadData];
                            
                            [self.view bringSubviewToFront:self.homePageV6];
                        }
                        
                        [self.storeIns sortMessengerFriend];
                        
//                        [waitingReconnect stopAnimating];
                        
                        [self setStatusRequestFriend];
                    
                        [self.homePageV6.scCollection reloadData];

                        NSString *firstCall = @"-1";
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, [self.helperIns encodedBase64:[firstCall dataUsingEncoding:NSUTF8StringEncoding]]]];
                        
                        NSString *strKey = [self.helperIns encodedBase64:[@"-1" dataUsingEncoding:NSUTF8StringEncoding]];
                        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", strKey]];
                        
                        [self.view endEditing:YES];
                    }else{
                        [self logout];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDMESSAGE"]) {
                    NSArray *subValue = [[subMain objectAtIndex:i] componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        if ([[subValue objectAtIndex:1] intValue] < 0) {
                            
                            Messenger *_lastMessage = [self.chatViewPage.friendIns.friendMessage lastObject];
                            
                            [_lastMessage setStatusMessage:3];
                            
                        }else{
                            
                            NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            Friend *_tempFriend = [self.storeIns getFriendByID:[[subParameter objectAtIndex:1] intValue]];
                            
                            //find friend recent list
                            int indexRecent = -1;
                            if (self.storeIns.recent != nil) {
                                BOOL isExists = NO;
                                int count = (int)[self.storeIns.recent count];
                                for (int i = 0; i < count; i++) {
                                    if ([[self.storeIns.recent objectAtIndex:i] friendID] == _tempFriend.friendID) {
                                        isExists = YES;
                                        indexRecent = i;
                                        break;
                                    }
                                }
                                
                                if (!isExists) {
                                    [self.storeIns.recent addObject:_tempFriend];
                                }else{
                                    Friend *_temp = [self.storeIns.recent objectAtIndex:indexRecent];
                                    [self.storeIns.recent removeObjectAtIndex:indexRecent];
                                    [self.storeIns.recent insertObject:_temp atIndex:0];
                                }
                                
                                [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                            }
                            
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
//                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    
                    if (self.chatViewPage != nil && self.chatViewPage.friendIns.friendID > 0) {
                        if (_tempFriend.friendID == self.chatViewPage.friendIns.friendID) {
                            
                            [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                            
                            [self.chatViewPage addFriendIns:_tempFriend];
                            
                            [self.chatViewPage autoScrollTbView];
                        }
                    }else{
                        [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                        
                        if (self.storeIns.recent == nil) {
                            self.storeIns.recent = [NSMutableArray new];
                        }
                        //find friend recent list
                        int indexRecent = -1;
                        BOOL isExists = NO;
                        
                        int count = (int)[self.storeIns.recent count];
                        for (int i = 0; i < count; i++) {
                            if ([[self.storeIns.recent objectAtIndex:i] friendID] == _tempFriend.friendID) {
                                isExists = YES;
                                indexRecent = i;
                                break;
                            }
                        }
                        
                        if (!isExists) {
                            [self.storeIns.recent addObject:_tempFriend];
                            [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                        }else{
                            Friend *_tempFriend = [self.storeIns.recent objectAtIndex:indexRecent];
                            [self.storeIns.recent removeObjectAtIndex:indexRecent];
                            [self.storeIns.recent insertObject:_tempFriend atIndex:0];
                            
                            [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                            
                        }
                        
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
                    
                    //save info request google
                    ReceiveLocation *_receiveLocation = [[ReceiveLocation alloc] init];
                    _receiveLocation.friendID = [[subParameter objectAtIndex:0] intValue];
                    _receiveLocation.senderID = [[subParameter objectAtIndex:0] intValue];
                    _receiveLocation.longitude = [subParameter objectAtIndex:1];
                    _receiveLocation.latitude = [subParameter objectAtIndex:2];
                    _receiveLocation.keySendMessage = [subParameter objectAtIndex:3];
                    
                    [self.storeIns.receiveLocation addObject:_receiveLocation];
                    [self.storeIns processReceiveLocation];
                    
                    
                    //process show message in chatview
                    Friend *_tempFriend = [self.dataMapIns processReceiveMessage:_newMessage];
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    
                    [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                    
                    if (temp != nil) {
                        if (_tempFriend.friendID == temp.friendIns.friendID) {
                            
                            [self.chatViewPage addFriendIns:_tempFriend];
                            
                            [self.chatViewPage autoScrollTbView];
                        }
                    }else{
                        [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                        
                        //find friend recent list
                        int indexRecent = -1;
                        if (self.storeIns.recent != nil) {
                            BOOL isExists = NO;
                            int count = (int)[self.storeIns.recent count];
                            for (int i = 0; i < count; i++) {
                                if ([[self.storeIns.recent objectAtIndex:i] friendID] == _tempFriend.friendID) {
                                    isExists = YES;
                                    indexRecent = i;
                                    break;
                                }
                            }
                            
                            if (!isExists) {
                                [self.storeIns.recent addObject:_tempFriend];
                                [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                            }else{
                                Friend *_tempFriend = [self.storeIns.recent objectAtIndex:indexRecent];
                                [self.storeIns.recent removeObjectAtIndex:indexRecent];
                                [self.storeIns.recent insertObject:_tempFriend atIndex:0];
                                
                                [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                            }
                        }
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
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        [temp.tbView reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"MESSAGEISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[subParameter objectAtIndex:1] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[subParameter objectAtIndex:1]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        [temp.tbView reloadData];
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
                            
                            //find friend recent list
                            int indexRecent = -1;
                            if (self.storeIns.recent != nil) {
                                BOOL isExists = NO;
                                int count = (int)[self.storeIns.recent count];
                                for (int i = 0; i < count; i++) {
                                    if ([[self.storeIns.recent objectAtIndex:i] friendID] == _tempFriend.friendID) {
                                        isExists = YES;
                                        indexRecent = i;
                                        break;
                                    }
                                }
                                
                                if (!isExists) {
                                    [self.storeIns.recent addObject:_tempFriend];
                                }else{
                                    Friend *_temp = [self.storeIns.recent objectAtIndex:indexRecent];
                                    [self.storeIns.recent removeObjectAtIndex:indexRecent];
                                    [self.storeIns.recent insertObject:_temp atIndex:0];
                                }
                                
                                [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                            }

                        }else{
                            
                            //Send Photo Failse
                            
                        }
                    }
                    
                    [self.storeIns updateStatusSendImage];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"BEGINRECEIVEPHOTO"]) {
                    
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
                            
                            Friend *_tempFriend = [self.dataMapIns processReceiveMessage:newMessage];
                            
                            ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                            if (temp != nil) {
                                Messenger *_lastMessage = [self.chatViewPage.friendIns.friendMessage lastObject];
                                [_lastMessage setStatusMessage:1];
                                
                                [self.storeIns updateStatusMessageFriend:_lastMessage.friendID withStatus:1];
                                
                                if (temp.friendIns.friendID == _tempFriend.friendID) {
                                    
                                    [self.chatViewPage addFriendIns:_tempFriend];
                                    
                                    [self.chatViewPage autoScrollTbView];
                                }
                            }else{
                                [self.homePageV6.scCollection reloadData];
                            }
                            
                        }
                    }
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
                            
                            if (_tempFriend) {
                                [self.storeIns updateMessageFriend:newMessage withFriendID:_tempFriend.friendID];
                                
                                //find friend recent list
                                int indexRecent = -1;
                                if (self.storeIns.recent != nil) {
                                    BOOL isExists = NO;
                                    int count = (int)[self.storeIns.recent count];
                                    for (int i = 0; i < count; i++) {
                                        if ([[self.storeIns.recent objectAtIndex:i] friendID] == _tempFriend.friendID) {
                                            isExists = YES;
                                            indexRecent = i;
                                            break;
                                        }
                                    }
                                    
                                    if (!isExists) {
                                        [self.storeIns.recent addObject:_tempFriend];
                                        
                                    }else{
                                        Friend *_temp = [self.storeIns.recent objectAtIndex:indexRecent];
                                        [self.storeIns.recent removeObjectAtIndex:indexRecent];
                                        [self.storeIns.recent insertObject:_temp atIndex:0];
                                    }
                                    
                                    [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                                }
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
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        [temp.tbView reloadData];
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
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    
                    //process data
                    NSArray *subCommand = [[subParameter objectAtIndex:0] componentsSeparatedByString:@"}"];
                    int userID = [[subCommand objectAtIndex:0] intValue];
                    if (userID > 0) {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsLogin"];
                        [[NSUserDefaults standardUserDefaults] setInteger:[[subCommand objectAtIndex:0] integerValue] forKey:@"UserID"];
                        [[NSUserDefaults standardUserDefaults] setInteger:[[subCommand objectAtIndex:1] integerValue] forKey:@"accessKey"];
                        
                        [self.loginPage stopLoadingView];
                        
                        [self.loginPage removeFromSuperview];
                        
                        [self setup];
                        
                        [self initializeGestures];
                        
                        [self.view bringSubviewToFront:self.homePageV6];
                        [self.homePageV6.scCollection reloadData];
                        
                    }else{
                        //alert wrong data
                        [self.loginPage stopLoadingView];
                        
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVEMESSAGE"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVEMESSAGE"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVEPHOTO"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVEPHOTO"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"REMOVELOCATION"]) {
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
                        [self.chatViewPage autoScrollTbView];
                        
                    }else{
                        
                        [self.homePageV6.scCollection reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEREMOVELOCATION"]) {
                    
                    [self deleteMessenger:[subCommand objectAtIndex:1]];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        
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
                    
//                    [waitingWall stopAnimating];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.vLineFirstStatusConnect.layer removeAllAnimations];
                        [self.vLineSecondStatusConnect.layer removeAllAnimations];

                        [self.vLineFirstStatusConnect setFrame:CGRectMake(0, -5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
                        [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), -5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
                    });
                    
//                    [UIView animateWithDuration:1.0 delay:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
//                        
//                        
//                    } completion:^(BOOL finished) {
//                        [self.vLineFirstStatusConnect.layer removeAllAnimations];
//                        [self.vLineSecondStatusConnect.layer removeAllAnimations];
//
//                        [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, -5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
//                        [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, -5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
//                    }];
                    
                    
                    [UIView animateWithDuration:5.0 delay:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -heightHeader, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
//                        [viewStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]]];
//                        [lblStatusConnect setText:@"Connecting..."];

//                        [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, -5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
//                        [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, -5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
                        
//                        [self.vLineFirstStatusConnect setHidden:YES];
//                        [self.vLineSecondStatusConnect setHidden:YES];
                        
                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            [self.vLineFirstStatusConnect.layer removeAllAnimations];
//                            [self.vLineSecondStatusConnect.layer removeAllAnimations];
//                            
//                            [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, -5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
//                            [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, -5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
//                        }
                    }];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETNOISE"]) {
                    if (isFirstLoadNoise) {
                        [self.storeIns.noises removeAllObjects];
                        [self.dataMapIns mapDataNoises:[subCommand objectAtIndex:1]];
                        isFirstLoadNoise = NO;
                    }else{
                        [self.dataMapIns mapDataNoises:[subCommand objectAtIndex:1]];
                    }
                    
                    if ([[subCommand objectAtIndex:1] isEqualToString:@"0"]) {
                        [self.noisePageV6.scCollection stopLoadNoise:YES];
                    }else{
                        [self.noisePageV6.scCollection stopLoadNoise:NO];
                    }

//                    [waitingNoise stopAnimating];
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
                        if (_wall == nil) {
                            _wall = [self.storeIns getPostFromNoise:decodeClientKey withUserPostID:userPost];
                        }
                        
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
                        [self.storeIns updateNoise:decodeClientKey withUserPost:userPost withData:_wall];

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
                    _newLike.firstName = [subParameter objectAtIndex:4];
                    _newLike.lastName = [subParameter objectAtIndex:5];
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
                    
//                    [_wall.likes removeObject:_newLike];
                    
                    [self.storeIns updateWall:decodeClientKey withUserPost:(int)[subParameter objectAtIndex:2] withData:_wall];
                    
                    [self.wallPageV8 stopLoadWall:NO];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUSERPROFILE"]) {

                    [netController setResult:_data];
                    
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
                    [netController setResult:_data];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FRIENDREQUEST"]) {
                    NSArray *subFriendRequest = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subFriendRequest count] > 1) {
                        UserSearch *_friendRequest = [UserSearch new];
                        [_friendRequest setUserID:self.storeIns.user.userID];
                        [_friendRequest setFriendID:[[subFriendRequest objectAtIndex:0] intValue]];
                        [_friendRequest setFirstName:[self.helperIns decode:[subFriendRequest objectAtIndex:1]]];
                        [_friendRequest setLastName:[self.helperIns decode:[subFriendRequest objectAtIndex:2]]];
                        [_friendRequest setNickName:[NSString stringWithFormat:@"%@ %@", _friendRequest.firstName, _friendRequest.lastName]];
                        [_friendRequest setUrlAvatar:[self.helperIns decode:[subFriendRequest objectAtIndex:3]]];
                        [_friendRequest setUrlAvatarFull:[self.helperIns decode:[subFriendRequest objectAtIndex:4]]];
                        
                        [self.storeIns.friendsRequest addObject:_friendRequest];
                        
                        [self setStatusRequestFriend];
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
                    
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"FINDUSERINRANGE"]) {
                    [netController setResult:_data];
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

            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
            [self.chatViewPage setFrame:CGRectMake(-self.view.bounds.size.width, 0, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
            
            [scrollHeader setFrame:CGRectMake(0, 0, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
            
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

@end
