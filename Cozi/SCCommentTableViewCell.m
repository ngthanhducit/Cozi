//
//  SCCommentTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCCommentTableViewCell.h"

@implementation SCCommentTableViewCell

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
    
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    [self.imgAvatar setClipsToBounds:YES];
    [self.imgAvatar setImage:[helperIns getImageFromSVGName:@"icon-AvatarGrey.svg"]];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.width / 2;
    [self.contentView addSubview:self.imgAvatar];
    
    self.lblLoadMore = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, sizeScreen.size.width - 55, 50)];
    [self.lblLoadMore setHidden:YES];
    [self.lblLoadMore setFont:[helperIns getFontLight:14.0f]];
    [self.lblLoadMore setText:@"Load more comments"];
    [self.lblLoadMore setTextAlignment:NSTextAlignmentLeft];
    [self.lblLoadMore setTextColor:[UIColor clearColor]];
    [self.contentView addSubview:self.lblLoadMore];
    
    self.lblNickName = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(55, 2.5, sizeScreen.size.width - 100, 20)];
    [self.lblNickName setTextAlignment:NSTextAlignmentJustified];
    self.lblNickName.font = [helperIns getFontRegular:14.0f];
    self.lblNickName.textColor = [UIColor darkGrayColor];
    self.lblNickName.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblNickName.numberOfLines = 0;
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    
    UIFont *baseFont = [helperIns getFontRegular:14.0];
    CTFontRef baseFontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
    mutableLinkAttributes[(__bridge NSString *)kCTFontAttributeName] = (__bridge id)baseFontRef;
    CFRelease(baseFontRef);
    
    self.lblNickName.linkAttributes = mutableLinkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.lblNickName.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.lblNickName.highlightedTextColor = [UIColor whiteColor];
    self.lblNickName.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [self.lblNickName setFont:[helperIns getFontLight:14.0f]];
    [self.contentView addSubview:self.lblNickName];
    
    self.lblComment = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.lblComment setNumberOfLines:0];
    [self.lblComment setTextAlignment:NSTextAlignmentLeft];
    [self.lblComment setFont:[helperIns getFontLight:13.0f]];
    [self.lblComment setTextColor:[UIColor lightGrayColor]];
    
    [self.contentView addSubview:self.lblComment];
    
    self.lblTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.lblTime setTextAlignment:NSTextAlignmentCenter];
    [self.lblTime setFont:[helperIns getFontLight:13.0f]];
    [self.lblTime setTextColor:[UIColor lightGrayColor]];
    
    [self.contentView addSubview:self.lblTime];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
