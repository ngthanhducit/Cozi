    //
//  ViewController+PrivateFunction.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController+PrivateFunction.h"
#import "ViewController+NetworkCommunication.h"

@implementation ViewController (PrivateFunction)

//
- (void) showHiddenLeftMenu{
    [self.storeIns playSoundPress];
    
    [self.view endEditing:YES];

    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            [rightView setHidden:YES];
            isShowMenuRight = NO;
            
            //Hidden button
            //chang size tbContact
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];
            } completion:^(BOOL finished) {
                
            }];
            
            [tbContact resetCell];
            
        }];
        
    }
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu - 2, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            [leftView setHidden:YES];
            isShowMenuLeft = NO;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [leftView setHidden:NO];
            [leftView setFrame:CGRectMake(0, leftView.frame.origin.y, widthMenu , leftView.bounds.size.height)];

            [blurView setAlpha:alphatView];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuLeft = YES;
        }];
        
    }
}

- (void) showHiddenRightMenu{
    [self.storeIns playSoundPress];
    
    [self.view endEditing:YES];
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu + 2, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            [leftView setHidden:YES];
            isShowMenuLeft = NO;
        }];
    }
    
    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            [rightView setHidden:YES];
            isShowMenuRight = NO;

            //Hidden button
            //chang size tbContact
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];
            } completion:^(BOOL finished) {
                
            }];
            
            [tbContact resetCell];
            
        }];
        
    }else{
        
        //show menu right
        
        //show menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setHidden:NO];
            [rightView setFrame:CGRectMake((self.view.bounds.size.width / 4), rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            
            [blurView setAlpha:alphatView];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(-widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuRight = YES;
        }];
        
    }
}

- (void) hiddenMenu{
    
    if (isShowMenuRight) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (isShowMenuRight) {
                //hidden right
                [rightView setFrame:CGRectMake(self.view.bounds.size.width, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
                
                [blurView setAlpha:0.0];
                
                [self.view bringSubviewToFront:blurView];
                [self.view bringSubviewToFront:rightView];
                
                [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
                
                isShowMenuRight = NO;
                
                //Hidden button
                //chang size tbContact
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
                    [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];
                } completion:^(BOOL finished) {
                    
                }];
                
                [tbContact resetCell];
            }
        } completion:^(BOOL finished) {
            [rightView setHidden:YES];
        }];
    }
    
    if (isShowMenuLeft) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //hidden left
            [leftView setFrame:CGRectMake(-widthMenu, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];

            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
            isShowMenuLeft = NO;
        } completion:^(BOOL finished) {
            [leftView setHidden:YES];
        }];
    }
    
    
}

- (void) showShareMenu{
    [self.storeIns playSoundPress];
    
    if (inShowShareMenu) {
        return;
    }
    
    [self hiddenMenu];
    
    if (!isShow) {
        inShowShareMenu = YES;
        [self.view bringSubviewToFront:vBlurShareMenu];
        [self.view bringSubviewToFront:self.shareMenu];

        [self.view bringSubviewToFront:self.scrollHeader];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.shareMenu setHidden:NO];
            [vBlurShareMenu setHidden:NO];
            
            [self.shareMenu setFrame:CGRectMake(self.shareMenu.frame.origin.x, heightHeader + heightStatusBar, self.shareMenu.bounds.size.width, self.shareMenu.bounds.size.height)];
            
            [vBlurShareMenu setAlpha:0.5];
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:self.shareMenu];
            [self.view bringSubviewToFront:vBlurShareMenu];
            [self.view bringSubviewToFront:self.shareMenu];
            
            isShow = YES;
            inShowShareMenu = NO;
        }];
    }else{
        [self.view bringSubviewToFront:self.scrollHeader];
//        [self.view bringSubviewToFront:self.statusBarView];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.shareMenu setFrame:CGRectMake(self.shareMenu.frame.origin.x, -(self.shareMenu.bounds.size.height), self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
            [vBlurShareMenu setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.shareMenu setHidden:YES];
            [vBlurShareMenu setHidden:YES];
            isShow = NO;
            inShowShareMenu = NO;
        }];
    }
}

