//
//  SCMessageImageView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/19/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMessageImageView.h"

@implementation SCMessageImageView

@synthesize img;
@synthesize imgView;

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
        [self initVariable];
    }
    
    return self;
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
    
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.imgView setClipsToBounds:YES];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgView setAutoresizingMask:UIViewAutoresizingNone];
    
    [self addSubview:self.imgView];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawLeft:(CGRect)rect {
// Drawing code
    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 20)];
    [p setLineWidth:1.0f];
    [p addLineToPoint:CGPointMake(5, 15)];
    [p addLineToPoint:CGPointMake(5, 0)];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds) + 5, CGRectGetMaxY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds) + 5, 25)];
    [p stroke];
    
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRight:(CGRect)rect {
    // Drawing code
    [self.layer setBackgroundColor:[UIColor lightGrayColor].CGColor];
    CAShapeLayer *cusLayer=[CAShapeLayer layer];
    UIBezierPath *p=[UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 0)];
    [p setLineWidth:1.0f];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - 5, CGRectGetMinY(self.bounds))];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - 5, 15)];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 20)];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - 5, 25)];
    [p addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - 5, CGRectGetMaxY(self.bounds)
                                  )];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds)
                                  )];
    [p addLineToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds)
                                  )];
    
    [p stroke];
    
    cusLayer.path=p.CGPath;
    self.layer.mask=cusLayer;
}

//- (void) setImage:(UIImage*)_imgMessenger{
//    
////    [imgView setHidden:NO];
//    
////    self.img = _imgMessenger;
//    [imgView setImage:_imgMessenger];
//    
//    
//}

- (void) removeImage{
    self.img = nil;
    imgView.image = nil;
}

- (void) setDefault{
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [imgView setHidden:YES];
}

- (UIImage*)getBlurImage{
    return imgView.image;
}

- (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path {
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0);
    [path addClip];
    [originalImage drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}

- (void) addBlurView{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    [view setBackgroundColor:[UIColor clearColor]];
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 1.0;

    [self addSubview:view];
}

@end
