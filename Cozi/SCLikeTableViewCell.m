//
//  SCLikeTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLikeTableViewCell.h"

@implementation SCLikeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    CGRect sizeScreen = [[UIScreen mainScreen] bounds];

    helperIns = [Helper shareInstance];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.imgAvatar setBackgroundColor:[UIColor clearColor]];
    [self.imgAvatar setClipsToBounds:YES];
    [self.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.width / 2;
    [self.contentView addSubview:self.imgAvatar];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, sizeScreen.size.width - 160, 40)];
    [self.lblNickName setText:@"NICK NAME"];
    [self.lblNickName setFont:[helperIns getFontLight:14.0f]];
    [self.contentView addSubview:self.lblNickName];
    
    self.btnFollowing = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFollowing setClipsToBounds:YES];
    self.btnFollowing.layer.cornerRadius = 3.0f;
    self.btnFollowing.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnFollowing.layer.borderWidth = 1.0f;
    [self.btnFollowing setFrame:CGRectMake(sizeScreen.size.width - 110, 5, 100, 30)];
    [self.btnFollowing setTitle:@"Following" forState:UIControlStateNormal];
    [self.btnFollowing.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnFollowing setContentMode:UIViewContentModeCenter];
    [self.btnFollowing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnFollowing.titleLabel setFont:[helperIns getFontLight:14.0f]];
    UIColor *colorSignInNormal = [UIColor whiteColor];
    UIColor *colorSignInHighLight = [helperIns colorFromRGBWithAlpha:[helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:1.0f];
    [self.btnFollowing setBackgroundImage:[helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnFollowing setBackgroundImage:[helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.contentView addSubview:self.btnFollowing];
    
//    self.vFollowing = [[UIView alloc] initWithFrame:CGRectMake(sizeScreen.size.width - 110, 5, 100, 30)];
//    [self.vFollowing setUserInteractionEnabled:YES];
//    [self.vFollowing setClipsToBounds:YES];
//    self.vFollowing.layer.cornerRadius = 3.0f;
//    self.vFollowing.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.vFollowing.layer.borderWidth = 1.0f;
//    
//    [self.contentView addSubview:self.vFollowing];
//
//    UIActivityIndicatorView *waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [waiting setTag:6666];
//    [waiting setFrame:self.vFollowing.bounds];
//    [self.vFollowing addSubview:waiting];
//    
//    UILabel *lblFollowing = [[UILabel alloc] initWithFrame:self.vFollowing.bounds];
//    [lblFollowing setTag:7777];
//    [lblFollowing setFont:[helperIns getFontLight:14.0f]];
//    [lblFollowing setText:@"Following"];
//    [lblFollowing setTextColor:[UIColor lightGrayColor]];
//    [lblFollowing setTextAlignment:NSTextAlignmentCenter];
//    [self.vFollowing addSubview:lblFollowing];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
