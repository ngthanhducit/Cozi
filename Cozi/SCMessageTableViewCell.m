//
//  SCMessageTableViewCell.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SCMessageTableViewCell.h"

@implementation SCMessageTableViewCell

@synthesize viewMain;
@synthesize iconImage;
@synthesize txtMessageContent;
@synthesize smsImage;
@synthesize iconFriend;
@synthesize messageIns;
@synthesize helperIns;
@synthesize friendIns;
@synthesize viewCircle;

static CGFloat _padding = 20.0;
const CGFloat _leftSpacing = 10;
const CGFloat _topSpacing = 5.0f;
const CGFloat _wViewMainPadding = 30.0f;
const CGSize _sizeImage = { 80, 80 };
const CGSize _sizeIcon = { 40, 40 };

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.viewMain = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.viewMain];
        
        self.lblTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.lblTime setFont:[self.helperIns getFontThin:8]];
        [self.contentView addSubview:self.lblTime];
        
        self.smsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.smsImage];
        
        self.txtMessageContent = [[UITextView alloc] init];
        [self.txtMessageContent setBackgroundColor:[UIColor clearColor]];
        [self.txtMessageContent setFont:[self.helperIns getFontThin:15]];
        [self.txtMessageContent setEditable:NO];
        [self.txtMessageContent setScrollEnabled:NO];
        [self.txtMessageContent sizeToFit];
        [self.txtMessageContent setDataDetectorTypes:UIDataDetectorTypeLink];
        [self.txtMessageContent setTextColor:[UIColor blackColor]];
        [self.viewMain addSubview:self.txtMessageContent];
        
        self.viewCircle = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.viewCircle];
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:self.iconImage];
        [self.viewCircle addSubview:self.iconImage];
        
        self.iconFriend = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:self.iconFriend];
        [self.viewCircle addSubview:self.iconFriend];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIMenuController required methods
- (BOOL)canBecomeFirstResponder {
    // NOTE: This menu item will not show if this is not YES!
    return YES;
}



@end
