//
//  SCSearchFriendTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "SCUIButton.h"

@interface SCSearchFriendTableViewCell : UITableViewCell
{
    Helper                  *helperIns;
}

@property (nonatomic, strong) UIImageView           *imgAvatar;
@property (nonatomic, strong) UILabel               *lblFullName;
@property (nonatomic, strong) UIButton              *btnAddFriend;
@property (nonatomic, strong) UIView                *vAddFriend;
@end
