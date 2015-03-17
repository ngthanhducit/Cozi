//
//  ViewController+Notification.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController+Notification.h"

@implementation ViewController (Notification)

- (void) loadMoreWall:(NSNotification*)notification{
    
    if (isConnected == 1) {
        isFirstLoadWall = NO;
        
        DataWall *_wall = [self.storeIns.walls lastObject];
        NSString *_clientKey = [self.helperIns encodedBase64:[_wall.clientKey dataUsingEncoding:NSUTF8StringEncoding]];
        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{10}%@<EOF>", _clientKey]];
    }else{
        [self.wallPageV8 stopRefesh];
    }
    
}

- (void) loadNewWall:(NSNotification*)notification{
    
    if (isConnected == 1) {
        isFirstLoadWall = YES;
        
        NSString *tempKey = @"-1";
        NSString *_clientKey = [self.helperIns encodedBase64:[tempKey dataUsingEncoding:NSUTF8StringEncoding]];
        [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{10}%@<EOF>", _clientKey]];
    }else{
        [self.wallPageV8 stopRefesh];
    }
    
}

- (void) loadMoreNoise:(NSNotification*)notification{
    
    if (isConnected == 1) {
        isFirstLoadWall = NO;
        
        DataWall *_wall = [self.storeIns.noises lastObject];
        NSString *_clientKey = [self.helperIns encodedBase64:[_wall.clientKey dataUsingEncoding:NSUTF8StringEncoding]];
        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", _clientKey]];
    }else{
        [self.wallPageV8 stopRefesh];
    }
}

- (void) loadNewNoise:(NSNotification*)notification{
    
    if (isConnected == 1) {
        isFirstLoadNoise = YES;
        
        NSString *tempKey = @"-1";
        NSString *_clientKey = [self.helperIns encodedBase64:[tempKey dataUsingEncoding:NSUTF8StringEncoding]];
        [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", _clientKey]];
        
    }else{
        [self.wallPageV8 stopRefesh];
    }
}

- (void) tapFriendProfile:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *_friendID = [userInfo valueForKey:@"tapFriend"];
    
    SCFriendProfileViewController *post = [[SCFriendProfileViewController alloc] init];
    [post showHiddenClose:YES];
    
    [post setFriendId:[_friendID intValue]];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) tapMyProfile:(NSNotification*)notification{

    SCProfileViewController *post = [[SCProfileViewController alloc] init];
    [post showHiddenClose:YES];
    [post setProfile:self.storeIns.user];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];

}

- (void) reloadWallAndNoises:(NSNotification*)notification{
    [self.wallPageV8 reloadData];
    [self.wallPageV8 scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.noisePageV6.scCollection reloadData];
}

- (void) selectNoise:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    DataWall *_noise = [userInfo objectForKey:@"selectNoise"];
    NSMutableArray *items = [NSMutableArray new];
    [items addObject:_noise];
    
    SCSinglePostViewController *post = [[SCSinglePostViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    [post setData:items];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) ResignActiveNotification:(NSNotification*)notification{
    isEnterBackground = NO;
}

- (void) EnterBackgroundNotification:(NSNotification*)notification{
    
    [mainScroll setFrame:CGRectMake(0, heightHeader + heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar))];
    [mainScroll setContentOffset:CGPointMake(0, 0)];
    
    [self.scrollHeader setFrame:CGRectMake(0, self.statusBarView.bounds.size.height, self.view.bounds.size.width, heightHeader)];
    [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, heightStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - heightStatusBar)];
    
    isEnterBackground = YES;
    
    currentPage = 0;
    
    [self.networkIns disconnectSocket];
}

- (void) WillEnterForegroundNotification:(NSNotification*)notification{
//    isEnterBackground = NO;
}

- (void) BecomeActiveNotification:(NSNotification*)notification{
    
    if (isEnterBackground) {
        isFirstLoadNoise = YES;
        isFirstLoadWall = YES;
        isVisibleChatView = NO;
        isConnected = -1;
        
        isShow = YES;
        
        [self showShareMenu];
        
        [self.view bringSubviewToFront:viewStatusConnect];
        [self.view bringSubviewToFront:self.vLineFirstStatusConnect];
        [self.view bringSubviewToFront:self.vLineSecondStatusConnect];
        
        [self setupNetworkStatus];
    }
}