- (void) logout{
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
//    [self.vLineFirstStatusConnect.layer removeAllAnimations];
//    [self.vLineSecondStatusConnect.layer removeAllAnimations];
//    
//    [self.vLineFirstStatusConnect setHidden:YES];
//    [self.vLineSecondStatusConnect setHidden:YES];
//    
//    [self.vLineFirstStatusConnect setFrame:CGRectMake(0, (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];
//    [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), (heightStatusBar + heightHeader) - 5, self.view.bounds.size.width, 5)];

    [self.vLineFirstStatusConnect removeFromSuperview];
    [self.vLineSecondStatusConnect removeFromSuperview];
    [viewStatusConnect removeFromSuperview];
    
    isFirstLoadNoise = YES;
    isFirstLoadWall = YES;
    
    if (self.loginPageV3 == nil) {
        self.loginPageV3 = [[SCLoginPageV3 alloc] initWithNibName:nil bundle:nil];
        [self.loginPageV3.view setFrame:self.view.bounds];
        
        [self addChildViewController:self.loginPageV3];
        [self.view addSubview:self.loginPageV3.view];
        [self.loginPageV3 didMoveToParentViewController:self];
        
    }else{
        [self.loginPageV3.view setHidden:NO];
        [self addChildViewController:self.loginPageV3];
        [self.view addSubview:self.loginPageV3.view];
        [self.loginPageV3 didMoveToParentViewController:self];
    }
    
    [self.storeIns setup];
    
    [self.homePageV6 removeFromSuperview];
    
    [self.wallPageV8 stopStartOnTick:NO];
    [self.wallPageV8 initWithData:self.storeIns.walls withType:0];
    [self.wallPageV8 removeFromSuperview];
    
    [self.noisePageV6.scCollection initData:self.storeIns.noises withType:0];
    [self.noisePageV6 removeFromSuperview];

    [self.scrollHeader removeFromSuperview];
    [mainScroll removeFromSuperview];
    
    [self.chatViewPage.view removeFromSuperview];
    [blurView removeFromSuperview];
    [blurImage removeFromSuperview];
    [leftView removeFromSuperview];
    [rightView removeFromSuperview];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self.networkIns sendData:@"LOGOUT{<EOF>"];

    [self.networkIns disconnectSocket];
    
    [self.storeIns initLocation];
    
    AppDelegate *_appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_appDelegate reloadDeviceToken];
    
    [self.networkIns connectSocket];
}

- (void) showStatusConnected:(int)_isConnected{

    if (_isConnected == 1) {
        if (isConnected != 1) {

            [viewStatusConnect setFrame:CGRectMake(0, -heightStatusBar, self.view.bounds.size.width, heightHeader)];
            [viewStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor4"]]];

            [self.chatViewPage.view bringSubviewToFront:self.chatViewPage.tbView];
            [self.view bringSubviewToFront:self.chatViewPage.view];
            [self.view bringSubviewToFront:mainScroll];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, heightStatusBar, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
                [lblStatusConnect setText:@"Connecting..."];
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -(viewStatusConnect.bounds.size.height - heightStatusBar - 10), viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];

                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, (heightStatusBar + heightHeader) - 5, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];;
                                    
                } completion:^(BOOL finished) {

                    [viewStatusConnect setHidden:YES];
                    
                    [self.vLineFirstStatusConnect setHidden:NO];
                    [self.vLineSecondStatusConnect setHidden:NO];
                    
                    [self loopStatusConnect];
                    
                    [self initNetwork];
                }];
                
            }];
        }
        
        isConnected = 1;
        
    }else{
        
        if (isConnected != 0) {
            [viewStatusConnect setFrame:CGRectMake(0, -heightStatusBar, self.view.bounds.size.width, heightHeader)];
            [viewStatusConnect setBackgroundColor:[UIColor redColor]];
            
            [self.vLineFirstStatusConnect setHidden:YES];
            [self.vLineSecondStatusConnect setHidden:YES];
            
//            [self.view bringSubviewToFront:self.statusBarView];
            [self.chatViewPage.view bringSubviewToFront:self.chatViewPage.tbView];
            [self.view bringSubviewToFront:self.chatViewPage.view];
            [self.view bringSubviewToFront:mainScroll];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, heightStatusBar, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
                [lblStatusConnect setText:@"No internet"];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{

                    //                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -(viewStatusConnect.bounds.size.height - heightStatusBar - 5), viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                
                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, (heightStatusBar + heightHeader) - 5, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }

        
        isConnected = 0;
        
    }
}

