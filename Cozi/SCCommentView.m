//
//  SCCommentView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/2/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCCommentView.h"

@implementation SCCommentView

- (void) drawRect:(CGRect)rect{
    // Drawing code
    [self.layer setBackgroundColor:[UIColor redColor].CGColor];
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(20, 0)];
    [p setLineWidth:0.0f];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds) + 20, CGRectGetMinY(self.bounds))];
    [p stroke];
    
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}
@end
