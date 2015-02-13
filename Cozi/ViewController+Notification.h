//
//  ViewController+Notification.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+PrivateFunction.h"

@interface ViewController (Notification)
{
    
}

- (void) reachabilityChanged:(NSNotification *)note;
- (void)showListLibrary:(NSNotification*)notification;
- (void)selectFriend:(NSNotification*)notification;
- (void) loadMoreWall:(NSNotification*)notification;
- (void) loadNewWall:(NSNotification*)notification;
- (void) loadMoreNoise:(NSNotification*)notification;
- (void) loadNewNoise:(NSNotification*)notification;
- (void) ResignActiveNotification:(NSNotification*)notification;
- (void) EnterBackgroundNotification:(NSNotification*)notification;
- (void) WillEnterForegroundNotification:(NSNotification*)notification;
- (void) BecomeActiveNotification:(NSNotification*)notification;
- (void) loadAssetsComplete:(NSNotification*)notification;
- (void) loadUserComplete:(NSNotification*)notification;
- (void) loadFriendComplete:(NSNotification*)notification;
- (void) loadWallComplete:(NSNotification*)notification;
- (void) tapFriendProfile:(NSNotification*)notification;
- (void) tapMyProfile:(NSNotification*)notification;
- (void) reloadWallAndNoises:(NSNotification*)notification;
- (void) selectNoise:(NSNotification*)notification;
- (void) notificationSelectContact:(NSNotification*)notification;
- (void) notificationSelectComment:(NSNotification*)notification;
- (void) notificationSelectAllComment:(NSNotification*)notification;
- (void) notificationSelectLikes:(NSNotification*)notification;
- (void) notificationReloadListFriend:(NSNotification*)notification;
@end
