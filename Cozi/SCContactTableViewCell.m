//
//  SCContactTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCContactTableViewCell.h"

@implementation SCContactTableViewCell

@synthesize iconContact;
@synthesize lblFullName;
@synthesize imgViewCheck;

const CGSize        sizeIconContact = { 35 , 35};

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        Helper *hp = [Helper shareInstance];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect boundMain = [[UIScreen mainScreen] bounds];
        CGFloat wContact = (boundMain.size.width / 4) * 3;
        
        UIImage *img = [[Helper shareInstance] getImageFromSVGName:@"icon-TickWhite-V2.svg"];
        self.imgViewCheck = [[UIImageView alloc] initWithImage:img];
        [self.imgViewCheck setFrame:CGRectMake(wContact - 40, 0, 40, self.bounds.size.height)];
        [self.imgViewCheck setContentMode:UIViewContentModeCenter];
        [self.imgViewCheck setHidden:YES];
        [self.contentView addSubview:self.imgViewCheck];
        
        self.iconContact = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.iconContact setFrame:CGRectMake(10, (self.bounds.size.height / 2) - (sizeIconContact.height / 2), sizeIconContact.width, sizeIconContact.height)];
        [self.iconContact setBackgroundColor:[UIColor clearColor]];
        [self.iconContact setContentMode:UIViewContentModeScaleAspectFill];
        [self.iconContact setAutoresizingMask:UIViewAutoresizingNone];
        self.iconContact.layer.borderWidth = 0.0f;
        [self.iconContact setClipsToBounds:YES];
        self.iconContact.layer.cornerRadius = self.iconContact.bounds.size.height / 2;
        [self.contentView addSubview:self.iconContact];
        
        self.lblFullName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.lblFullName setBackgroundColor:[UIColor clearColor]];
        [self.lblFullName setFont:[hp getFontLight:13.0f]];
        [self.lblFullName setTextColor:[UIColor colorWithRed:186.0f/255.0f green:186.0f/255.0f blue:186.0f/255.0f alpha:1.0f]];
        [self.lblFullName setFrame:CGRectMake(60, 0, wContact - 100, self.bounds.size.height)];
        [self.contentView addSubview:self.lblFullName];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
