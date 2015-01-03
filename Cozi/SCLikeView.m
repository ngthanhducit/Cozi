//
//  SCLikeView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/2/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLikeView.h"

@implementation SCLikeView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.layer setBackgroundColor:[UIColor redColor].CGColor];
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    CGFloat h = rect.size.height;
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p setLineWidth:0.0f];
    [p moveToPoint:CGPointMake(0, 0)];
    [p addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [p addLineToPoint:CGPointMake(self.frame.size.width - 20, h)];
    [p addLineToPoint:CGPointMake(0, h)];
    [p addLineToPoint:CGPointMake(0, 0)];
    [p stroke];
    
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

@end
