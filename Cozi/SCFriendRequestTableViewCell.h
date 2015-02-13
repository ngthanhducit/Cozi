//
//  SCFriendRequestTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCFriendRequestTableViewCell : UITableViewCell
{
    Helper                  *helperIns;
}

@property (nonatomic, strong) UIImageView           *imgAvatar;
@property (nonatomic, strong) UILabel               *lblFullName;
@property (nonatomic, strong) UIButton              *btnAccept;
@property (nonatomic, strong) UIButton              *btnDeny;
@property (nonatomic, strong) UIButton              *btnBlock;
@end
