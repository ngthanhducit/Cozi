//
//  SCRequestChat.m
//  Cozi
//
//  Created by ChjpCoj on 3/2/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCRequestChat.h"

@implementation SCRequestChat

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
        [self initUI];
    }
    
    return self;
}

- (void) initUI{
    CGFloat widthBlock = self.bounds.size.width;
    
    Helper *hp = [Helper shareInstance];
    
    vDeneyChat = [[SCLikeView alloc] initWithFrame:CGRectMake(0, 0, (self.bounds.size.width / 2) + 9, self.bounds.size.height)];
    [vDeneyChat setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"RedColor1"]]];
    [self addSubview:vDeneyChat];
    
    self.btnDeny = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDeny setFrame:vDeneyChat.bounds];
    [self.btnDeny setBackgroundColor:[UIColor clearColor]];
    [self.btnDeny setTitle:@"DENIES" forState:UIControlStateNormal];
    [self.btnDeny.titleLabel setFont:[hp getFontLight:15.0f]];
    [vDeneyChat addSubview:self.btnDeny];
    
    vAllowChat = [[SCCommentView alloc] initWithFrame:CGRectMake((widthBlock / 2) - 9, 0, (widthBlock / 2) + 9, self.bounds.size.height)];
    [vAllowChat setBackgroundColor:[hp colorWithHex:[hp getHexIntColorWithKey:@"GreenColor2"]]];
    [self addSubview:vAllowChat];
    
    self.btnAllow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnAllow setFrame:vAllowChat.bounds];
    [self.btnAllow setBackgroundColor:[UIColor clearColor]];
    [self.btnAllow setTitle:@"ALLOW" forState:UIControlStateNormal];
    [self.btnAllow.titleLabel setFont:[hp getFontLight:15.0f]];
    [vAllowChat addSubview:self.btnAllow];
}

@end
