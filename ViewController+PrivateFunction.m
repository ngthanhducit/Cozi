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
    if (isShowMenuRight) {
        
        //hidden menu right
        //hidden menu
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [rightView setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height)];
            
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
            
            [leftView setFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, leftView.bounds.size.height)];
            
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
    if (isShowMenuLeft) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [leftView setFrame:CGRectMake(-widthMenu, heightHeader, widthMenu, leftView.bounds.size.height)];
            
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
            [rightView setFrame:CGRectMake(self.view.bounds.size.width, heightHeader, widthMenu, self.view.bounds.size.height)];
            
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
            
            [blurView setAlpha:alphatView];
            
            [self.view bringSubviewToFront:blurView];
            [self.view bringSubviewToFront:rightView];
            
            [mainScroll setFrame:CGRectMake(-widthMenu, heightHeader, mainScroll.bounds.size.width, mainScroll.bounds.size.height)];
        } completion:^(BOOL finished) {
            isShowMenuRight = YES;
        }];
        
    }
}

- (void) logout{
    
    [mainScroll removeFromSuperview];
    mainScroll = nil;
    
    [leftView removeFromSuperview];
    leftView = nil;
    
    [rightView removeFromSuperview];
    rightView = nil;
    
    [headerView removeFromSuperview];
    headerView = nil;
    
    [scrollHeader removeFromSuperview];
    scrollHeader = nil;
    
    if (self.loginPage == nil) {
        self.loginPage = [[LoginPage alloc] initWithFrame:self.view.bounds];
        [self.loginPage.signInView.btnSignInView addTarget:self action:@selector(btnSignInTouches) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginPage];
    }
    
    [self.loginPage resetFirstFrom];
    
    [self.view addSubview:self.loginPage];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self.storeIns setup];
    
    [self.networkIns sendData:@"LOGOUT{<EOF>"];
    
    [self.networkIns disconnectSocket];
    
    [self.networkIns connectSocket];
    
    [self.storeIns initLocation];
    
    AppDelegate *_appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_appDelegate reloadDeviceToken];
}

- (void) showStatusConnected:(int)_isConnected{
    if (_isConnected == 1) {
        
        if (!isConnected) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [viewStatusConnect setHidden:NO];
                [viewStatusConnect setBackgroundColor:[UIColor greenColor]];
                [lblStatusConnect setText:@"Connecting..."];
                
            } completion:^(BOOL finished) {
                self.networkIns = [NetworkCommunication shareInstance];
                [self.networkIns setDelegate:self];
                [self.networkIns connectSocket];
            }];
        }
        
        isConnected = 1;
        
    }else{
        
        if (isConnected) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [viewStatusConnect setHidden:NO];
                [viewStatusConnect setBackgroundColor:[UIColor redColor]];
                [lblStatusConnect setText:@"No internet"];
                
            } completion:^(BOOL finished) {
                
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
    NSLog(@"tick time: %@", self.storeIns.timeServer);
}
@end
