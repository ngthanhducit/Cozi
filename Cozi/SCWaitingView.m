//
//  SCWaitingView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCWaitingView.h"

@implementation SCWaitingView

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
        [self initPopupProgress];
    }
    
    return self;
}

- (void) initPopupProgress{
    
    Helper      *helperIns = [Helper shareInstance];
    
    self.vProgressBlur = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.vProgressBlur setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self addSubview:self.vProgressBlur];
    
    self.vProgress = [[UIView alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height / 2) - (self.bounds.size.width / 2) / 2, self.bounds.size.width - 20, self.bounds.size.width / 2)];
    [self.vProgress setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.vProgressBlur addSubview:self.vProgress];
    
    UIActivityIndicatorView *waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waiting setFrame:CGRectMake(0, 0, self.vProgress.bounds.size.width, self.vProgress.bounds.size.height - 60)];
    [waiting startAnimating];
    [self.vProgress addSubview:waiting];
    
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, self.vProgress.bounds.size.height - 60, self.vProgress.bounds.size.width, 60)];
    [self.lblContent setText:@"LOADING..."];
    [self.lblContent setTextAlignment:NSTextAlignmentCenter];
    [self.lblContent setTextColor:[UIColor whiteColor]];
    [self.lblContent setFont:[helperIns getFontLight:18.0f]];
    [self.lblContent setLineBreakMode:0];
    [self.vProgress addSubview:self.lblContent];
}
@end
