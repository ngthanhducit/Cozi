//
//  SCPhotoDetailsView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/7/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPhotoDetailsView.h"

@implementation SCPhotoDetailsView

- (void) drawRect:(CGRect)rect{
    // Drawing code
//    [self.layer setBackgroundColor:[UIColor redColor].CGColor];
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 0)];
    [p setLineWidth:0.0f];
    
    [p addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) - 10, CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + 10)];
    [p addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) + 10, CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
    
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))];
    
    [p stroke];
    
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

@end
