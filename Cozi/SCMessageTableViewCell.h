//
//  SCMessageTableViewCell.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messenger.h"
#import "Friend.h"
#import "Helper.h"

@interface SCMessageTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, strong) UIView                    *viewMain;
@property (nonatomic, strong) UIView                    *viewCircle;
@property (nonatomic, strong) UIImageView               *iconImage;
@property (nonatomic, strong) UIImageView               *iconFriend;
@property (nonatomic, strong) UIImageView               *smsImage;
@property (nonatomic, strong) UILabel                   *lblTime;
@property (nonatomic, strong) UITextView                *txtMessageContent;
@property (nonatomic, strong) Messenger                   *messageIns;

@property (nonatomic, strong) Helper                    *helperIns;
@property (nonatomic, strong) Friend                    *friendIns;

@end
