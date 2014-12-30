//
//  SCMessageTableView.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMessageTableViewCell.h"
#import "Friend.h"
#import "Helper.h"
#import "Store.h"
#import "SVGImageElement.h"
#import "SVGKImageView.h"
#import "SVGKLayeredImageView.h"
#import "AppleMapView.h"
#import "ImageFullView.h"

@protocol SCMessageTableViewDelegate <NSObject>

@required
- (void) sendIsReadMessage:(int)_friendID withKeyMessage:(NSInteger)_keyMessage withTypeMessage:(int)_typeMessage;
- (void) notifyDeleteMessage:(Messenger *)_messenger;
@end

@interface SCMessageTableView : UITableView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    Messenger                                       *lastMessage;
    id<SCMessageTableViewDelegate>                  _scMessageTableViewDelegate;
    
    BOOL                                            inScroll;
    NSIndexPath                             *rowAction;
    BOOL                                    clearData;
}

@property (nonatomic, strong) id<SCMessageTableViewDelegate> scMessageTableViewDelegate;
@property (nonatomic, strong) Friend                     *friendIns;
@property (nonatomic, strong) Store                      *storeIns;
@property (nonatomic, strong) Helper                     *helperIns;

- (void) reloadTableView;
- (void) setClearData:(BOOL)_isClear;
@end
