//
//  SCPhotoPreview.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPhotoPreview.h"

@implementation SCPhotoPreview

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
    
    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, width, width);
    [self drawRect:frame];
    
//    self.circleView = [[UIView alloc] initWithFrame:frame];
//    [self addSubview:self.circleView];
    
    CGRect yFrame = CGRectMake(0.0, 0, width, height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:yFrame];
    [self.scrollView setContentSize:CGSizeMake(width, height)];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
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
//    [self.imgViewCapture setContentMode:UIViewContentModeScaleAspectFill];
    
//    NSArray *transparentRects = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)], nil];
//    self.patialTransparent = [[PartialTransparentView alloc] initWithFrame:CGRectMake(0,0,width,height) backgroundColor:[UIColor blueColor] andTransparentRects:transparentRects imageBackground:self.imgViewCapture];
//    self.patialTransparent.center=self.center;
//    [self addSubview:self.patialTransparent];
//    self.patialTransparent.layer.zPosition = 1;
    
    [self addSubview:self.scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    UIImage *imgScale = self.imgViewCapture.image;
    if (imgScale.size.width > imgScale.size.height) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width , self.scrollView.contentSize.height + 1)];
    }else{
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width + 1, self.scrollView.contentSize.height)];
    }
    
    return self.imgViewCapture;
}

- (void)setImageCycle:(UIImage*) image{
    
    self.imgViewCapture.image = image;

    if (image.size.width > image.size.height) {
        //Ngang
        CGFloat scale = self.bounds.size.width / image.size.height;
        CGFloat deltaWidth = image.size.width * scale;
        
//        CGFloat delta = image.size.width - image.size.height;
//        CGFloat h = self.bounds.size.width / 2;
        
//        CGFloat deltaW = (self.bounds.size.width * image.size.height) / image.size.width;
        
//        sizeImage.width = self.bounds.size.width + (deltaW / 2);
//        sizeImage.height = self.bounds.size.width;
//        sizeImage.width = deltaWidth;
//        sizeImage.height = self.bounds.size.width;

        UIImage *imageScale = [self imageWithImage:image scaledToSize:CGSizeMake(deltaWidth, self.bounds.size.width)];
        
        NSLog(@"Image after scale width: %f - height: %f", imageScale.size.width, imageScale.size.height);
        [self.imgViewCapture setImage:imageScale];
        [self.imgViewCapture setFrame:CGRectMake(0, 0, imageScale.size.width, imageScale.size.height)];
        [self.scrollView setContentSize:CGSizeMake(imageScale.size.width , imageScale.size.height + 1)];
        [self.scrollView setContentOffset:CGPointMake((imageScale.size.width - self.bounds.size.width) / 2, (self.bounds.size.width / 2)-(self.bounds.size.width/2))];
        
//        [self.imgViewCapture setFrame:CGRectMake(0, 0, sizeImage.width, sizeImage.height)];
//        [self.scrollView setContentSize:CGSizeMake(sizeImage.width , sizeImage.height + 2)];
//        [self.scrollView setContentOffset:CGPointMake((sizeImage.width - self.bounds.size.width) / 2, (self.bounds.size.width / 2)-(self.bounds.size.width/2))];
        
    }else{
        
        //height image / width image
        //h / 640
//        CGFloat delta = image.size.height - image.size.width;
//        CGFloat h = [self calculationHeight:image resizeSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width)];
//        
//        CGFloat deltaH = (self.bounds.size.width * image.size.width) / image.size.height;
//        //Dung
//        sizeImage.width = self.bounds.size.width;
//        sizeImage.height = self.bounds.size.width + (deltaH / 2);
        
        CGFloat scale = self.bounds.size.width / image.size.width;
        CGFloat deltaHeight = image.size.height * scale;
        
//        sizeImage.width = self.bounds.size.width;
//        sizeImage.height = deltaHeight;
        
        UIImage *imgScale = [self imageWithImage:image scaledToSize:CGSizeMake(self.bounds.size.width, deltaHeight)];
        
        [self.imgViewCapture setImage:imgScale];
        [self.imgViewCapture setFrame:CGRectMake(0, 0, imgScale.size.width, imgScale.size.height)];
        [self.scrollView setContentSize:CGSizeMake(imgScale.size.width + 1, imgScale.size.height)];
        [self.scrollView setContentOffset:CGPointMake(0, (self.bounds.size.width / 2)-(self.bounds.size.width/2))];;
        
    }
    
    NSLog(@"before image width: %f - height: %f", image.size.width, image.size.height);
    
    [self.scrollView addSubview:self.imgViewCapture];
    [self bringSubviewToFront:self.scrollView];
//    [self.scrollView setFrame: CGRectMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2), self.bounds.size.width, self.bounds.size.width)];
//    [self.scrollView setContentSize:CGSizeMake(image.size.width, image.size.height)];
//    [self.imgViewCapture setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
//    [self.scrollView setContentOffset:CGPointMake(0, (self.bounds.size.height / 2)-(self.bounds.size.width/2))];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGFloat)calculationHeight:(UIImage *)orginalImage resizeSize:(CGSize)size{
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
 
    return actualHeight;
}

@end
