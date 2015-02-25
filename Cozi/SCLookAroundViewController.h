//
//  SCLookAroundViewController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPostParentViewController.h"
#import "PNetworkCommunication.h"
#import "UserSearch.h"
#import "networkController.h"

@interface SCLookAroundViewController : SCPostParentViewController <PNetworkCommunication>
{
    NetworkController           *netIns;
}
@end
