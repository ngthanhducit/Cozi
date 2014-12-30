//
//  SCScrollJoinNow.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCScrollJoinNow.h"

@implementation SCScrollJoinNow

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
        
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
