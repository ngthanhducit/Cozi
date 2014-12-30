//
//  TriangleView.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/31/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

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

- (void) drawTriangleSignIn{
    
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 0)];
    [p setLineWidth:0.0f];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(0, 0)];
    [p stroke];
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

- (void) drawTriangleToolKit{
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    [p setLineWidth:0.0f];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    [p stroke];
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

- (void) drawTrianDownToolkit{
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 0)];
    [p setLineWidth:0.0f];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))];
    [p stroke];
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}
@end
