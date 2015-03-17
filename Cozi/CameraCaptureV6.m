//
//  CameraCaptureV6.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 11/18/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "CameraCaptureV6.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@implementation CameraCaptureV6

@synthesize frontCamera;
@synthesize backCamera;
@synthesize stillImageOutput;
@synthesize imagePreview;
@synthesize captureVideoPreviewLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeVariable];
        [self initializeUI];
        [self initializeCamera];
    }
    return self;
}

-(void)initializeVariable{
    helperIns = [Helper shareInstance];
    isFrontCamera = NO;
    isFullCameraCapture = NO;
}

-(void)initializeUI{
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
//    [pinchGesture setDelegate:self];
//    [self addGestureRecognizer:pinchGesture];
    
    self.imagePreview = [[UIView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imagePreview];
    
    [self initButton];
}

- (void) initButton{
    self.imgViewCapture      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.imgViewCapture setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgViewCapture setAutoresizingMask:UIViewAutoresizingNone];
    [self.imgViewCapture setClipsToBounds:YES];
    [self.imgViewCapture setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.imgViewCapture];
    [self sendSubviewToBack:self.imgViewCapture];
    
    imgViewImageCapture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [imgViewImageCapture setTag:10000];
    [imgViewImageCapture setContentMode:UIViewContentModeScaleAspectFill];
    [imgViewImageCapture setAutoresizingMask:UIViewAutoresizingNone];
    [imgViewImageCapture setClipsToBounds:YES];
    [imgViewImageCapture setBackgroundColor:[UIColor clearColor]];
    [self.imgViewCapture addSubview:imgViewImageCapture];
}

-(void)closeImage{
    [self.imagePreview setHidden:NO];
    inShowPhoto = NO;
}

- (UIImage *)getImageSend{
    return imgViewImageCapture.image;
}

- (BOOL) getInShowPhoto{
    return inShowPhoto;
}

-(void)initializeCamera{
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureVideoPreviewLayer setFrame:self.bounds];
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasFlash]) {
            if ([device isFlashModeSupported:AVCaptureFlashModeOn]) {
                NSError *error = NULL;
                if ([device lockForConfiguration:&error]) {
                    [device setFlashMode:AVCaptureFlashModeOn];
                }
            }
        }
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                self.backCamera = device;
            }else{
                self.frontCamera = device;
            }
        }
    }
    
    if (!isFrontCamera) {
        NSError *error = nil;
        if ([self.backCamera lockForConfiguration:NULL] == YES) {
            if ([self.backCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                CGPoint autoFocusPoint = CGPointMake(0.5f, 0.5f);
                [self.backCamera setFocusPointOfInterest:autoFocusPoint];
                [self.backCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            
            if ([self.backCamera isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [self.backCamera setFlashMode:AVCaptureFlashModeAuto];
            }
            
            if ([self.backCamera isTorchModeSupported:AVCaptureTorchModeAuto]) {
                [self.backCamera setTorchMode:AVCaptureTorchModeAuto];
            }
            
            [self.backCamera unlockForConfiguration];
        }
        
        AVCaptureDeviceInput    *input = [AVCaptureDeviceInput deviceInputWithDevice:self.backCamera error:&error];
        [self.session addInput:input];
    }
    
    if (isFrontCamera) {
        NSError *error = nil;
        if ([self.frontCamera lockForConfiguration:NULL] == YES) {
            if ([self.frontCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                CGPoint autoFocusPoint = CGPointMake(0.5f, 0.5f);
                [self.frontCamera setFocusPointOfInterest:autoFocusPoint];
                [self.frontCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            
            [self.frontCamera unlockForConfiguration];
        }
        
        AVCaptureDeviceInput    *input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCamera error:&error];
        [self.session addInput:input];
    }
    
    self.stillImageOutput  = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

- (void) resetCamera{
    
    //Remove existing input
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    [self.session removeInput:currentCameraInput];
    
    if (!isFrontCamera) {
        NSError *error = nil;
        
        AVCaptureDeviceInput    *input = [AVCaptureDeviceInput deviceInputWithDevice:self.backCamera error:&error];
        [self.session addInput:input];
    }
    
    if (isFrontCamera) {
        NSError *error = nil;

        AVCaptureDeviceInput    *input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCamera error:&error];
        [self.session addInput:input];
    }
    
}

- (void) stopStartSession{
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
    
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
}

- (void) resizeCameraPreview{

    [self.imagePreview setFrame:self.bounds];
    [self.imgViewCapture setFrame:self.bounds];
    [imgViewImageCapture setFrame:self.bounds];
    [captureVideoPreviewLayer setFrame:self.bounds];

}

- (void) resizeCameraPreview:(CGRect)_frame{
    [self.imagePreview setFrame:_frame];
    [self.imgViewCapture setFrame:_frame];
    [imgViewImageCapture setFrame:_frame];
    [captureVideoPreviewLayer setFrame:_frame];
}

-(void)enableTorch:(AVCaptureTorchMode)torchMode{
    if ([self.backCamera lockForConfiguration:NULL] == YES) {
        
        if (!isFrontCamera) {
            if ([self.backCamera isTorchAvailable]) {
                [self.backCamera setTorchMode:torchMode];
            }
        }
        
        [self.backCamera unlockForConfiguration];
    }
}

-(void)enableFlash: (AVCaptureFlashMode)flashMode{
    if ([self.backCamera lockForConfiguration:NULL] == YES) {
        
        if (!isFrontCamera) {
            if ([self.backCamera isFlashAvailable]) {
                [self.backCamera setFlashMode:flashMode];
            }
        }
        
        [self.backCamera unlockForConfiguration];
    }
}

-(void)captureImage:(UIImageView*)imgView{
    //    UIImage *result = nil;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *result = [[UIImage alloc] initWithData:imageData];
            
            if (isFrontCamera) {
                [self.imagePreview setHidden:YES];
                
                if (isFullCameraCapture) {
                UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationLeftMirrored];
                    [imgViewImageCapture setImage: flippedImage];
                }else{
                UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationLeftMirrored];
                    
                    UIImage *imgResize = [helperIns imageByScalingAndCroppingForSize:flippedImage withSize:CGSizeMake(self.bounds.size.width * [[UIScreen mainScreen] scale], self.bounds.size.height * [[UIScreen mainScreen] scale])];;
                    [imgViewImageCapture setImage: imgResize];
                }
            }else{
                [self.imagePreview setHidden:YES];
                
                if (isFullCameraCapture) {
                    UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationRight];
                    [imgViewImageCapture setImage: flippedImage];
                }else{
                    UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationRight];
                 
                    UIImage *imgResize = [helperIns imageByScalingAndCroppingForSize:flippedImage withSize:CGSizeMake(self.bounds.size.width * [[UIScreen mainScreen] scale], self.bounds.size.height * [[UIScreen mainScreen] scale])];
                    [imgViewImageCapture setImage: imgResize];
                }
            }
            
            inShowPhoto = YES;
        }
    }];
}

