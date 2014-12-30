//
//  SCWallTableViewCell.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCWallTableViewCell.h"

@implementation SCWallTableViewCell

@synthesize mainView;
@synthesize vImages;
@synthesize vLike;
@synthesize vProfile;
@synthesize vStatus;
@synthesize vComment;

@synthesize imgAvatar;
@synthesize imgView;
@synthesize lblLike;
@synthesize lblComment;
@synthesize lblFullName;
@synthesize lblLocation;
@synthesize lblStatus;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUserInteractionEnabled:NO];
        
        self.mainView = [[UIView alloc] initWithFrame:self.bounds];
        [self.mainView.layer setMasksToBounds:YES];
        self.mainView.layer.cornerRadius = 8.0f;
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
        self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mainView.layer.shadowOffset = CGSizeMake(3, 0);
        self.mainView.layer.shadowOpacity = 0.3f;
        self.mainView.layer.shadowRadius = 1;
        
        [self.contentView addSubview:self.mainView];
        
        [self setupVariable];
        [self setup];
        
    }
    
    return self;
}

- (void) setupVariable{
    
    widthBlock = self.bounds.size.width - 20;
}

- (void) setup{
    
    self.vImages = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [vImages setBackgroundColor:[UIColor clearColor]];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [self.imgView setFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgView setAutoresizingMask:UIViewAutoresizingNone];
    self.imgView.layer.borderWidth = 0.0f;
    [self.imgView setClipsToBounds:YES];
    
    [self.vImages addSubview:self.imgView];
    
    [self.mainView addSubview:vImages];
    
    self.vLike = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height, widthBlock, 40)];
    [vLike setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
    [imgLike setBackgroundColor:[UIColor clearColor]];
    [imgLike setFrame:CGRectMake(10, 0, 40, 40)];
    [vLike addSubview:imgLike];
    
    self.lblLike = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 80, 40)];
    [self.lblLike setText:@"53"];
    [self.lblLike setTextColor:[UIColor grayColor]];
    [self.lblLike setTextAlignment:NSTextAlignmentLeft];
    [self.lblLike setFont:[helperIns getFontLight:18.0f]];
    [vLike addSubview:self.lblLike];
    
    UIImageView *imgComment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
    [imgComment setBackgroundColor:[UIColor clearColor]];
    [imgComment setFrame:CGRectMake(130, 0, 40, 40)];
    [vLike addSubview:imgComment];
    
    self.lblComment = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 40)];
    [self.lblComment setText:@"8"];
    [self.lblComment setTextColor:[UIColor grayColor]];
    [self.lblComment setTextAlignment:NSTextAlignmentLeft];
    [self.lblComment setFont:[helperIns getFontLight:18.0f]];
    [vLike addSubview:self.lblComment];
    
    [self.mainView addSubview:vLike];
    
    CALayer *bottomLike = [CALayer layer];
    [bottomLike setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomLike setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainView.layer addSublayer:bottomLike];
    
    self.vProfile = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height, widthBlock, 60)];
    [vProfile setBackgroundColor:[UIColor clearColor]];
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    self.imgAvatar.layer.borderWidth = 0.0f;
    [self.imgAvatar setClipsToBounds:YES];
    imgAvatar.layer.cornerRadius = CGRectGetHeight(self.imgAvatar.frame)/2;
    
    //Add Nick Name
    self.lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(self.imgAvatar.bounds.size.width + 20, 0, widthBlock - (self.imgAvatar.bounds.size.width + 20), 30)];
    [self.lblFullName setText:@"Cozi"];
    [self.lblFullName setTextAlignment:NSTextAlignmentLeft];
    [self.lblFullName setTextColor:[UIColor blackColor]];
    [self.lblFullName setFont:[helperIns getFontLight:13.0f]];
    
    self.lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(self.imgAvatar.bounds.size.width + 20, 30, widthBlock - (self.imgAvatar.bounds.size.width + 20), 30)];
    [self.lblLocation setTextAlignment:NSTextAlignmentLeft];
    [self.lblLocation setText:@"redesigning my dining room"];
    [self.lblLocation setTextColor:[UIColor grayColor]];
    [self.lblLocation setFont:[helperIns getFontLight:13.0f]];
    
    [self.vProfile addSubview:self.lblFullName];
    [self.vProfile addSubview:self.lblLocation];
    [self.vProfile addSubview:self.imgAvatar];
    [self.mainView addSubview:self.vProfile];
    
    CALayer *bottomProfile = [CALayer layer];
    [bottomProfile setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomProfile setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainView.layer addSublayer:bottomProfile];
    
    CGSize textSize = CGSizeMake(widthBlock, 10000);
    CGSize size = { 0 , 0 };
    
//    if (![wallData.content isEqualToString:@""]) {
//        size = [wallData.content sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
//        
//        vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height, widthBlock, size.height + 20)];
//    }else{
//        wallData.content = @"Post Content";
//        
//        vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height, widthBlock, 40)];
//        
//        size = CGSizeMake(widthBlock, 40);
//    }
    
    self.vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height, widthBlock, 40)];
    [self.vStatus setBackgroundColor:[UIColor clearColor]];
    
    self.lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, widthBlock, 40)];
    [self.lblStatus setText:@"POST CONTENT"];
    [self.lblStatus setNumberOfLines:0];
    [self.lblStatus setTextAlignment:NSTextAlignmentLeft];
    [self.lblStatus setTextColor:[UIColor blackColor]];
    [self.lblStatus setFont:[helperIns getFontLight:15.0f]];
    
    [vStatus addSubview:lblStatus];
    
    [self.mainView addSubview:vStatus];
    
    CALayer *bottomStatus = [CALayer layer];
    [bottomStatus setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + vStatus.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomStatus setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainView.layer addSublayer:bottomStatus];
    
    vComment = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + vStatus.bounds.size.height, widthBlock, 50)];
    [vComment setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:vComment];
    
}
@end
