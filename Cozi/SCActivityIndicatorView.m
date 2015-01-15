//
//  SCActivityIndicatorView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCActivityIndicatorView.h"

@implementation SCActivityIndicatorView

@synthesize vLoading;
@synthesize activityView;
@synthesize lblLoading;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariable];
        [self setup];
    }
    
    return self;
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
}

- (void) setup{
    vLoading = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width / 2) - 90, (self.bounds.size.height / 2) - 90, 180, 180)];
    vLoading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    vLoading.clipsToBounds = YES;
    vLoading.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(70, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [vLoading addSubview:activityView];
    
    lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.adjustsFontSizeToFitWidth = YES;
    lblLoading.textAlignment = NSTextAlignmentCenter;
    lblLoading.text = @"Loading...";
    [lblLoading setFont:[helperIns getFontLight:16.0f]];
    [vLoading addSubview:lblLoading];
    
    [self addSubview:vLoading];
    [activityView startAnimating];
}

@end
