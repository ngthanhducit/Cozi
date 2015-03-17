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
    vLoading = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.bounds.size.width, self.bounds.size.height)];
    vLoading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake((vLoading.frame.origin.x / 2) - (activityView.bounds.size.width / 2), 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [vLoading addSubview:activityView];
    
    lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor whiteColor];
    
    lblLoading.adjustsFontSizeToFitWidth = YES;
    lblLoading.textAlignment = NSTextAlignmentCenter;
    lblLoading.text = @"Loading...";
    [lblLoading setFont:[helperIns getFontItalic:15.0f]];
    [vLoading addSubview:lblLoading];
    
    [self addSubview:vLoading];
    [activityView startAnimating];
}

- (void) setText:(NSString*)_strText{
    [lblLoading setText:_strText];
    
    CGSize sizeScreen = { self.bounds.size.width - (activityView.bounds.size.width + 20), 30 };
    CGSize sizeText = [_strText sizeWithFont:[helperIns getFontItalic:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByCharWrapping];
    sizeText.width += 10;
    
    [activityView setFrame:CGRectMake((self.bounds.size.width / 2) - (sizeText.width + activityView.bounds.size.width) / 2, (self.bounds.size.height / 2) - 15, activityView.bounds.size.width, 30)];
                                     
    [lblLoading setFrame:CGRectMake(activityView.frame.origin.x + activityView.bounds.size.width + 10, activityView.frame.origin.y, sizeText.width - 10, 30)];
}

@end
