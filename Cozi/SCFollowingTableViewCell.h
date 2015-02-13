//
//  SCFollowingTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "TTTAttributedLabel.h"

@interface SCFollowingTableViewCell : UITableViewCell
{
    Helper              *helperIns;
}

@property (nonatomic, strong) UILabel           *lblNickName;
@property (nonatomic, strong) UIImageView       *imgAvatar;
@property (nonatomic, strong) UIButton          *btnFollowing;
@end
