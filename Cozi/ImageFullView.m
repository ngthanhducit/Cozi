//
//  ImageFullView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/9/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ImageFullView.h"

@implementation ImageFullView

@synthesize mainScroll;
@synthesize imageView;

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
        [self setup];
    }
    
    return self;
}

- (void) setup{
    [self setBackgroundColor:[UIColor blackColor]];
    
    helperIns = [Helper shareInstance];
    
    imageList = [[NSMutableArray alloc] init];
}

- (void) initWithData:(UIImage *)_img{
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 40)];
    [self.mainScroll setMinimumZoomScale:1.0];
    [self.mainScroll setMaximumZoomScale:5.0];
    [self.mainScroll setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height - 40)];
    [self.mainScroll setDelegate:self];
    
    
    self.imageView = [[UIImageView alloc] initWithImage:_img];
    if (_img.size.width > _img.size.height) {
        [self.imageView setFrame:CGRectMake(0, 0, _img.size.width / 2, self.mainScroll.bounds.size.height / 2)];
    }else{
        [self.imageView setFrame:CGRectMake(0, 0, self.mainScroll.bounds.size.width, _img.size.height / 2)];
    }

    [self.mainScroll addSubview:self.imageView];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.mainScroll.bounds),
                                      CGRectGetMidY(self.mainScroll.bounds));

    [self view:self.imageView setCenter:centerPoint];

    [self addSubview:self.mainScroll];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setTitle:@"CLOSE" forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:[helperIns getFontLight:15]];
    [btnClose setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [btnClose setFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
    
    [btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnClose addTarget:self action:@selector(closeImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnClose];
}

- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = self.mainScroll.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    self.mainScroll.contentOffset = co;
}

#pragma -mark UIScrollViewDelegate Delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return (UIView*)[imageList objectAtIndex:pageIndex];
    return self.imageView;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView{
    UIView* zoomView = [scrollView.delegate viewForZoomingInScrollView:scrollView];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < scrollView.bounds.size.width)
    {
        zvf.origin.x = (scrollView.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < scrollView.bounds.size.height)
    {
        zvf.origin.y = (scrollView.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == mainScroll) {
        pageIndex = mainScroll.contentOffset.x / self.bounds.size.width;
    }
    
}

- (void) closeImage{
    [self removeFromSuperview];
}
@end
