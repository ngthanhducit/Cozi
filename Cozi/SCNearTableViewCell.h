//
//  SCNearTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCNearTableViewCell : UITableViewCell
{
    Helper              *helperIns;
}

@property (nonatomic, strong) UILabel               *lblName;
@property (nonatomic, strong) UILabel               *lblVincity;

@end
