//
//  SCMessageGroupTableViewV2.h
//  Cozi
//
//  Created by ChjpCoj on 3/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "SCMessageTableViewCellV2.h"
#import "Friend.h"
#import "Messenger.h"
#import "Store.h"
#import "UIImage+ImageEffects.h"
#import "ImageFullView.h"
#import "UIImageView+WebCache.h"
#import "AppleMapView.h"
#import "SDWebImage/SDImageCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Recent.h"

@protocol SCMessageGroupTableViewDelegate <NSObject>

@required
- (void) sendIsReadMessageGroup:(int)_friendID withKeyMessage:(NSString*)_keyMessage withTypeMessage:(int)_typeMessage;
- (void) notifyDeleteMessageGroup:(Messenger *)_messenger;
@end

@interface SCMessageTableViewV3 : UITableView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    Helper              *helperIns;
    Store               *storeIns;
    
    CGFloat             padding;
    CGFloat             wMax;
    BOOL                clearData;
    
    BOOL                inScroll;
    NSIndexPath                             *rowAction;
    UIImage             *defaultImage;
    UIImage             *imgIsRead;
    UIImage             *imgIsSend;
    UIImage             *imgIsRecive;
}

@property (nonatomic, strong) id<SCMessageGroupTableViewDelegate> scMessageGroupTableViewDelegate;
@property (nonatomic, strong) Recent                            *recentIns;

- (void) reloadTableView;
- (void) setClearData:(BOOL)_isClear;
@end
