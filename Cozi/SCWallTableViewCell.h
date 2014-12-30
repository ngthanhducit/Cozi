//
//  SCWallTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface SCWallTableViewCell : UITableViewCell
{
    Helper              *helperIns;
    
//    CGSize              sizeScreen;
    CGFloat             widthBlock;
//    DataWall            *wallData;
//    NSData              *avatarData;
    
//    UIView          *vImages;
//    UIView          *vLike;
//    UIView          *vProfile;
//    UIView          *vStatus;
//    UIView          *vComment;
}

@property (nonatomic, strong) UIView                    *mainView;
@property (nonatomic, strong) UIView                    *vImages;
@property (nonatomic, strong) UIView                    *vLike;
@property (nonatomic, strong) UIView                    *vProfile;
@property (nonatomic, strong) UIView                    *vStatus;
@property (nonatomic, strong) UIView                    *vComment;

@property (nonatomic, strong) UIImageView               *imgView;
@property (nonatomic, strong) UILabel                   *lblLike;
@property (nonatomic, strong) UILabel                   *lblComment;
@property (nonatomic, strong) UIImageView               *imgAvatar;
@property (nonatomic, strong) UILabel                   *lblFullName;
@property (nonatomic, strong) UILabel                   *lblLocation;
@property (nonatomic, strong) UILabel                   *lblStatus;

@end
