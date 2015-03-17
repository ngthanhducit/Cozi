//
//  SCGroupChatTableViewCell.m
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCGroupChatTableViewCell.h"

@implementation SCGroupChatTableViewCell

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
    [self.imgAvatar setImage:[helperIns getDefaultAvatar]];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.width / 2;
    [self.contentView addSubview:self.imgAvatar];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, sizeScreen.size.width - 160, 40)];
    [self.lblNickName setText:@"NICK NAME"];
    [self.lblNickName setFont:[helperIns getFontLight:14.0f]];
    [self.contentView addSubview:self.lblNickName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
