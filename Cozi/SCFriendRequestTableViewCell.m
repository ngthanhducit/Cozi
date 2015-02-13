//
//  SCFriendRequestTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFriendRequestTableViewCell.h"

@implementation SCFriendRequestTableViewCell

const CGSize        sizeIconFriendRequest = { 35 , 35};

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        helperIns = [Helper shareInstance];
        
        //        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height / 2) - (sizeIconFriendRequest.height / 2), sizeIconFriendRequest.width, sizeIconFriendRequest.height)];
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
        [self.lblFullName setFrame:CGRectMake(60, 0, self.bounds.size.width - 120, self.bounds.size.height)];
        [self.contentView addSubview:self.lblFullName];
        
        UIImage *imgHighlight = [helperIns imageWithColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] size:CGSizeMake(100, self.bounds.size.height - 10)];
        
        self.btnBlock = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnBlock setBackgroundImage:imgHighlight forState:UIControlStateHighlighted | UIControlStateSelected];
        [self.btnBlock setFrame:CGRectMake(self.bounds.size.width - 270, 5, 80, self.bounds.size.height - 10)];
        [self.btnBlock setClipsToBounds:YES];
        self.btnBlock.layer.cornerRadius = 3.0f;
        self.btnBlock.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnBlock.layer.borderWidth = 1.0f;
        [self.btnBlock setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnBlock setTitle:@"BLOCK" forState:UIControlStateNormal];
        [self.btnBlock.titleLabel setFont:[helperIns getFontLight:15.0f]];
//        [self.contentView addSubview:self.btnBlock];
        
        self.btnDeny = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnDeny setBackgroundImage:imgHighlight forState:UIControlStateHighlighted | UIControlStateSelected];
        [self.btnDeny setFrame:CGRectMake(self.bounds.size.width - 160, 5, 70, self.bounds.size.height - 10)];
        [self.btnDeny setClipsToBounds:YES];
        self.btnDeny.layer.cornerRadius = 3.0f;
        self.btnDeny.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnDeny.layer.borderWidth = 1.0f;
        [self.btnDeny setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnDeny setTitle:@"DENIES" forState:UIControlStateNormal];
        [self.btnDeny.titleLabel setFont:[helperIns getFontLight:15.0f]];
        [self.contentView addSubview:self.btnDeny];
        
        self.btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnAccept setBackgroundImage:imgHighlight forState:UIControlStateHighlighted | UIControlStateSelected];
        [self.btnAccept setFrame:CGRectMake(self.bounds.size.width - 80, 5, 70, self.bounds.size.height - 10)];
        [self.btnAccept setClipsToBounds:YES];
        self.btnAccept.layer.cornerRadius = 3.0f;
        self.btnAccept.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnAccept.layer.borderWidth = 1.0f;
        [self.btnAccept setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnAccept setTitle:@"ACCEPT" forState:UIControlStateNormal];
        [self.btnAccept.titleLabel setFont:[helperIns getFontLight:15.0f]];
        [self.contentView addSubview:self.btnAccept];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
