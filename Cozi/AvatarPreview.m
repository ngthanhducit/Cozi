//
//  AvatarPreview.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "AvatarPreview.h"
#import "JoinNowPageView.h"

@implementation AvatarPreview

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
    Helper *helperIns = [Helper shareInstance];
    
    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, width, width);
    [self drawRect:frame];
    self.circleView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:self.circleView];
    
    CGRect yFrame = CGRectMake(0.0, 0, width, height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:yFrame];
    [self.scrollView setContentSize:CGSizeMake(width, height)];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
    self.scrollView.delegate = self;
    [self.scrollView setClipsToBounds:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.scrollView setScrollEnabled:YES];
//    [self.scrollView setBounces:NO];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.scrollView];
    
    self.imgViewCapture = [[UIImageView alloc] initWithFrame:yFrame];
    [self.imgViewCapture setContentMode:UIViewContentModeCenter];
    
    NSArray *transparentRects = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)], nil];
    self.patialTransparent = [[PartialTransparentView alloc] initWithFrame:CGRectMake(0,0,width,height) backgroundColor:[UIColor blueColor] andTransparentRects:transparentRects imageBackground:self.imgViewCapture];
    self.patialTransparent.center=self.center;
    [self addSubview:self.patialTransparent];
    self.patialTransparent.layer.zPosition = 1;
    
    [self addSubview:self.scrollView];
    
    lblFinish = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 4, self.bounds.size.height - 80, self.bounds.size.width / 2, 60)];
    [lblFinish setText:@"FINISH"];
    [lblFinish setFont:[helperIns getFontThin:13.0f]];
    [lblFinish setTextAlignment:NSTextAlignmentCenter];
    [lblFinish setTextColor:[UIColor whiteColor]];
    [lblFinish setUserInteractionEnabled:YES];
    lblFinish.layer.zPosition = 2;
    [self addSubview:lblFinish];
    
    UITapGestureRecognizer *tapFinish = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFinishAvatar:)];
    [tapFinish setNumberOfTapsRequired:1];
    [tapFinish setNumberOfTouchesRequired:1];
    [lblFinish addGestureRecognizer:tapFinish];
    
    lblCancel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblCancel setText:@"CANCEL"];
    [lblCancel setFont:[helperIns getFontThin:13.0f]];
    [lblCancel setTextAlignment:NSTextAlignmentCenter];
    [lblCancel setTextColor:[UIColor whiteColor]];
    [lblCancel setUserInteractionEnabled:YES];
    lblCancel.layer.zPosition = 2;
    [self addSubview:lblCancel];
    
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelAvatar:)];
    [tapCancel setNumberOfTapsRequired:1];
    [tapCancel setNumberOfTouchesRequired:1];
    [lblCancel addGestureRecognizer:tapCancel];
}

- (void)setImageCycle:(UIImageView*) image{

    self.imgViewCapture = image;
    [self.imgViewCapture setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.scrollView addSubview:self.imgViewCapture];
    [self bringSubviewToFront:self.scrollView];
    [self.scrollView setFrame: CGRectMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2), self.bounds.size.width, self.bounds.size.width)];
    [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    [self.scrollView setContentOffset:CGPointMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2))];

    [self bringSubviewToFront:lblFinish];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgViewCapture;
}

- (void) tapCancelAvatar:(UIGestureRecognizer *)recognizer{
    
    [self removeFromSuperview];
    
}

- (void) tapFinishAvatar:(UIGestureRecognizer *)recognizer{
    
    //Calculate the required area from the scrollview
    CGRect visibleRect;
    float scale = (1.0f / self.scrollView.zoomScale) * [[UIScreen mainScreen] scale];
    visibleRect.origin.x = self.scrollView.contentOffset.x * scale;
    visibleRect.origin.y = self.scrollView.contentOffset.y * scale;
    visibleRect.size.width = (self.scrollView.bounds.size.width) * scale;
    visibleRect.size.height = (self.scrollView.bounds.size.height) * scale;
    
    UIImage *afterImage = [self imageFromView:self.imgViewCapture.image withRect:visibleRect];
    UIImage *imgResize = [self resizeImage:afterImage resizeSize:CGSizeMake(160, 160)];
    
    NSLog(@"size image: width %f - height: %f", afterImage.size.width, afterImage.size.height);
    
    JoinNowPageView *supperView = (JoinNowPageView*)[self superview];
    
    [supperView setAvatar:afterImage withThumbnail:imgResize];
    [self removeFromSuperview];
}

- (UIImage *)imageFromView:(UIImage *)_img withRect:(CGRect)_rect{
    CGImageRef cr = CGImageCreateWithImageInRect(_img.CGImage, _rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}

- (UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size{
    CGFloat actualHeight = orginalImage.size.height;
    CGFloat actualWidth = orginalImage.size.width;
    
    float oldRatio = actualWidth/actualHeight;
    float newRatio = size.width/size.height;
    
    if(oldRatio < newRatio)
    {
        oldRatio = size.height/actualHeight;
        actualWidth = oldRatio * actualWidth;
        actualHeight = size.height;
    }
    else
    {
        oldRatio = size.width/actualWidth;
        actualHeight = oldRatio * actualHeight;
        actualWidth = size.width;
    }
    
    CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [orginalImage drawInRect:rect];
    orginalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return orginalImage;
}
@end
