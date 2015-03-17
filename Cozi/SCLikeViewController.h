//
//  SCLikeViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLikeTableView.h"
#import "NetworkController.h"
#import "PNetworkCommunication.h"
#import "SCPostParentViewController.h"

@interface SCLikeViewController : SCPostParentViewController <PNetworkCommunication>
{
    DataWall                *wallItems;
    NetworkController       *netControllerIns;
}

@property (nonatomic, strong) SCLikeTableView    *tbLike;

- (void) setData:(DataWall*)data;

@end