- (void)selectFriend:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
//    Friend *_friend  = (Friend*)[userInfo objectForKey:@"tapCellIndex"];
    Recent *_recent  = (Recent*)[userInfo objectForKey:@"tapCellIndex"];
    Friend *_friend = [self.storeIns getFriendByID:_recent.recentID];
    
    if (_friend == nil) {
        _friend = _recent.friendIns;
    }
    
//    [self.chatViewPage addFriendIns:_friend];
    [self.chatViewPage.lblNickName setText:[_friend.nickName uppercaseString]];
    [self.chatViewPage reloadFriend];
    [self.chatViewPage resetUI];
    [self.chatViewPage.tbView setClearData:NO];
    [self.chatViewPage addRecent:_recent];
    [self.chatViewPage.tbView reloadData];
    isVisibleChatView = YES;
    
    [self hiddenMenu];
    
    [self.storeIns playSoundPress];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, mainScroll.frame.origin.y, self.view.bounds.size.width, mainScroll.bounds.size.height)];
        [self.scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
        [self.chatViewPage.view setFrame:CGRectMake(0, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        page = 0;
    }];
    
    //scroll to bottom
    double y = self.chatViewPage.tbView.contentSize.height - self.chatViewPage.tbView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, y);
    
    if (y > -self.chatViewPage.tbView.contentInset.top)
        [self.chatViewPage.tbView setContentOffset:bottomOffset animated:NO];
}


- (void)showListLibrary:(NSNotification*)notification{
    ImageLibraryViewController *imgLibraryView = [[ImageLibraryViewController alloc] init];
    [imgLibraryView initData:[self.storeIns getAssetsThumbnail]];
    UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:imgLibraryView];
    [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
    [naviController setDelegate:self];
    
    [self presentViewController:naviController animated:YES completion:^{
        
    }];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note{
//    return;
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus _status = curReach.currentReachabilityStatus;
    
    switch (_status) {
        case NotReachable:{
            [self showStatusConnected:0];
        }
            break;
            
        case ReachableViaWiFi:{
            
            [self showStatusConnected:1];

        }
            break;
            
        case ReachableViaWWAN:

            [self showStatusConnected:1];
            break;
            
        default:
            break;
    }
}

- (void) loadAssetsComplete:(NSNotification*)notification{
    
    [self.chatViewPage initLibraryImage];
    
}

- (void) loadUserComplete:(NSNotification*)notification{
    [self initLeftMenu];
    
//    [self initRightMenu];
    
}

- (void) loadFriendComplete:(NSNotification *)notification{
    [self initRightMenu];
}

//- (void) loadFriendComplete:(NSNotification*)notification{
//    [self.homePageV6.scCollection reloadData];
//}

- (void) loadWallComplete:(NSNotification*)notification{
    
    [self.wallPageV8 reloadData];
    [self.noisePageV6.scCollection reloadData];
}

- (void) notificationSelectContact:(NSNotification*)notification{
    NSDictionary *_userInfo = [notification userInfo];
    NSNumber *countSelectContact = [_userInfo valueForKey:@"countSelect"];
    
    if ([countSelectContact intValue] > 1) {//Group Chat
        inShowButtonStartChat = YES;
        
        if (self.btnNewChat.frame.origin.y == self.view.bounds.size.height - (heightHeader + heightStatusBar)) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.btnNewChat.frame.origin.y - self.btnNewChat.bounds.size.height, self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, tbContact.bounds.size.height - self.btnNewChat.bounds.size.height)];
            } completion:^(BOOL finished) {
                inShowButtonStartChat = NO;
            }];
        }else{

            if (!isGroupChat) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                    [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];

                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.btnNewChat.frame.origin.y - self.btnNewChat.bounds.size.height, self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                        [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, tbContact.bounds.size.height - self.btnNewChat.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        inShowButtonStartChat = NO;
                        isGroupChat = YES;
                    }];
                    
                }];
            }
            
        }
        
        [self.btnNewChat setTitle:@"START GROUP CHAT" forState:UIControlStateNormal];
        
    }else if ([countSelectContact intValue] == 1){//Single Chat
        
        if (self.btnNewChat.frame.origin.y == self.view.bounds.size.height - (heightHeader + heightStatusBar)) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.btnNewChat.frame.origin.y - self.btnNewChat.bounds.size.height, self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, tbContact.bounds.size.height - self.btnNewChat.bounds.size.height)];
            } completion:^(BOOL finished) {
                inShowButtonStartChat = NO;
            }];
        }else{
            
            if (isGroupChat) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                    [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];

                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.btnNewChat.frame.origin.y - self.btnNewChat.bounds.size.height, self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                        [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, tbContact.bounds.size.height - self.btnNewChat.bounds.size.height)];
                    } completion:^(BOOL finished) {
                        inShowButtonStartChat = NO;
                        isGroupChat = NO;
                    }];
                }];
            }
            
        }
        
        [self.btnNewChat setTitle:@"START NEW CHAT" forState:UIControlStateNormal];
    }else{
        //self.view.bounds.size.height - (heightHeader + heightStatusBar)
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
            [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    CGSize sizeTitleLable = [self.btnNewChat.titleLabel.text sizeWithFont:[self.helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnNewChat setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.btnNewChat.imageView.image.size.width, 0, self.btnNewChat.imageView.image.size.width)];
    self.btnNewChat.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + self.btnNewChat.imageView.image.size.width, 0, -((sizeTitleLable.width) + self.btnNewChat.imageView.image.size.width));
}

