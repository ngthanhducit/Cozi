//
//  ViewController+PrivateFunction.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController+PrivateFunction.h"

@implementation ViewController (PrivateFunction)

//
- (void) showHiddenLeftMenu{
    [self.view endEditing:YES];
    
    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, heightHeader, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuRight = NO;
        }];
        
    }
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu - 2, heightHeader, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuLeft = NO;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [leftView setFrame:CGRectMake(0, heightHeader, widthMenu , leftView.bounds.size.height)];
            [leftView setHidden:NO];
            
            [blurView setAlpha:alphatView];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuLeft = YES;
        }];
        
    }
}

- (void) showHiddenRightMenu{
    [self.view endEditing:YES];
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu + 2, heightHeader, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuLeft = NO;
        }];
    }
    
    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, heightHeader, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuRight = NO;
        }];
        
    }else{
        
        //show menu right
        
        //show menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake((self.view.bounds.size.width / 4), heightHeader, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:NO];
            
            [blurView setAlpha:alphatView];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(-widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuRight = YES;
        }];
        
    }
}

- (void) hiddenMenu{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowMenuRight) {
            //hidden right
            [rightView setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
            isShowMenuRight = NO;
        }
        
        if (isShowMenuLeft) {
            //hidden left
            [leftView setFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];

            isShowMenuLeft = NO;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void) showShareMenu{
    
    if (inShowShareMenu) {
        return;
    }
    
    if (!isShow) {
        inShowShareMenu = YES;
        [self.view bringSubviewToFront:scrollHeader];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.shareMenu setHidden:NO];
            [vBlurShareMenu setHidden:NO];
            
            [self.shareMenu setFrame:CGRectMake(0, heightHeader, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
            
            [vBlurShareMenu setAlpha:0.6];
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:self.shareMenu];
            isShow = YES;
            inShowShareMenu = NO;
        }];
    }else{
        [self.view bringSubviewToFront:scrollHeader];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.shareMenu setFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.shareMenu.bounds.size.height)];
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
    
//    [mainScroll removeFromSuperview];
//    mainScroll = nil;
//    
//    [leftView removeFromSuperview];
//    leftView = nil;
//    
//    [rightView removeFromSuperview];
//    rightView = nil;
//    
//    [headerView removeFromSuperview];
//    headerView = nil;
//    
//    [scrollHeader removeFromSuperview];
//    scrollHeader = nil;
    
//    if (self.loginPage == nil) {
//        self.loginPage = [[LoginPage alloc] initWithFrame:self.view.bounds];
//        [self.loginPage.signInView.btnSignInView addTarget:self action:@selector(btnSignInTouches) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:self.loginPage];
//    }
//    
//    [self.loginPage resetFirstFrom];
//    
//    [self.view addSubview:self.loginPage];
    
    isFirstLoadNoise = YES;
    isFirstLoadWall = YES;
    
    if (self.loginPageV3 == nil) {
        self.loginPageV3 = [[SCLoginPageV3 alloc] initWithNibName:nil bundle:nil];
        [self.loginPageV3.view setFrame:self.view.bounds];
        
        [self addChildViewController:self.loginPageV3];
        [self.view addSubview:self.loginPageV3.view];
        [self.loginPageV3 didMoveToParentViewController:self];
        
//        [self.loginPageV3.btnSignIn addTarget:self action:@selector(btnSignInTouchesV3) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.loginPageV3.view setHidden:NO];
        [self addChildViewController:self.loginPageV3];
        [self.view addSubview:self.loginPageV3.view];
        [self.loginPageV3 didMoveToParentViewController:self];
    }
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self.storeIns setup];
    
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
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, 0, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
                [viewStatusConnect setBackgroundColor:[UIColor greenColor]];
                [lblStatusConnect setText:@"Connecting..."];
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -(viewStatusConnect.bounds.size.height - 4), viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                    
                } completion:^(BOOL finished) {
                    [self initNetwork];
                }];
                
            }];
        }

        isConnected = 1;
        
    }else{
        
        if (isConnected != 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, 0, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
                [viewStatusConnect setBackgroundColor:[UIColor redColor]];
                [lblStatusConnect setText:@"No internet"];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -(viewStatusConnect.bounds.size.height - 4), viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                    
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }

        
        isConnected = 0;
        
    }
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
}

- (void) btnNewChatClick:(id)sender{
    
    NSMutableArray *selectList = [tbContact getSelectList];
    
    if ([selectList count] > 1) {//Group Chat
        
    }else{
        Friend *_friend  = (Friend*)[selectList lastObject];
        
        if (_friend) {
            [self.chatViewPage setTag:10000];
            [self.chatViewPage addFriendIns:_friend];
            [self.chatViewPage.lblNickName setText:[_friend.nickName uppercaseString]];
            [self.chatViewPage reloadFriend];
            [self.chatViewPage resetUI];
            [self.chatViewPage resetCamera];
            [self.chatViewPage.tbView setClearData:NO];
            [self.chatViewPage.tbView reloadData];
            
            [self hiddenMenu];
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                //        [mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
                [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, self.view.bounds.size.width, mainScroll.bounds.size.height)];
                [scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, 0, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
                [self.chatViewPage setFrame:CGRectMake(0, 0, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
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
    
    [tbContact resetCell];
    
    NSLog(@"new chat");
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
@end
