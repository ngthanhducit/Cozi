//
//  SCNearTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCNearTableViewCell.h"

@implementation SCNearTableViewCell

@synthesize lblName;
@synthesize lblVincity;

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
    
    Helper *hp = [Helper shareInstance];
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *selectionColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [selectionColor setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
    
    UIImage *img = [[Helper shareInstance] getImageFromSVGName:@"icon-TickGrey-v3.svg"];
    UIImageView *_imgView = [[UIImageView alloc] initWithImage:img];
    [_imgView setFrame:CGRectMake(self.bounds.size.width - 40, 5, 40, 40)];
    [_imgView setContentMode:UIViewContentModeCenter];
    [selectionColor addSubview:_imgView];
    
    self.selectedBackgroundView = selectionColor;
    
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width - 80, 40)];
    [self.lblName setBackgroundColor:[UIColor clearColor]];
    [self.lblName setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.lblName setTextColor:[UIColor blackColor]];
//    [self.lblName setAdjustsFontSizeToFitWidth:NO];
    [self.contentView addSubview:self.lblName];
    
    self.lblVincity = [[UILabel alloc] initWithFrame:CGRectMake(20, self.lblName.bounds.size.height, self.bounds.size.width - 80, 20)];
    [self.lblVincity setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.lblVincity];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
