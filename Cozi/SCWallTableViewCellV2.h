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
#import "SDWebImage/UIImageView+WebCache.h"

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
    
    
    UIImage             *dImageLike;
    UIImage             *dImageMore;
    UIImage             *dImageQuote;
    UIImage             *dImageQuoteWhite;
    UIImage             *dImageMoreComment;
    UIImage             *dIconLike;
    UIImage             *dIconComment;

}

@property (nonatomic, strong) UIActivityIndicatorView         *imgWaiting;
@property (nonatomic, strong ) UIView                  *mainView;
@property (nonatomic, strong ) UIView                  *vImages;
@property (nonatomic, strong ) UIView                  *vLike;
@property (nonatomic, strong ) UIView                  *vProfile;
@property (nonatomic, strong ) UIView                  *vStatus;
@property (nonatomic, strong ) UIView                  *vAllComment;
@property (nonatomic, strong ) UIView                  *vComment;
@property (nonatomic, strong ) UIView                  *vTool;
@property (nonatomic, strong ) UIView                  *vDistance;

@property (nonatomic, strong ) SCLikeView              *vLikeButton;
@property (nonatomic, strong ) SCCommentView           *vCommentButton;

@property (nonatomic, strong ) UIButton                *btnLike;
@property (nonatomic, strong ) UIButton                *btnComment;
@property (nonatomic, strong)  UIImageView             *iconViewAllComment;
@property (nonatomic, strong ) UIImageView             *imgView;
@property (nonatomic, strong ) UIButton                *btnMore;
@property (nonatomic, strong ) UIImageView             *imgQuotes;
@property (nonatomic, strong ) UIImageView             *imgQuotesWhite;
@property (nonatomic, strong ) UIImageView             *imgQuotesWhiteRight;
@property (nonatomic, strong ) UILabel                 *lblLike;
@property (nonatomic, strong ) UILabel                 *lblComment;
@property (nonatomic, strong ) UIImageView             *imgAvatar;
@property (nonatomic, strong ) UILabel                 *lblFullName;
@property (nonatomic, strong ) UILabel                 *lblLocation;
@property (nonatomic, strong ) UILabel                 *lblViewAllComment;
@property (nonatomic, strong ) UIActivityIndicatorView *spinner;
@property (nonatomic, strong ) CALayer                 *bottomLike;
@property (nonatomic, strong ) CALayer                 *bottomStatusTextOnly;

@property (nonatomic, copy   ) NSString                *nickNameText;
@property (nonatomic, copy   ) NSString                *statusText;
@property (nonatomic, weak ) DataWall                *wallData;
@property (nonatomic, strong ) TTTAttributedLabel      *lblStatus;
@property (nonatomic, strong ) TTTAttributedLabel      *lblStatusTextOnly;

@property (nonatomic, strong) UIImageView               *imgAddFavorite;
@property (nonatomic, strong) UIImageView               *imgRemoveFavorite;

- (void) renderComment;
- (void) setTextStatus;
@end
