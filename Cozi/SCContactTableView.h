//
//  SCContactTableView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Store.h"
#import "SCContactTableViewCell.h"
#import "PersonContact.h"
#import "UIImageView+WebCache.h"

@interface SCContactTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    Helper                  *helperIns;
    Store                   *storeIns;
 
    NSMutableDictionary            *contacts;
    
    NSMutableArray          *contactList;
    NSMutableArray          *contactIndex;
    
    NSMutableArray                 *contactSearch;
    
    NSMutableArray              *selectList;
    NSMutableArray              *selectCell;
    int                         typeContact;
}

- (void) resetCell;
- (NSMutableArray*) getSelectList;
- (void) initData:(NSMutableArray *)_contactList;
- (void) setType:(int)_type;
@end
