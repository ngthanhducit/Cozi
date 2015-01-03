//
//  SCWallTableViewCellV2.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "TTTAttributedLabel.h"
#import "DataWall.h"
#import "PostComment.h"
#import "PostLike.h"
#import "Store.h"
#import "SCLikeView.h"
#import "SCCommentView.h"

@interface SCWallTableViewCellV2 : UITableViewCell <TTTAttributedLabelDelegate>
{
    Helper              *helperIns;
    Store               *storeIns;
    CGFloat             widthBlock;
    CGFloat             spacing;
    CGFloat             leftSpacing;
    CGFloat             leftSpacingComment;
    CGFloat             heightDefault;
    CGFloat             spacingLineComment;
    CGFloat             heightVTool;
    
    CGSize              sizeIconLeft;
    CGSize              sizeAvatarComment;
    
}

@property (nonatomic, strong) UIView                  *mainView;
@property (nonatomic, strong) UIView                  *vImages;
@property (nonatomic, strong) UIView                  *vLike;
@property (nonatomic, strong) UIView                  *vProfile;
@property (nonatomic, strong) UIView                  *vStatus;
@property (nonatomic, strong) UIView                  *vAllComment;
@property (nonatomic, strong) UIView                  *vComment;
@property (nonatomic, strong) UIView                  *vTool;

@property (nonatomic, strong) SCLikeView              *vLikeButton;
@property (nonatomic, strong) SCCommentView           *vCommentButton;

@property (nonatomic, strong) UIButton                *btnLike;
@property (nonatomic, strong) UIButton                *btnComment;

@property (nonatomic, strong) UIImageView             *imgView;
@property (nonatomic, strong) UIButton                *imgMore;
@property (nonatomic,strong ) UIImageView             *imgQuotes;
@property (nonatomic, strong) UIImageView               *imgQuotesWhite;
@property (nonatomic, strong) UIImageView               *imgQuotesWhiteRight;
@property (nonatomic, strong) UILabel                 *lblLike;
@property (nonatomic, strong) UILabel                 *lblComment;
@property (nonatomic, strong) UIImageView             *imgAvatar;
@property (nonatomic, strong) UILabel                 *lblFullName;
@property (nonatomic, strong) UILabel                 *lblLocation;
@property (nonatomic, strong) UILabel                 *lblViewAllComment;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CALayer                 *bottomLike;

@property (nonatomic, strong) NSString                *nickNameText;
@property (nonatomic, strong) NSString                *statusText;
@property (nonatomic, strong) DataWall                *wallData;
@property (nonatomic, strong) TTTAttributedLabel      *lblStatus;

- (void) setDataWall:(DataWall*)_wall;
- (void) renderComment;
- (void) setTextStatus;
@end
