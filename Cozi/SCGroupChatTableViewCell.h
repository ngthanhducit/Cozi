//
//  SCGroupChatTableViewCell.h
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCGroupChatTableViewCell : UITableViewCell
{
    Helper          *helperIns;
}

@property (nonatomic, strong) UILabel           *lblNickName;
@property (nonatomic, strong) UIImageView       *imgAvatar;

@end
