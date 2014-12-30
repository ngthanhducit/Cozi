//
//  PartialTransparentView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "PartialTransparentView.h"

@implementation PartialTransparentView

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects imageBackground:(UIImageView*) image
{
    backgroundColor = color;
    rectsArray = rects;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
    }
    
    UIView *backGround=[[UIView alloc] initWithFrame:frame];
    backGround.backgroundColor=[UIColor redColor];
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [backgroundColor setFill];
    UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, rect);
    
    CGRect holeRectIntersection = CGRectIntersection(CGRectMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2), self.bounds.size.width, self.bounds.size.width), rect );
    
    CGRect backGround = CGRectIntersection(CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height), rect );
    [[UIColor blackColor] setFill];
    CGContextFillRect(context,backGround);
    
    CGRect layer1=CGRectMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2),self.bounds.size.width,self.bounds.size.width);
    CGRect holeRectIntersection1 = CGRectIntersection( layer1, rect );
    [[UIColor colorWithRed:(160/255) green:(97/255) blue:(5/255) alpha:0.5] setFill];
    UIRectFill(holeRectIntersection1);
    
    if( CGRectIntersectsRect( holeRectIntersection, rect ) )
    {
        CGContextAddEllipseInRect(context, holeRectIntersection);
        CGContextClip(context);
        CGContextClearRect(context, holeRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, holeRectIntersection);
    }
}


@end
