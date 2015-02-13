//
//  SCLikeTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCLikeTableViewCell : UITableViewCell
{
    Helper              *helperIns;
}

@property (nonatomic, strong) UILabel           *lblNickName;
@property (nonatomic, strong) UIImageView       *imgAvatar;
@property (nonatomic, strong) UIButton          *btnFollowing;
//@property (nonatomic, strong) UIView            *vFollowing;
@end
