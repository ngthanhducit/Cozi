//
//  SCFollowersTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFollowersTableViewCell.h"

@implementation SCFollowersTableViewCell

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
    [self.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    [self.imgAvatar setClipsToBounds:YES];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.width / 2;
    [self.contentView addSubview:self.imgAvatar];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, sizeScreen.size.width - 160, 40)];
    [self.lblNickName setText:@"NICK NAME"];
    [self.lblNickName setFont:[helperIns getFontLight:14.0f]];
    [self.contentView addSubview:self.lblNickName];
    
//    UIImage *imgTickWhite = [helperIns getImageFromSVGName:@"icon-TickWhite.svg"];
    //UIImage *imgTickGrey = [helperIns getImageFromSVGName:@"icon-TickGrey.svg"];
    
    UIImage *imgSelect = [helperIns imageWithColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] size:CGSizeMake(100, 30)];
    
    self.btnFollowing = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFollowing setTitle:@"FOLLOWING" forState:UIControlStateNormal];
    [self.btnFollowing setFrame:CGRectMake(sizeScreen.size.width - 110, 5, 100, 30)];
    [self.btnFollowing.titleLabel setFont:[helperIns getFontLight:14.0f]];
    [self.btnFollowing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnFollowing setClipsToBounds:YES];
    self.btnFollowing.layer.cornerRadius = 3.0f;
    self.btnFollowing.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnFollowing.layer.borderWidth = 1.0f;
    [self.btnFollowing setBackgroundImage:imgSelect forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.btnFollowing];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
