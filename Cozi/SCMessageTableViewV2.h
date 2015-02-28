//
//  SCMessageTableViewV2.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/18/15.
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

@protocol SCMessageTableViewDelegate <NSObject>

@required
- (void) sendIsReadMessage:(int)_friendID withKeyMessage:(NSString*)_keyMessage withTypeMessage:(int)_typeMessage;
- (void) notifyDeleteMessage:(Messenger *)_messenger;
@end


@interface SCMessageTableViewV2 : UITableView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    Helper              *helperIns;
    Store               *storeIns;
//    NSMutableArray      *items;
    
    CGFloat             padding;
    CGFloat             wMax;
    BOOL                clearData;
    
    BOOL                inScroll;
    NSIndexPath                             *rowAction;
    UIImage             *defaultImage;
    Friend              *friendIns;
    UIImage             *imgIsRead;
    UIImage             *imgIsSend;
    UIImage             *imgIsRecive;
}
@property (nonatomic, strong) id<SCMessageTableViewDelegate> scMessageTableViewDelegate;
//@property (nonatomic, strong) Friend                     *friendIns;

- (Friend*) getFrinedIns;
- (void) setFriendIns:(Friend*)_friend;
- (void) setData:(NSMutableArray*)_data;
- (void) reloadTableView;
- (void) setClearData:(BOOL)_isClear;
@end
