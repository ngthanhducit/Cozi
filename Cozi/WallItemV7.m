//
//  WallItemV7.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/23/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "WallItemV7.h"

@implementation WallItemV7

- (id) initWithData:(DataWall*)_dataWall withAvatar:(NSData *)_avatarData withWidth:(CGFloat)width{
    
    self = [super init];
    if (self) {
        
        widthBlock = width;
        wallData = _dataWall;
        avatarData = _avatarData;
        
        [self setupVariable];
        [self setup];
    }
    
    return self;
}

- (void) setupVariable{
    
    helperIns = [Helper shareInstance];
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 8.0f;
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(3, 0);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 1;
    
}

- (void) setup{
    
    vImages = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [vImages setBackgroundColor:[UIColor orangeColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[wallData.images lastObject]];
    [imageView setFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setAutoresizingMask:UIViewAutoresizingNone];
    imageView.layer.borderWidth = 0.0f;
    [imageView setClipsToBounds:YES];

    [vImages addSubview:imageView];
    
    [self addSubview:vImages];
    
    vLike = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height, widthBlock, 40)];
    [vLike setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
    [imgLike setBackgroundColor:[UIColor clearColor]];
    [imgLike setFrame:CGRectMake(10, 0, 40, 40)];
    [vLike addSubview:imgLike];
    
    UILabel *lblLike = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 80, 40)];
    [lblLike setText:@"53"];
    [lblLike setTextColor:[UIColor grayColor]];
    [lblLike setTextAlignment:NSTextAlignmentLeft];
    [lblLike setFont:[helperIns getFontLight:18.0f]];
    [vLike addSubview:lblLike];
    
    UIImageView *imgComment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
    [imgComment setBackgroundColor:[UIColor clearColor]];
    [imgComment setFrame:CGRectMake(130, 0, 40, 40)];
    [vLike addSubview:imgComment];
    
    UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 40)];
    [lblComment setText:@"8"];
    [lblComment setTextColor:[UIColor grayColor]];
    [lblComment setTextAlignment:NSTextAlignmentLeft];
    [lblComment setFont:[helperIns getFontLight:18.0f]];
    [vLike addSubview:lblComment];
    
    [self addSubview:vLike];
    
    CALayer *bottomLike = [CALayer layer];
    [bottomLike setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomLike setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.layer addSublayer:bottomLike];
    
    vProfile = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height, widthBlock, 60)];
    [vProfile setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageWithData:avatarData]];
    [avatar setFrame:CGRectMake(10, 10, 40, 40)];
    [avatar setContentMode:UIViewContentModeScaleAspectFill];
    [avatar setAutoresizingMask:UIViewAutoresizingNone];
    avatar.layer.borderWidth = 0.0f;
    [avatar setClipsToBounds:YES];
    avatar.layer.cornerRadius = CGRectGetHeight(avatar.frame)/2;

    //Add Nick Name
    UILabel *lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(avatar.bounds.size.width + 20, 0, widthBlock - (avatar.bounds.size.width + 20), 30)];
    [lblNickName setTextAlignment:NSTextAlignmentLeft];
    [lblNickName setText:wallData.fullName];
    [lblNickName setTextColor:[UIColor blackColor]];
    [lblNickName setFont:[helperIns getFontLight:13.0f]];
    
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(avatar.bounds.size.width + 20, 30, widthBlock - (avatar.bounds.size.width + 20), 30)];
    [lblLocation setTextAlignment:NSTextAlignmentLeft];
    [lblLocation setText:@"redesigning my dining room"];
    [lblLocation setTextColor:[UIColor grayColor]];
    [lblLocation setFont:[helperIns getFontLight:13.0f]];
    
    [vProfile addSubview:lblLocation];
    [vProfile addSubview:lblNickName];
    [vProfile addSubview:avatar];
    [self addSubview:vProfile];
    
    CALayer *bottomProfile = [CALayer layer];
    [bottomProfile setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomProfile setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.layer addSublayer:bottomProfile];
    
    CGSize textSize = CGSizeMake(widthBlock, 10000);
    CGSize size = { 0 , 0 };
    
    if (![wallData.content isEqualToString:@""]) {
        size = [wallData.content sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        
        vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height, widthBlock, size.height + 20)];
    }else{
        wallData.content = @"Post Content";
        
        vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height, widthBlock, 40)];
        
        size = CGSizeMake(widthBlock, 40);
    }
    
    [vStatus setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, widthBlock, size.height)];
    [lblStatus setNumberOfLines:0];
    [lblStatus setTextAlignment:NSTextAlignmentLeft];
    [lblStatus setText:wallData.content];
    [lblStatus setTextColor:[UIColor blackColor]];
    [lblStatus setFont:[helperIns getFontLight:15.0f]];
    
    [vStatus addSubview:lblStatus];
    [self addSubview:vStatus];
    
    CALayer *bottomStatus = [CALayer layer];
    [bottomStatus setFrame:CGRectMake(0.0f, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + vStatus.bounds.size.height + 1, widthBlock, 1.0f)];
    [bottomStatus setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.layer addSublayer:bottomStatus];
    
    vComment = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + vStatus.bounds.size.height, widthBlock, 50)];
    [vComment setBackgroundColor:[UIColor clearColor]];
    [self addSubview:vComment];
    
}

-(int) getHeight{
    
    return vImages.bounds.size.height + vLike.bounds.size.height + vProfile.bounds.size.height + vStatus.bounds.size.height + vComment.bounds.size.height;
    
}
@end
