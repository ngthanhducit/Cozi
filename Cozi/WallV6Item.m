//
//  WallV6Item.m
//  VPix
//
//  Created by khoa ngo on 11/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "WallV6Item.h"

@implementation WallV6Item

@synthesize itemId;

-(void) addClickListener:(NSObject*)target selector:(SEL)selector
{
    _target=target;
    _clickSEL=selector;
    UITapGestureRecognizer *tapListener=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [tapListener setNumberOfTapsRequired:1];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapListener];
}
-(void) click{
    if(_target!=nil)
    {
        [_target performSelector:_clickSEL withObject:self];
    }
}
@end