- (void) notificationSelectComment:(NSNotification*)notification{
    
    //show list comment
    NSDictionary *_wallInfo = notification.userInfo;
    DataWall *_wall = [_wallInfo valueForKey:@"tapCommentInfo"];
    
    SCCommentViewController *post = [[SCCommentViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    [post setData:_wall withType:0];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];

}

- (void) notificationSelectAllComment:(NSNotification*)notification{
    //show list comment
    NSDictionary *_wallInfo = notification.userInfo;
    DataWall *_wall = [_wallInfo valueForKey:@"tapCommentInfo"];
    
    SCCommentViewController *post = [[SCCommentViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    [post setData:_wall withType:1];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) notificationSelectLikes:(NSNotification*)notification{
    //show list comment
    NSDictionary *_wallInfo = notification.userInfo;
    DataWall *_wall = [_wallInfo valueForKey:@"tapLikesInfo"];
    
    SCLikeViewController *post = [[SCLikeViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    [post setData:_wall];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];

}

- (void) notificationReloadListFriend:(NSNotification*)notification{
    [tbContact initData:self.storeIns.friends];
    [tbContact reloadData];
    
    [self setStatusRequestFriend];
}

- (void) notificationDeviceToken:(NSNotification*)notification{
//    NSDictionary *_userInfo = notification.userInfo;
//    friendRequest = [_userInfo valueForKey:@"DenyAddFriend"];
    
//    [netController acceptOrDenyAddFriend:self.chatViewPage.friendIns.friendID withIsAllow:0];
}

- (void) notificationDenyRequestChat:(NSNotificationCenter*)notification{
    
    [netController acceptOrDenyAddFriend:self.chatViewPage.recentIns.friendIns.friendID withIsAllow:0];
    
    if (self.storeIns.recent) {
        int count = (int)[self.storeIns.recent count];
        for (int i = 0; i < count; i++) {
            if ([[self.storeIns.recent objectAtIndex:i] recentID] == self.chatViewPage.recentIns.friendIns.friendID) {
                [self.storeIns.recent removeObjectAtIndex:i];
                [self.homePageV6.scCollection initWithData:self.storeIns.recent withType:0];
                [self.homePageV6.scCollection reloadData];
                
                break;
            }
        }
    }
    
    if (isVisibleChatView) {
        if (self.chatViewPage.recentIns.friendIns.friendID == self.chatViewPage.recentIns.friendIns.friendID) {
            self.chatViewPage.recentIns.friendIns = nil;
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
                [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                [self.scrollHeader setFrame:CGRectMake(0, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

- (void) notificationAllowRequestChat:(NSNotificationCenter*)notification{
//    NSDictionary *_userInfo = notification.userInfo;
//    friendRequest = [_userInfo valueForKey:@"DenyAddFriend"];
    
    [netController acceptOrDenyAddFriend:self.chatViewPage.recentIns.friendIns.friendID withIsAllow:1];
}

- (void) notificationChatBackToHome:(NSNotificationCenter *)notification{
    if (isVisibleChatView) {
        [self.view endEditing:YES];
        
        [self.chatViewPage.chatToolKit reset];
        [self.homePageV6.scCollection reloadData];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.chatViewPage.view setFrame:CGRectMake(-self.view.bounds.size.width, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            [self.scrollHeader setFrame:CGRectMake(0, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
        } completion:^(BOOL finished) {
            isVisibleChatView = NO;
        }];
        
    }
}

- (void) notificationCreateNewGroup:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    Recent *_recent  = (Recent*)[userInfo objectForKey:@"groupChatKey"];
    [self.storeIns.recent insertObject:_recent atIndex:0];
    
    [self.homePageV6.scCollection reloadData];
    
    [self.chatViewPage addRecent:_recent];
    [self.chatViewPage.lblNickName setText:[_recent.nameRecent uppercaseString]];
    [self.chatViewPage reloadFriend];
    [self.chatViewPage resetUI];
    [self.chatViewPage.tbView setClearData:NO];
    [self.chatViewPage.tbView reloadData];
    isVisibleChatView = YES;
    
    [self hiddenMenu];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.storeIns insertGroupChat:_recent];
    });
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, mainScroll.frame.origin.y, self.view.bounds.size.width, mainScroll.bounds.size.height)];
        [self.scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
        [self.chatViewPage.view setFrame:CGRectMake(0, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        page = 0;
    }];
    
    //scroll to bottom
    double y = self.chatViewPage.tbView.contentSize.height - self.chatViewPage.tbView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, y);
    
    if (y > -self.chatViewPage.tbView.contentInset.top)
        [self.chatViewPage.tbView setContentOffset:bottomOffset animated:NO];
}

- (void) notificationOfflineMessage:(NSNotification*)notification{
    NSLog(@"offline message receive");
    
//    NSDictionary *userInfo = [notification userInfo];
//    //    Friend *_friend  = (Friend*)[userInfo objectForKey:@"tapCellIndex"];
//    Recent *_recent  = (Recent*)[userInfo objectForKey:@"tapCellIndex"];
//    Friend *_friend = [self.storeIns getFriendByID:_recent.recentID];
//    
//    if (_friend == nil) {
//        _friend = _recent.friendIns;
//    }
//    
//    Recent *_recent = self.storeIns getRecentByRecentID:<#(int)#>
//    
//    [self.chatViewPage addRecent:_recent];
//    [self.chatViewPage.lblNickName setText:[_friend.nickName uppercaseString]];
//    [self.chatViewPage reloadFriend];
//    [self.chatViewPage resetUI];
//    [self.chatViewPage.tbView setClearData:NO];
//    [self.chatViewPage.tbView reloadData];
//    isVisibleChatView = YES;
//    
//    [self hiddenMenu];
//    
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        
//        [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, mainScroll.frame.origin.y, self.view.bounds.size.width, mainScroll.bounds.size.height)];
//        [self.scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, self.scrollHeader.frame.origin.y, self.scrollHeader.bounds.size.width, self.scrollHeader.bounds.size.height)];
//        [self.chatViewPage.view setFrame:CGRectMake(0, self.chatViewPage.view.frame.origin.y, self.chatViewPage.view.bounds.size.width, self.chatViewPage.view.bounds.size.height)];
//        
//    } completion:^(BOOL finished) {
//        page = 0;
//    }];
//    
//    //scroll to bottom
//    double y = self.chatViewPage.tbView.contentSize.height - self.chatViewPage.tbView.bounds.size.height;
//    CGPoint bottomOffset = CGPointMake(0, y);
//    
//    if (y > -self.chatViewPage.tbView.contentInset.top)
//        [self.chatViewPage.tbView setContentOffset:bottomOffset animated:NO];
}
@end
