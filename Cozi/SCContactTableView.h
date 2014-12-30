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
#import "SDWebImageDownloader.h"
#import "AsyncImageDownloader.h"

@interface SCContactTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary            *contacts;
//    NSArray                 *contactSelectTitles;
//    NSArray                 *contactIndexTitles;
    Helper                  *helperIns;
    Store                   *storeIns;
    
    NSMutableArray          *contactList;
    NSMutableArray                 *contactIndex;
}

- (void) initData:(NSMutableArray *)_contactList;
@end
