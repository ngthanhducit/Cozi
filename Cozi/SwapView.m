//
//  SwapView.m
//  VPix
//
//  Created by khoa ngo on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SwapView.h"
#import "Helper.h"

@implementation SwapView

@synthesize _headPanel;
@synthesize _backView;
@synthesize imgLogoView;

-(id) initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    _headerH=0;
    _sizeLogo = CGSizeMake(60, 60);
//    [self drawHeader];
    
//    [self initHeader];

    return self;
}

-(int) getHeaderHeight
{
    return _headerH;
}

-(int) getContentHeight
{
    return self.frame.size.height-_headerH;
}

- (CGSize) getSizeLogo{
    return _sizeLogo;
}

-(void) drawHeader{
    Helper *hp=[Helper shareInstance];
    self._headPanel=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _headerH)];
    self._headPanel.backgroundColor=[hp colorWithHex:[hp getHexIntColorWithKey:@"GrayColor"]];
    [self addSubview:self._headPanel];
}

- (void) initBackView{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 50, 0, 50, _headerH)];
    [_backView setBackgroundColor:[UIColor clearColor]];
    UILabel *lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _backView.bounds.size.width, _backView.bounds.size.height)];
    [lblBack setText:@">"];
    [lblBack setTextAlignment:NSTextAlignmentCenter];
    [lblBack setTextColor:[UIColor blackColor]];
    [_backView addSubview:lblBack];
    [self addSubview:_backView];
}

- (void) initHeader{
    UIImage *imgLogo = [SVGKImage imageNamed:@"v_icon_logo_white.svg"].UIImage;
    
    self.imgLogoView = [[UIImageView alloc] initWithImage:imgLogo];
    [self.imgLogoView setUserInteractionEnabled:YES];
    [self.imgLogoView setFrame:CGRectMake(10, 10, _headerH - 20, _headerH - 20)];
    
    [self._headPanel addSubview:self.imgLogoView];
}
@end
