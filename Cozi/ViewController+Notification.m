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
    
    isFirstLoadWall = NO;
    
    DataWall *_wall = [self.storeIns.walls lastObject];
    NSString *_clientKey = [self.helperIns encodedBase64:[_wall.clientKey dataUsingEncoding:NSUTF8StringEncoding]];
    [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{10}%@<EOF>", _clientKey]];
    
}

- (void) loadNewWall:(NSNotification*)notification{
    
    isFirstLoadWall = YES;
    
    NSString *tempKey = @"-1";
    NSString *_clientKey = [self.helperIns encodedBase64:[tempKey dataUsingEncoding:NSUTF8StringEncoding]];
    [self.networkIns sendData:[NSString stringWithFormat:@"GETWALL{10}%@<EOF>", _clientKey]];
    
}

- (void) loadMoreNoise:(NSNotification*)notification{
    
}

- (void) loadNewNoise:(NSNotification*)notification{
    
    isFirstLoadNoise = YES;
    
    NSString *tempKey = @"-1";
    NSString *_clientKey = [self.helperIns encodedBase64:[tempKey dataUsingEncoding:NSUTF8StringEncoding]];
    [self.networkIns sendData:[NSString stringWithFormat:@"GETNOISE{21}%@<EOF>", _clientKey]];
}

- (void) ResignActiveNotification:(NSNotification*)notification{
    NSLog(@"ResignActiveNotification");
}

- (void) EnterBackgroundNotification:(NSNotification*)notification{
    isEnterBackground = YES;
    [self.networkIns disconnectSocket];
}

- (void) WillEnterForegroundNotification:(NSNotification*)notification{
    NSLog(@"WillEnterForegroundNotification");
}

- (void) BecomeActiveNotification:(NSNotification*)notification{
    
    if (isEnterBackground) {
        BOOL _isConnected = [self.helperIns checkConnected];
        if (_isConnected) {
            [self.networkIns connectSocket];
            
            [self.chatViewPage resetCamera];
        }else{
            
            [self showStatusConnected:0];
            
        }
    }
}

- (void)selectFriend:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    //    int index = [[userInfo objectForKey:@"tapCellIndex"] intValue];
    Friend *_friend  = (Friend*)[userInfo objectForKey:@"tapCellIndex"];
    
    //    Friend *_friend = [self.storeIns.friends objectAtIndex:index];
    //    Friend *_friend = [self.storeIns.recent objectAtIndex:index];
    
    [self.chatViewPage initFriendInfo:_friend];
    [self.chatViewPage setTag:10000];
    [self.chatViewPage addFriendIns:_friend];
    [self.lblNickName setText:[_friend.nickName uppercaseString]];
    [self.chatViewPage reloadFriend];
    [self.chatViewPage.tbView setClearData:NO];
    [self.chatViewPage.tbView reloadData];
    
    UITapGestureRecognizer *tapLogoReturn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [tapLogoReturn setNumberOfTapsRequired:1];
    [tapLogoReturn setNumberOfTouchesRequired:1];
    
    [self.chatViewPage._backView addGestureRecognizer:tapLogoReturn];
    //    [self.chatViewPage initLibraryImage];
    
    [self showHiddenRightMenu];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
            NSLog(@"WWAN");
            break;
            
        default:
            break;
    }
}



- (void) loadAssetsComplete:(NSNotification*)notification{
    
    [self.chatViewPage initLibraryImage];
    
}

- (void) loadUserComplete:(NSNotification*)notification{
    NSLog(@"load user complete");
    [self initLeftMenu];
    
    [self initRightMenu];
    
}

- (void) loadFriendComplete:(NSNotification*)notification{
    NSLog(@"load user complete");
    [self.homePageV6.scCollection reloadData];
}

- (void) loadWallComplete:(NSNotification*)notification{
    
    NSLog(@"load wall complete");
    
    [self.wallPageV8 reloadData];
    [self.noisePageV6.scCollection reloadData];
}
@end
