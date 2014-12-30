//
//  ViewController+PrivateFunction.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/30/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController (PrivateFunction)
{
    
}

- (void) showHiddenLeftMenu;
- (void) showHiddenRightMenu;
- (void) playSoundSystem;
- (void) vibrate;
- (void) logout;
- (void) showStatusConnected:(int)_isConnected;
@end