-(UIImage*) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    UIImageView *captureImage = [[UIImageView alloc] initWithFrame:self.bounds];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) { //Device is ipad
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(768, 1022));
        [image drawInRect: CGRectMake(0, 0, 768, 1022)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 130, 768, 768);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        //or use the UIImage wherever you like
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
        
    }else{ //Device is iphone
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, 200));
        [image drawInRect: CGRectMake(0, 0, self.bounds.size.width, 200)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 0, self.bounds.size.width, 200);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
    }
    
    //adjust image orientation based on device orientation
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(-180));
        [UIView commitAnimations];
    }
    
    return captureImage.image;
}

-(UIImage*) resizeImage:(UIImage *)image { //process captured image, crop, resize and rotate
    UIImageView *captureImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [captureImage setImage:image];
    NSLog(@"size image width: %f- height: %f", image.size.width, image.size.height);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        [image drawInRect: CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, image.size.height / 3, image.size.width, image.size.height / 4);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        //or use the UIImage wherever you like
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
        
    }else{
        
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        [image drawInRect: CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGFloat hImg = image.size.height / 3;
        CGFloat hBound = self.bounds.size.height;
        
        CGFloat ratio = hImg/hBound;
        
        CGFloat hNewImage = hBound * ratio;
        
        CGRect cropRect = CGRectMake(0, image.size.height / 3, image.size.width, hNewImage);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
    }
    
    NSLog(@"size image width: %f- height: %f", captureImage.image.size.width, captureImage.image.size.height);
    
    return captureImage.image;
}

-(void)switchCamera: (BOOL) _isFrontCamera{

    isFrontCamera = _isFrontCamera;
    [self initializeCamera];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    isZoom = YES;
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        beginGestureScale = effectiveScale;
    }
    return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.imagePreview];
        CGPoint convertedLocation = [self.captureVideoPreviewLayer convertPoint:location fromLayer:self.captureVideoPreviewLayer.superlayer];
        if ( ! [self.captureVideoPreviewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        effectiveScale = beginGestureScale * recognizer.scale;
        if (effectiveScale < 1.0)
            effectiveScale = 1.0;
        CGFloat maxScaleAndCropFactor = [[stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        if (effectiveScale > maxScaleAndCropFactor)
            effectiveScale = maxScaleAndCropFactor;
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(effectiveScale, effectiveScale)];
        [CATransaction commit];
    }
    
    isZoom = NO;
}

-(void)tapFocus:(CGPoint)point{
    if (!isZoom) {
        if (isFrontCamera) {
            if ([self.frontCamera isFocusPointOfInterestSupported]) {
                if ([self.frontCamera lockForConfiguration:NULL] == YES) {
                    
                    [self.frontCamera setFocusPointOfInterest:point];
                    [self.frontCamera setFocusMode:AVCaptureFocusModeAutoFocus];
                    
                    if ([self.frontCamera isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                        [self.frontCamera setExposureMode:AVCaptureExposureModeAutoExpose];
                    }
                    
                    [self.frontCamera unlockForConfiguration];
                }
            }
        }else{
            if ([self.backCamera isFocusPointOfInterestSupported]) {
                if ([self.backCamera lockForConfiguration:NULL] == YES) {
                    [self.backCamera setFocusPointOfInterest:point];
                    [self.backCamera setFocusMode:AVCaptureFocusModeAutoFocus];
                    
                    if ([self.backCamera isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                        [self.backCamera setExposureMode:AVCaptureExposureModeAutoExpose];
                    }
                    
                    [self.backCamera unlockForConfiguration];
                }
            }
        }
    }
}

- (void) setIsFullCameraCapture:(BOOL)_isFullCamera{
    isFullCameraCapture = _isFullCamera;
}

@end
