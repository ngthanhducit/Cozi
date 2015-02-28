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
    [self.view endEditing:YES];

    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuRight = NO;
        }];
        
    }
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu - 2, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuLeft = NO;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [leftView setFrame:CGRectMake(0, leftView.frame.origin.y, widthMenu , leftView.bounds.size.height)];
            [leftView setHidden:NO];
            
            [blurView setAlpha:alphatView];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuLeft = YES;
        }];
        
    }
}

- (void) showHiddenRightMenu{
    [self.view endEditing:YES];
    
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu + 2, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuLeft = NO;
        }];
    }
    
    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width + 2, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuRight = NO;
        }];
        
    }else{
        
        //show menu right
        
        //show menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake((self.view.bounds.size.width / 4), rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:NO];
            
            [blurView setAlpha:alphatView];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(-widthMenu, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            isShowMenuRight = YES;
        }];
        
    }
}

- (void) hiddenMenu{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowMenuRight) {
            //hidden right
            [rightView setFrame:CGRectMake(self.view.bounds.size.width, rightView.frame.origin.y, widthMenu, self.view.bounds.size.height)];
            [rightView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
            
            isShowMenuRight = NO;
        }
        
        if (isShowMenuLeft) {
            //hidden left
            [leftView setFrame:CGRectMake(-widthMenu, leftView.frame.origin.y, widthMenu, leftView.bounds.size.height)];
            [leftView setHidden:YES];
            
            [blurView setAlpha:0.0];
            
            [self.vMain bringSubviewToFront:blurView];
            [self.vMain bringSubviewToFront:leftView];
            
            [mainScroll setFrame:CGRectMake(0, mainScroll.frame.origin.y, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];

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
        [self.vMain bringSubviewToFront:scrollHeader];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.shareMenu setHidden:NO];
            [vBlurShareMenu setHidden:NO];
            
            [self.shareMenu setFrame:CGRectMake(self.shareMenu.frame.origin.x, heightHeader, self.shareMenu.bounds.size.width, self.shareMenu.bounds.size.height)];
            
            [vBlurShareMenu setAlpha:0.5];
        } completion:^(BOOL finished) {
            [self.vMain bringSubviewToFront:self.shareMenu];
            isShow = YES;
            inShowShareMenu = NO;
        }];
    }else{
        [self.vMain bringSubviewToFront:scrollHeader];
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
            [viewStatusConnect setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor4"]]];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, 0, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
                [lblStatusConnect setText:@"Connecting..."];
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, -(viewStatusConnect.bounds.size.height - 5), viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                    
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
            [viewStatusConnect setBackgroundColor:[UIColor redColor]];
            
            [self.vLineFirstStatusConnect.layer removeAllAnimations];
            [self.vLineSecondStatusConnect.layer removeAllAnimations];
            
            [self.vLineFirstStatusConnect setFrame:CGRectMake(0, -5, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
            [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), -5, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setFrame:CGRectMake(viewStatusConnect.frame.origin.x, 0, viewStatusConnect.bounds.size.width, viewStatusConnect.bounds.size.height)];
                [viewStatusConnect setHidden:NO];
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

- (void) loopStatusConnect{

    [self.vLineFirstStatusConnect setFrame:CGRectMake(self.vLineFirstStatusConnect.frame.origin.x, 0, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
    [self.vLineSecondStatusConnect setFrame:CGRectMake(self.vLineSecondStatusConnect.frame.origin.x, 0, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        [self.vLineFirstStatusConnect setFrame:CGRectMake(self.view.bounds.size.width + heightHeader, 0, self.vLineFirstStatusConnect.bounds.size.width, self.vLineFirstStatusConnect.bounds.size.height)];
        [self.vLineSecondStatusConnect setFrame:CGRectMake(0, 0, self.vLineSecondStatusConnect.bounds.size.width, self.vLineSecondStatusConnect.bounds.size.height)];
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
//            [self.chatViewPage resetCamera];
            [self.chatViewPage.tbView setClearData:NO];
            [self.chatViewPage.tbView reloadData];
            
            [self hiddenMenu];
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                //        [mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
                [mainScroll setFrame:CGRectMake(self.view.bounds.size.width, mainScroll.frame.origin.y, self.view.bounds.size.width, mainScroll.bounds.size.height)];
                [scrollHeader setFrame:CGRectMake(self.view.bounds.size.width, scrollHeader.frame.origin.y, scrollHeader.bounds.size.width, scrollHeader.bounds.size.height)];
                [self.chatViewPage setFrame:CGRectMake(0, self.chatViewPage.frame.origin.y, self.chatViewPage.bounds.size.width, self.chatViewPage.bounds.size.height)];
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
