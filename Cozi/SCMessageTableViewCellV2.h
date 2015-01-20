//
//  SCMessageTableViewCellV2.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/18/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "TriangleView.h"
#import "SCMessageImageView.h"

@interface SCMessageTableViewCellV2 : UITableViewCell
{
    Helper              *helperIns;
}

@property (nonatomic, strong) TriangleView                    *vTriangle;
@property (nonatomic, strong) TriangleView              *blackTriangle;
@property (nonatomic, strong) UIView                    *viewMain;
@property (nonatomic, strong) UIView                    *viewCircle;
@property (nonatomic, strong) UIView                    *viewImage;
@property (nonatomic, strong) UIView                    *vMessengerImageShadow;
@property (nonatomic, strong) SCMessageImageView        *vMessengerImage;
@property (nonatomic, strong) SCMessageImageView        *vMessengerImageFriend;
@property (nonatomic, strong) UIImageView               *smsImage;
@property (nonatomic, strong) UILabel                   *lblTime;

@property (nonatomic, strong) UITextView                *txtMessageContent;

@property (nonatomic, strong) UIImageView               *iconImage;
@property (nonatomic, strong) UIImageView               *iconFriend;
@property (nonatomic, strong) UIImageView               *imgStatusMessage;
@end
