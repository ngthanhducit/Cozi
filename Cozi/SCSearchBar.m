//
//  SCSearchBar.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/19/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCSearchBar.h"

@implementation SCSearchBar

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void) layoutSubviews{
    [self setShowsCancelButton:NO animated:NO];
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
        
        searchField.textColor = [UIColor whiteColor];
        searchField.font = [UIFont fontWithName:@"Roboto-Light" size:13.0f];
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setBackgroundColor:[UIColor clearColor]];
        [searchField setRightView:nil];
        [searchField setBackground:nil];
        
        searchField.leftView  = nil;
    }
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self setBarTintColor:[UIColor blackColor]];

    [super layoutSubviews];
}

@end
