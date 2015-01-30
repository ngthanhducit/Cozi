//
//  SCMessageTableViewCellV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/18/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMessageTableViewCellV2.h"
#import "SCMessageTableViewV2.h"

@implementation SCMessageTableViewCellV2

@synthesize viewMain;
@synthesize lblTime;
@synthesize smsImage;
@synthesize txtMessageContent;
@synthesize iconImage;
@synthesize iconFriend;
@synthesize imgStatusMessage;
@synthesize viewImage;
@synthesize vTriangle;
@synthesize vMessengerImage;
@synthesize vMessengerImageFriend;
@synthesize vMessengerImageShadow;
@synthesize lblTimeMessengerImage;
@synthesize imgStatusMessengerImage;
@synthesize btnDownloadImage;

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        helperIns = [Helper shareInstance];
        self.selectionStyle = UITableViewCellAccessoryNone;
        
        self.viewMain = [[UIView alloc] initWithFrame:CGRectZero];
        self.viewMain.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.viewMain.layer.shadowOffset = CGSizeMake(1, 1);
        self.viewMain.layer.shadowOpacity = 1;
        self.viewMain.layer.shadowRadius = 1.0;
        [self.contentView addSubview:self.viewMain];
        
        self.vTriangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.vTriangle setBackgroundColor:[UIColor whiteColor]];
        [self.vTriangle drawTrianMessage];
        [self.contentView addSubview:self.vTriangle];
        
        self.blackTriangle = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.blackTriangle setBackgroundColor:[UIColor blackColor]];
        [self.blackTriangle drawTrianMessageBlack];
        [self.contentView addSubview:self.blackTriangle];
        
        self.lblTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.lblTime setFont:[helperIns getFontLight:8]];
        [self.lblTime setTextAlignment:NSTextAlignmentLeft];
        [self.viewMain addSubview:self.lblTime];
        
        self.txtMessageContent = [[UITextView alloc] init];
        [self.txtMessageContent setBackgroundColor:[UIColor clearColor]];
        [self.txtMessageContent setFont:[helperIns getFontLight:15]];
        [self.txtMessageContent setTextAlignment:NSTextAlignmentLeft];
        [self.txtMessageContent setEditable:NO];
        [self.txtMessageContent setScrollEnabled:NO];
        [self.txtMessageContent sizeToFit];
        [self.txtMessageContent setTextContainerInset:UIEdgeInsetsMake(-4, -4, 0, 0)];
//        [self.txtMessageContent setDataDetectorTypes:UIDataDetectorTypeLink];
//        [self.txtMessageContent setTextColor:[UIColor blackColor]];
        [self.viewMain addSubview:self.txtMessageContent];
        
        self.imgStatusMessage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.imgStatusMessage setImage:[helperIns getImageFromSVGName:@"icon-EyeGrey.svg"]];
        [self.viewMain addSubview:self.imgStatusMessage];
        
        self.smsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.smsImage];
    
        CGFloat wViewMessenger = self.bounds.size.width - 75;
        
        self.vMessengerImageShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wViewMessenger - 5, 160)];
        [self.vMessengerImageShadow setBackgroundColor:[UIColor lightGrayColor]];
        self.vMessengerImageShadow.layer.shadowColor = [UIColor grayColor].CGColor;
        self.vMessengerImageShadow.layer.shadowOffset = CGSizeMake(1, 1);
        self.vMessengerImageShadow.layer.shadowOpacity = 1;
        self.vMessengerImageShadow.layer.shadowRadius = 1.0;
        [self.contentView addSubview:self.vMessengerImageShadow];

        self.vMessengerImage = [[SCMessageImageView alloc] initWithFrame:CGRectMake(0, 0, wViewMessenger, 160)];
        [self.vMessengerImage drawRight:self.vMessengerImage.bounds];
        [self.contentView addSubview:self.vMessengerImage];
        
        self.vMessengerImageFriend = [[SCMessageImageView alloc] initWithFrame:CGRectMake(0, 0, wViewMessenger, 160)];
        [self.vMessengerImageFriend drawLeft:self.vMessengerImageFriend.bounds];
        [self.contentView addSubview:self.vMessengerImageFriend];
        
        self.lblTimeMessengerImage = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.lblTimeMessengerImage setTextAlignment:NSTextAlignmentLeft];
        [self.lblTimeMessengerImage setFont:[helperIns getFontLight:11.0f]];
        [self.lblTimeMessengerImage setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.lblTimeMessengerImage];
        
        self.imgStatusMessengerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.imgStatusMessengerImage setImage:[helperIns getImageFromSVGName:@"icon-EyeGrey.svg"]];
        [self.contentView addSubview:self.imgStatusMessengerImage];
        
        self.viewImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wViewMessenger - 5, 160)];
        [self.viewImage setBackgroundColor:[UIColor clearColor]];
        [self.viewImage setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.viewImage];
        
        UIImage *img = [helperIns getImageFromSVGName:@"icon-DownloadImage.svg"];
        
        self.btnDownloadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnDownloadImage setFrame:CGRectMake((self.viewImage.bounds.size.width / 2) - 25, (self.viewImage.bounds.size.height / 2) - 25, 50, 50)];
        [self.btnDownloadImage setImage:img forState:UIControlStateNormal];
        [self.btnDownloadImage setClipsToBounds:YES];
        [self.btnDownloadImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.btnDownloadImage setAutoresizingMask:UIViewAutoresizingNone];
        self.btnDownloadImage.layer.cornerRadius = self.btnDownloadImage.bounds.size.width / 2;
        self.btnDownloadImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnDownloadImage.layer.borderWidth = 2.0f;
        [self.viewImage addSubview:self.btnDownloadImage];
        
        CGFloat xIcon = self.bounds.size.width - (50);
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.iconImage setFrame:CGRectMake(xIcon, 5, 40, 40)];
        [self.iconImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.iconImage setAutoresizingMask:UIViewAutoresizingNone];
        self.iconImage.layer.borderWidth = 0.0f;
        [self.iconImage setClipsToBounds:YES];
        self.iconImage.layer.cornerRadius = CGRectGetHeight(self.iconImage.frame) / 2;

        [self.contentView addSubview:self.iconImage];
        
        self.iconFriend = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [self.iconFriend setContentMode:UIViewContentModeScaleAspectFill];
        [self.iconFriend setAutoresizingMask:UIViewAutoresizingNone];
        self.iconFriend.layer.borderWidth = 0.0f;
        [self.iconFriend setClipsToBounds:YES];
        self.iconFriend.layer.cornerRadius = CGRectGetHeight(self.iconFriend.frame) / 2;
        [self.contentView addSubview:self.iconFriend];
        
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
