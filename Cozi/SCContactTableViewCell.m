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

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        Helper *hp = [Helper shareInstance];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        UIView *selectionColor = [[UIView alloc] init];
        [selectionColor setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor"]]];
        self.selectedBackgroundView = selectionColor;
        
        self.iconContact = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.iconContact];
        
        self.lblFullName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lblFullName];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