- (void) loopStatusConnect{
    
    [self.vLineFirstStatusConnect setFrame:CGRectMake(0, (heightStatusBar + heightHeader) - 5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
    [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), (heightStatusBar + heightHeader) - 5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        [self.vLineFirstStatusConnect setFrame:CGRectMake(self.view.bounds.size.width + heightHeader, (heightStatusBar + heightHeader) - 5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
        [self.vLineSecondStatusConnect setFrame:CGRectMake(0, (heightStatusBar + heightHeader) - 5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
    } completion:^(BOOL finished) {

    }];
}

- (void) playSoundSystem{
    
    // Play the sound
    AudioServicesPlaySystemSound(1007);
    
}

- (void) vibrate{
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
}

- (void) onTick:(id)sender{
    self.storeIns.timeServer = [self.storeIns.timeServer dateByAddingTimeInterval:1];
//    NSLog(@"%@", self.storeIns.timeServer);
}

- (void) btnNewChatClick:(id)sender{
    [self.storeIns playSoundPress];
    
    __strong NSMutableArray *selectList = [tbContact getSelectList];
    
    if ([selectList count] > 1) {//Group Chat
        
        return;
        
        SCGroupChatViewController *post = [[SCGroupChatViewController alloc] init];
        [post initData:selectList];
        [post showHiddenBack:YES];
        [post showHiddenClose:NO];
        
        UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:post];
        [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
        [naviController setDelegate:self];
        
        [self presentViewController:naviController animated:YES completion:^{
            
            [self hiddenMenu];
            
        }];

        
    }else{
        Friend *_friend  = (Friend*)[selectList lastObject];
        
        if (_friend) {
            Recent *_recent = [Recent new];
            _recent.recentID = _friend.friendID;
            _recent.typeRecent = 0;
            _recent.thumbnail = _friend.thumbnail;
            _recent.urlThumbnail = _friend.urlThumbnail;
            _recent.nameRecent = _friend.nickName;
            _recent.friendIns = _friend;
            _recent.friendRecent = [NSMutableArray new];
            _recent.messengerRecent = [NSMutableArray new];
            
//            [self.chatViewPage addFriendIns:_friend];
            [self.chatViewPage addRecent:_recent];
            [self.chatViewPage.lblNickName setText:[_friend.nickName uppercaseString]];
            [self.chatViewPage reloadFriend];
            [self.chatViewPage resetUI];
            [self.chatViewPage.tbView setClearData:NO];
            [self.chatViewPage.tbView reloadData];
            isVisibleChatView = YES;
            
            [self hiddenMenu];
            
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
    }
    
    //Hidden button
    //chang size tbContact
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.btnNewChat setFrame:CGRectMake(self.btnNewChat.frame.origin.x, self.view.bounds.size.height - (heightHeader + heightStatusBar), self.btnNewChat.bounds.size.width, self.btnNewChat.bounds.size.height)];
        [tbContact setFrame:CGRectMake(tbContact.frame.origin.x, tbContact.frame.origin.y, tbContact.bounds.size.width, self.view.bounds.size.height - (heightHeader + heightStatusBar + 40))];
    } completion:^(BOOL finished) {
        
    }];
    
    [tbContact resetCell];
}

- (void) reloadWall{
    [self.wallPageV8 reloadData];
}

- (void) reloadNoise{
    [self.noisePageV6.scCollection reloadData];
}

- (void) setStatusRequestFriend{
    if ([self.storeIns.friendsRequest count] > 0) {
        [imgMyInfo setBackgroundColor:[UIColor orangeColor]];
        [btnFriendRequest setBackgroundColor:[UIColor purpleColor]];
    }else{
        [imgMyInfo setBackgroundColor:[UIColor clearColor]];
        [btnFriendRequest setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (void) tapUserLeftMenu:(UIGestureRecognizer*)recognizer{
    
}

@end
