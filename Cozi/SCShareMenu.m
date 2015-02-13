//
//  SCShareMenu.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCShareMenu.h"

@implementation SCShareMenu

@synthesize vMenuShare;
@synthesize btnMood;
@synthesize btnCamera;
@synthesize btnPhoto;
@synthesize btnLocation;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{

    helperIns = [Helper shareInstance];
    
    self.vMenuShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.vMenuShare setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248/255.0f alpha:0.8]];
    [self addSubview:self.vMenuShare];
    
    UIImage *imgBackgroundButton = [helperIns imageWithColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] size:CGSizeMake(self.bounds.size.width / 4, self.bounds.size.width / 4)];
                                       
    self.btnMood = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnMood setBackgroundImage:imgBackgroundButton forState:UIControlStateHighlighted];
    [self.btnMood setFrame:CGRectMake(0, 0, self.bounds.size.width / 4, self.bounds.size.width / 4)];
    [self.btnMood setImage:[helperIns getImageFromSVGName:@"icon-QuotesGrey-V2.svg"] forState:UIControlStateNormal];
    [self.btnMood setTitle:@"MOOD" forState:UIControlStateNormal];
    [self.btnMood setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnMood.titleLabel  setFont:[helperIns getFontLight:12.0f]];
    
    [self centerVerticalWithPading:5.0f withButton:self.btnMood];
    
    [self.vMenuShare addSubview:self.btnMood];

    //Camera button
    self.btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCamera setBackgroundColor:[UIColor clearColor]];
    [self.btnCamera setBackgroundImage:imgBackgroundButton forState:UIControlStateHighlighted];
    [self.btnCamera setFrame:CGRectMake(self.bounds.size.width / 4, 0, self.bounds.size.width / 4, self.bounds.size.width / 4)];
    [self.btnCamera setTitle:@"CAMERA" forState:UIControlStateNormal];
    [self.btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCamera.titleLabel setFont:[helperIns getFontLight:12.0f]];
    [self.btnCamera setImage:[helperIns getImageFromSVGName:@"icon-CameraGrey.svg"] forState:UIControlStateNormal];
    
    [self centerVerticalWithPading:5.0 withButton:self.btnCamera];
    
    [self.vMenuShare addSubview:self.btnCamera];
    
    //Photo button
    self.btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPhoto setBackgroundColor:[UIColor clearColor]];
    [self.btnPhoto setBackgroundImage:imgBackgroundButton forState:UIControlStateHighlighted];
    [self.btnPhoto setFrame:CGRectMake((self.bounds.size.width / 4) * 2, 0, self.bounds.size.width / 4, self.bounds.size.width / 4)];
    [self.btnPhoto setTitle:@"PHOTO" forState:UIControlStateNormal];
    [self.btnPhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnPhoto.titleLabel setFont:[helperIns getFontLight:12.0f]];
    [self.btnPhoto setImage:[helperIns getImageFromSVGName:@"icon-PhotoGrey.svg"] forState:UIControlStateNormal];
    
    [self centerVerticalWithPading:5.0 withButton:self.btnPhoto];
    
    [self.vMenuShare addSubview:self.btnPhoto];
    
    //Location Button
    self.btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLocation setBackgroundColor:[UIColor clearColor]];
    [self.btnLocation setBackgroundImage:imgBackgroundButton forState:UIControlStateHighlighted];
    [self.btnLocation setFrame:CGRectMake((self.bounds.size.width / 4) * 3, 0, self.bounds.size.width / 4, self.bounds.size.width / 4)];
    [self.btnLocation setTitle:@"LOCATION" forState:UIControlStateNormal];
    [self.btnLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnLocation.titleLabel setFont:[helperIns getFontLight:12.0f]];
    [self.btnLocation setImage:[helperIns getImageFromSVGName:@"icon-LocationGrey.svg"] forState:UIControlStateNormal];
    
    [self centerVerticalWithPading:5.0 withButton:self.btnLocation];
    
    [self.vMenuShare addSubview:self.btnLocation];
}

- (void) centerVerticalWithPading:(float)padding withButton:(UIButton*)_btn{
    CGSize imageSize = _btn.imageView.frame.size;
    CGSize titleSize = _btn.titleLabel.frame.size;
    
    _btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + padding),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - (imageSize.width),
                                            - (imageSize.height + padding),
                                            0.0f);
}
@end
