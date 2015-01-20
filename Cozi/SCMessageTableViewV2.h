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

@protocol SCMessageTableViewDelegate <NSObject>

@required
- (void) sendIsReadMessage:(int)_friendID withKeyMessage:(NSInteger)_keyMessage withTypeMessage:(int)_typeMessage;
- (void) notifyDeleteMessage:(Messenger *)_messenger;
@end


@interface SCMessageTableViewV2 : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    Helper              *helperIns;
    Store               *storeIns;
    NSMutableArray      *items;
    
    CGFloat             padding;
    CGFloat             wMax;
    BOOL                clearData;
}
@property (nonatomic, strong) id<SCMessageTableViewDelegate> scMessageTableViewDelegate;
@property (nonatomic, strong) Friend                     *friendIns;

- (void) setData:(NSMutableArray*)_data;

- (void) reloadTableView;
- (void) setClearData:(BOOL)_isClear;
@end
