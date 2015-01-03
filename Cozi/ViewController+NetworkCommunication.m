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
                    
                    NSString *data = [[NSString alloc] init];
                    int userID = -1;
                    data = [dataNet stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
                    
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
                        
                        [self.dataMapIns mapLogin:data];
                        
                        [self.storeIns loadMessenger];
                        
                        [self.storeIns processSaveCoreData];
                        
                        [self.storeIns sortMessengerFriend];
                        
                        [self.loginPage stopLoadingView];
                        
                        [self.loginPage removeFromSuperview];
                        
                        [self setup];
                        
                        [self initializeGestures];
                        
                        [self.chatViewPage initLibraryImage];
                        
                        //Get wall
                        [self.networkIns sendData:@"GETWALL{<EOF>"];
                        
                        dataNet = nil;
                    }
                }
                
                //Register
                if ([[subCommand objectAtIndex:0] isEqualToString:@"NEWUSER"]) {
                    NSArray *subData = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"~"];
                    if ([subData count] > 0) {
                        
                    }
                }
                
                //Reconnect To Server
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECONNECT"]) {
                    
                    [self.dataMapIns mapReconnect:dataNetwork];
                    
                    NSTimer *_timerTick = [[NSTimer alloc] initWithFireDate:self.storeIns.timeServer interval:1.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
                    NSRunLoop *runner = [NSRunLoop currentRunLoop];
                    [runner addTimer:_timerTick forMode:NSDefaultRunLoopMode];
                    
                    if (!isEnterBackground) {
                        //add home page
                        [self.loginPage setHidden:YES];
                        [self.homePageV6 setHidden:NO];
                        
                        //            CGSize sizeCollection = self.homePageV6.scCollection.collectionViewLayout.collectionViewContentSize;
                        
                        [self.homePageV6.scCollection reloadData];
                        
                        //            [self.homePageV6 setContentSizeContent:sizeCollection];
                        
                        [self.view bringSubviewToFront:self.homePageV6];
                    }
                    
                    [self.storeIns sortMessengerFriend];
                    
                    [self.chatViewPage.tbView reloadData];
                    
                    //Get wall
                    //        [self.networkIns sendData:@"GETWALL{10}-1<EOF>"];
                    NSString *firstCall = @"-1";
                    [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, [self.helperIns encodedBase64:[firstCall dataUsingEncoding:NSUTF8StringEncoding]]]];
                    
                    NSString *strKey = [self.helperIns encodedBase64:[@"-1" dataUsingEncoding:NSUTF8StringEncoding]];
                    [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", strKey]];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDMESSAGE"]) {
                    NSArray *subValue = [dataNetwork componentsSeparatedByString:@"{"];
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
                            
                            
                            [self.storeIns updateStatusMessageFriend:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[[subParameter objectAtIndex:2] integerValue] withStatus:1 withTime:[subParameter objectAtIndex:0]];
                            
                            Messenger *_messenger =[self.storeIns getMessageFriendID:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[[subParameter objectAtIndex:2] integerValue]];
                            
                            [self.coziCoreDataIns saveMessenger:_messenger];
                            
                            [self.chatViewPage autoScrollTbView];
                        }
                    }
                }
                
                //Receive Message Text
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RECEIVEMESSAGE"]) {
                    Messenger *_newMessage = [self.dataMapIns mapReceiveMessage:dataNetwork];
                    
                    Friend *_tempFriend = [self.dataMapIns processReceiveMessage:_newMessage];
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    
                    [self vibrate];
                    
                    [self playSoundSystem];
                    
                    if (temp != nil && page == 0) {
                        if (_tempFriend.friendID == temp.friendIns.friendID) {
                            
                            [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                            
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
                                
                                [self.homePageV6.scCollection reloadData];
                            }
                        }
                        
                    }
                    
                    
                    
                    [self.coziCoreDataIns saveMessenger:_newMessage];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDLOCATION"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    
                    [self.storeIns updateStatusMessageFriend:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[[subParameter objectAtIndex:2] integerValue] withStatus:1 withTime:[subParameter objectAtIndex:0]];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:1] intValue] withKeyMessage:[[subParameter objectAtIndex:2] integerValue]];
                    
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
                    _newMessage.keySendMessage = [[subParameter objectAtIndex:3] integerValue];
                    [_newMessage setUserID:self.storeIns.user.userID];
                    
                    NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                    NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:4]];
                    NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                    
                    [_newMessage setTimeOutMessenger:[[subParameter objectAtIndex:5] intValue]];
                    
                    [_newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subParameter objectAtIndex:4]]];
                    [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                    
                    [self.coziCoreDataIns saveMessenger:_newMessage];
                    
                    //save info request google
                    ReceiveLocation *_receiveLocation = [[ReceiveLocation alloc] init];
                    _receiveLocation.friendID = [[subParameter objectAtIndex:0] intValue];
                    _receiveLocation.senderID = [[subParameter objectAtIndex:0] intValue];
                    _receiveLocation.longitude = [subParameter objectAtIndex:1];
                    _receiveLocation.latitude = [subParameter objectAtIndex:2];
                    _receiveLocation.keySendMessage = [[subParameter objectAtIndex:3] integerValue];
                    
                    [self.storeIns.receiveLocation addObject:_receiveLocation];
                    [self.storeIns processReceiveLocation];
                    
                    [self vibrate];
                    
                    [self playSoundSystem];
                    
                    //process show message in chatview
                    Friend *_tempFriend = [self.dataMapIns processReceiveMessage:_newMessage];
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    
                    [self.storeIns updateStatusMessageFriend:_tempFriend.friendID withStatus:1];
                    
                    if (temp != nil && page == 0) {
                        if (_tempFriend.friendID == temp.friendIns.friendID) {
                            
                            //                Messenger *_lastMessage = [self.chatViewPage.friendIns.friendMessage lastObject];
                            //                [_lastMessage setStatusMessage:1];
                            
                            //                [self.helperIns cacheMessage:_lastMessage.friendID withMessage:_lastMessage];
                            
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
                                
                                [self.homePageV6.scCollection reloadData];
                            }
                        }
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"LOCATIONISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[[subParameter objectAtIndex:1] intValue] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[[subParameter objectAtIndex:1] intValue]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        [temp.tbView reloadData];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"MESSAGEISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[[subParameter objectAtIndex:1] intValue] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[[subParameter objectAtIndex:1] intValue]];
                    
                    [self.coziCoreDataIns updateMessenger:_messenger];
                    
                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                    if (temp != nil) {
                        [temp.tbView reloadData];
                    }
                }
                
                //Get Url Upload Image to Amazon
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADAMAZONEURL"]) {
                    AmazonInfo *amazonInfomation = [self.dataMapIns mapAmazonInfo:dataNetwork];
                    
                    if (amazonInfomation != nil) {
                        
                        [self.storeIns fillAmazonInfomation:amazonInfomation];
                        
                        [self.storeIns updateKeyAmazone:amazonInfomation.userReceiveID withKeyMessage:amazonInfomation.keyMessage withKeyAmazon:amazonInfomation.key];
                    }
                }
                
                //Result Upload Photo
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADPHOTO"]) {
                    NSArray *subCommand = [dataNetwork componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        if ([[subCommand objectAtIndex:1] intValue] < 0) {
                            //send to friend
                            
                        }else{
                            
                            NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                            
                            int userReceiveID = [[subParameter objectAtIndex:0] intValue];
                            NSInteger keyMessage = [[subParameter objectAtIndex:1] integerValue];
                            
                            [self.storeIns updateStatusMessageFriendWithKey:userReceiveID withMessageID:keyMessage  withStatus:1];
                            Messenger *lastMessage = [self.storeIns getMessageFriendID:userReceiveID withKeyMessage:keyMessage];
                            
                            //                AmazonInfo *_amazon = [self.storeIns.sendAmazon firstObject];
                            NSString *cmd = [self.dataMapIns commandSendPhoto:userReceiveID withKey:lastMessage.amazonKey withKeyMessage:keyMessage withTimeout:0];
                            [self.networkIns sendData:cmd];
                        }
                    }
                }
                
                //Send Photo to friend
                if ([[subCommand objectAtIndex:0] isEqualToString:@"SENDPHOTO"]) {
                    NSArray *subCommand = [dataNetwork componentsSeparatedByString:@"{"];
                    if ([subCommand count] == 2) {
                        
                        NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                        
                        int friendID = [[subParameter objectAtIndex:1] intValue];
                        NSInteger keyMessage = [[subParameter objectAtIndex:2] integerValue];
                        [self.storeIns updateStatusMessageFriend:friendID withKeyMessage:keyMessage withStatus:1 withTime:[subParameter objectAtIndex:0]];
                        
                        Messenger *_messenger = [self.storeIns getMessageFriendID:friendID withKeyMessage:keyMessage];
                        
                        [self.chatViewPage autoScrollTbView];
                        
                        [self.coziCoreDataIns saveMessenger:_messenger];
                    }
                    
                    [self.storeIns updateStatusSendImage];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"BEGINRECEIVEPHOTO"]) {
                    
                    NSArray *subValue = [dataNetwork componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                            
                            Messenger *newMessage = [[Messenger alloc] init];
                            [newMessage setSenderID:[[subParameter objectAtIndex:0] intValue]];
                            [newMessage setKeySendMessage:[[subParameter objectAtIndex:1] integerValue]];
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
                    NSArray *subValue = [dataNetwork componentsSeparatedByString:@"{"];
                    if ([subValue count] == 2) {
                        NSArray *subParameter = [[subValue objectAtIndex:1] componentsSeparatedByString:@"}"];
                        if ([subParameter count] > 1) {
                            
                            Friend *_tempFriend = [self.storeIns getFriendByID:[[subParameter objectAtIndex:0] intValue]];
                            
                            [self vibrate];
                            
                            [self playSoundSystem];
                            
                            Messenger *newMessage = [[Messenger alloc] init];
                            [newMessage setTypeMessage:1];
                            [newMessage setStatusMessage:1];
                            [newMessage setSenderID: [[subParameter objectAtIndex:0] intValue]];
                            [newMessage setFriendID: [[subParameter objectAtIndex:0] intValue]];
                            [newMessage setStrMessage: [self.helperIns decode:[subParameter objectAtIndex:1]]];
                            [newMessage setKeySendMessage:[[subParameter objectAtIndex:2] integerValue]];
                            [newMessage setUserID:self.storeIns.user.userID];
                            
                            NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
                            NSDate *timeMessage = [self.helperIns convertStringToDate:[subParameter objectAtIndex:3]];
                            NSDate *_dateTimeMessage = [timeMessage dateByAddingTimeInterval:deltaTime];
                            
                            [newMessage setTimeOutMessenger:[[subParameter objectAtIndex:4] intValue]];
                            
                            [newMessage setTimeServerMessage:[self.helperIns convertStringToDate:[subParameter objectAtIndex:3]]];
                            [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:_dateTimeMessage]];
                            
                            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:newMessage.strMessage] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                
                                if (image && finished) {
                                    
                                    NSString *stringImage = [self.helperIns encodedBase64:data];
                                    UIImage *img = [self.helperIns resizeImage:image resizeSize:CGSizeMake(320, 568)];
                                    
                                    [newMessage setThumnail:img];
                                    
                                    UIImage *imgBlur = [self.helperIns blurWithImageEffectsRestore:img withRadius:50];
                                    [newMessage setThumnailBlur:imgBlur];
                                    [newMessage setStrImage:stringImage];
                                    [newMessage setIsTimeOut:YES];
                                    
                                    [self.storeIns updateMessageFriend:newMessage withFriendID:newMessage.senderID];
                                    
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    ChatView *temp = (ChatView*)[self.view viewWithTag:10000];
                                    if (temp != nil && page == 0) {
                                        
                                        [self.chatViewPage autoScrollTbView];
                                        
                                    }else{
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
                                            [self.homePageV6.scCollection reloadData];
                                        }
                                        
                                        [self.homePageV6.scCollection reloadData];
                                    }
                                    
                                    [self.coziCoreDataIns saveMessenger:newMessage];
                                    
                                });
                                
                            }];
                            
                        }
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"PHOTOISREAD"]) {
                    
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    [self.storeIns updateStatusMessageFriendWithKey:[[subParameter objectAtIndex:0] intValue] withMessageID:[[subParameter objectAtIndex:1] intValue] withStatus:2];
                    
                    Messenger *_messenger = [self.storeIns getMessageFriendID:[[subParameter objectAtIndex:0] intValue] withKeyMessage:[[subParameter objectAtIndex:1] intValue]];
                    
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
                    int result = [[subCommand objectAtIndex:1] intValue];
                    if (result == 0) {
                        [self.loginPage showViewEnterCodeAuth];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"AUTHCODE"]) {
                    int result = [[subCommand objectAtIndex:1] intValue];
                    if (result == 0) {
                        [self.loginPage showViewEnterPerson];
                        
                        NSString *cmdGetUrl = [self.dataMapIns getUploadAvatar];
                        [self.networkIns sendData:cmdGetUrl];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADAVATARURL"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"$"];
                    if ([subParameter count] == 2) {
                        amazonThumbnail = [self.dataMapIns mapAmazonUploadAvatar:[subParameter objectAtIndex:0]];
                        amazonAvatar = [self.dataMapIns mapAmazonUploadAvatar:[subParameter objectAtIndex:1]];
                    }
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADAVATAR"]) {
                    NSArray *subParameter = [[subCommand objectAtIndex:1] componentsSeparatedByString:@"}"];
                    if ([subParameter count] == 2) {
                        int resultAvatar = [[subParameter objectAtIndex:0] intValue];
                        int resultThumbnail = [[subParameter objectAtIndex:1] intValue];
                        
                        if (resultAvatar == 0 && resultThumbnail == 0) {
                            //call function register user
                            NewUser *_newUser = [[NewUser alloc] init];
                            _newUser.nickName = [NSString stringWithFormat:@"%@ %@", self.loginPage.joinNowView.txtFirstN.text, self.loginPage.joinNowView.txtLastN.text];
                            NSString *strBirthDate = self.loginPage.joinNowView.txtBirthDayJoin.text;
                            NSArray *subBirthDate = [strBirthDate componentsSeparatedByString:@"/"];
                            _newUser.birthDay = [subBirthDate objectAtIndex:0];
                            _newUser.birthMonth = [subBirthDate objectAtIndex:1];
                            _newUser.birthYear = [subBirthDate objectAtIndex:2];
                            _newUser.gender = [self.loginPage.joinNowView.btnGender getGender];
                            _newUser.avatarKey = amazonThumbnail.key;
                            _newUser.avatarFullKey = amazonAvatar.key;
                            _newUser.password = self.loginPage.joinNowView.txtPasswordJoin.text;
                            
                            [[NSUserDefaults standardUserDefaults] setObject:_newUser.password forKey:@"password"];
                            
                            NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                            NSString *_deviceToken = [NSString stringWithFormat:@"%@", token];
                            _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
                            _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
                            _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
                            
                            _newUser.deviceToken = _deviceToken;
                            _newUser.longitude = [self.storeIns getLongitude];
                            _newUser.latitude = [self.storeIns getlatitude];
                            _newUser.userName = self.loginPage.joinNowView.txtUserNameJoin.text;
                            _newUser.firstName = self.loginPage.joinNowView.txtFirstN.text;
                            _newUser.lastName = self.loginPage.joinNowView.txtLastN.text;
                            _newUser.leftAvatar = @"0";
                            _newUser.topAvatar = @"0";
                            _newUser.widthAvatar = @"0";
                            _newUser.heightAvatar = @"0";
                            _newUser.scaleAvatar = @"1";
                            _newUser.contacts = contactList;
                            
                            NSString *cmd = [self.dataMapIns cmdNewUser:_newUser];
                            [self.networkIns sendData:cmd];
                            
                        }else{
                            //alert wrong avatar
                        }
                    }
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
                        
                        //            CGSize sizeCollection = self.homePageV6.scCollection.collectionViewLayout.collectionViewContentSize;
                        
                        //            [self.homePageV6 setContentSizeContent:sizeCollection];
                        
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
                        
                        self.storeIns.walls = [NSMutableArray new];
                        NSMutableArray *dataWall = [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:0];
                        isFirstLoadWall = NO;
                    }else{
                        NSMutableArray *dataWall = [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:0];
                    }
                    
//                    [self.wallPageV8 reloadData];
                    if ([[subCommand objectAtIndex:1] isEqualToString:@"0"]) {
                        [self.wallPageV8 stopLoadWall:YES];
                    }else{
                        [self.wallPageV8 stopLoadWall:NO];
                    }
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETNOISE"]) {
                    
                    if (isFirstLoadNoise) {
                        self.storeIns.noises = [NSMutableArray new];
                        NSMutableArray *dataNoise = [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:1];
                        isFirstLoadNoise = NO;
                    }else{
                        NSMutableArray *dataNoise = [self.dataMapIns mapDataWall:[subCommand objectAtIndex:1] withType:1];
                    }
                    
                    [self.noisePageV6.scCollection reloadData];
                    [self.noisePageV6.scCollection stopLoadNoise];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"GETUPLOADPOSTURL"]) {
                    AmazonInfo *_amazonInfo = [self.dataMapIns mapAmazonUploadAvatar:[subCommand objectAtIndex:1]];
                    
                    [postWall setAmazoneUpload:_amazonInfo];
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"RESULTUPLOADPOSTIMAGE"]) {
                    
                    int resultCode = [[subCommand objectAtIndex:1] intValue];
                    [postWall setResultUpload:resultCode];
                    
                }
                
                if ([[subCommand objectAtIndex:0] isEqualToString:@"ADDPOST"]) {
                    
                    DataWall *_dataWall = [postWall getWall];
                    
                    NSData *dataImg = UIImageJPEGRepresentation([_dataWall.images lastObject], 1);
                    NSData *wallData = UIImageJPEGRepresentation(self.storeIns.user.thumbnail, 1);
                    
                    _dataWall.fullName = self.storeIns.user.nickName;
                    [self.wallPage addWallItem:_dataWall avatar:dataImg];
                    //
                    //        [self.wallPage insertWallItem:dataImg avatar:wallData withFullName:self.storeIns.user.nickName itemId:self.storeIns.user.userID];
                    
                    [postWall setResultAddWall:[subCommand objectAtIndex:1]];
                    
                }
                
            }
        }
    }
    
}

- (void) notifyStatus:(int)code{
    switch (code) {
        case 1:
        {
            [viewStatusConnect setHidden:YES];
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
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
            
        default:
            break;
    }
}

@end
