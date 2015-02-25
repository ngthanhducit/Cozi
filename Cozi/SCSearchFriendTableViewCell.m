//
//  SCSearchFriendTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCSearchFriendTableViewCell.h"

@implementation SCSearchFriendTableViewCell

const CGSize        sizeIconFriend = { 35 , 35};

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect sizeScreen = [[UIScreen mainScreen] bounds];
        
        helperIns = [Helper shareInstance];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height / 2) - (sizeIconFriend.height / 2), sizeIconFriend.width, sizeIconFriend.height)];
        [self.imgAvatar setBackgroundColor:[UIColor clearColor]];
        [self.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
        [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
        self.imgAvatar.layer.borderWidth = 0.0f;
        [self.imgAvatar setClipsToBounds:YES];
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.height / 2;
        [self.contentView addSubview:self.imgAvatar];
        
        self.lblFullName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.lblFullName setBackgroundColor:[UIColor clearColor]];
        [self.lblFullName setFont:[helperIns getFontLight:13.0f]];
        [self.lblFullName setTextColor:[UIColor colorWithRed:186.0f/255.0f green:186.0f/255.0f blue:186.0f/255.0f alpha:1.0f]];
        [self.lblFullName setFrame:CGRectMake(60, 0, sizeScreen.size.width - 120, self.bounds.size.height)];
        [self.contentView addSubview:self.lblFullName];
        
        UIImage *imgHighlight = [helperIns imageWithColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] size:CGSizeMake(60, self.bounds.size.height - 10)];
        
        self.btnAddFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnAddFriend setFrame:CGRectMake(sizeScreen.size.width - 70, 5, 60, self.bounds.size.height - 10)];
        [self.btnAddFriend setClipsToBounds:YES];
        self.btnAddFriend.layer.cornerRadius = 3.0f;
        self.btnAddFriend.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnAddFriend.layer.borderWidth = 1.0f;
        [self.btnAddFriend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnAddFriend setTitle:@"ADD" forState:UIControlStateNormal];
        [self.btnAddFriend.titleLabel setFont:[helperIns getFontLight:15.0f]];
        [self.btnAddFriend setBackgroundImage:imgHighlight forState:UIControlStateHighlighted];
        [self.contentView addSubview:self.btnAddFriend];
        
        self.vAddFriend = [[UIView alloc] initWithFrame:CGRectMake(sizeScreen.size.width - 70, 5, 60, self.bounds.size.height - 10)];
        [self.vAddFriend setHidden:YES];
        [self.vAddFriend setUserInteractionEnabled:YES];
        [self.vAddFriend setClipsToBounds:YES];
        self.vAddFriend.layer.cornerRadius = 3.0f;
        self.vAddFriend.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.vAddFriend.layer.borderWidth = 1.0f;
        
        [self.contentView addSubview:self.vAddFriend];
        
        UIActivityIndicatorView *waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [waiting setTag:6666];
        [waiting setFrame:self.vAddFriend.bounds];
        [self.vAddFriend addSubview:waiting];
        
        UILabel *lblFollowing = [[UILabel alloc] initWithFrame:self.vAddFriend.bounds];
        [lblFollowing setTag:7777];
        [lblFollowing setFont:[helperIns getFontLight:14.0f]];
        [lblFollowing setText:@"ADD"];
        [lblFollowing setTextColor:[UIColor lightGrayColor]];
        [lblFollowing setTextAlignment:NSTextAlignmentCenter];
//        [self.vAddFriend addSubview:lblFollowing];
    }
    
    for (UIView *currentView in self.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    // iterate over all the UITableViewCell's subviews
//    for (id view in self.subviews)
//    {
//        // looking for a UITableViewCellScrollView
//        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellScrollView"])
//        {
//            // this test is here for safety only, also there is no UITableViewCellScrollView in iOS8
//            if([view isKindOfClass:[UIScrollView class]])
//            {
//                // turn OFF delaysContentTouches in the hidden subview
//                UIScrollView *scroll = (UIScrollView *) view;
//                scroll.delaysContentTouches = NO;
//            }
//            break;
//        }
//    }
    
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
