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
//    NSLog(@"ResignActiveNotification");
}

- (void) EnterBackgroundNotification:(NSNotification*)notification{
    isEnterBackground = YES;
    [self.networkIns disconnectSocket];
}

- (void) WillEnterForegroundNotification:(NSNotification*)notification{
//    NSLog(@"WillEnterForegroundNotification");
}

- (void) BecomeActiveNotification:(NSNotification*)notification{
    
    if (isEnterBackground) {
        isFirstLoadNoise = YES;
        isFirstLoadWall = YES;
        
        isConnected = -1;
        
        [self setupNetworkStatus];
    }
}

- (void)selectFriend:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    Friend *_friend  = (Friend*)[userInfo objectForKey:@"tapCellIndex"];
    
    [self.chatViewPage setTag:10000];
    [self.chatViewPage addFriendIns:_friend];
    [self.chatViewPage.lblNickName setText:[_friend.nickName uppercaseString]];
    [self.chatViewPage reloadFriend];
    [self.chatViewPage resetUI];
    [self.chatViewPage.tbView setClearData:NO];
    [self.chatViewPage.tbView reloadData];
    
    [self hiddenMenu];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
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
    
    [self.vLineFirstStatusConnect setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    [self.vLineSecondStatusConnect setFrame:CGRectMake(-(self.view.bounds.size.width + heightHeader), 0, self.view.bounds.size.width, 5)];
    
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
        [self.btnNewChat setTitle:@"NEW GROUP CHAT" forState:UIControlStateNormal];
    }else{//Single Chat
        [self.btnNewChat setTitle:@"NEW CHAT" forState:UIControlStateNormal];
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
    
}
@end
