//
//  SCSearchBarV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCSearchBarV2.h"

@implementation SCSearchBarV2

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

- (void) layoutSubviews{
//    [self setShowsCancelButton:NO animated:NO];
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor whiteColor];
        searchField.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setBackgroundColor:[UIColor clearColor]];
        [searchField setRightView:nil];
        [searchField setBackground:nil];
        
        searchField.leftView  = nil;
        
    }else{
        
        searchField = [self valueForKey:@"_searchField"];
        [self bringSubviewToFront:searchField];
        
        searchField.textColor = [UIColor blackColor];
        searchField.font = [[Helper shareInstance] getFontLight:12.0f];
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [searchField setBorderStyle:UITextBorderStyleNone];
//        [searchField setBackgroundColor:[UIColor clearColor]];
//        [searchField setRightView:nil];
//        [searchField setBackground:nil];
        
        UIImage *img = [[Helper shareInstance] getImageFromSVGName:@"icon-LocationBlue.svg"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        
        [imgView setFrame:CGRectMake(0, 0, searchField.leftView.bounds.size.width, searchField.leftView.bounds.size.height)];
        searchField.leftView  = imgView;
        
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setBarTintColor:[UIColor whiteColor]];
    
    [super layoutSubviews];
}

@end
