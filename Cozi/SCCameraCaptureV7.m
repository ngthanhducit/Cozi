//
//  SCCameraCaptureV7.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/7/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCCameraCaptureV7.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@implementation SCCameraCaptureV7

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

    self.imagePreview = [[UIView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imagePreview];
    
    [self initButton];
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
                    [device setFlashMode:AVCaptureFlashModeOff];
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
            
            if ([self.backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.backCamera setFlashMode:AVCaptureFlashModeOff];
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
                
                UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationLeftMirrored];
                [imgViewImageCapture setImage: flippedImage];
                imgCaptureComplete = flippedImage;
            }else{
                [self.imagePreview setHidden:YES];

                UIImage * flippedImage = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationRight];
                [imgViewImageCapture setImage: flippedImage];
                
                imgCaptureComplete = flippedImage;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CompleteCaptureCamera" object:nil];
            inShowPhoto = YES;
        }
    }];
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


-(void)switchCamera: (BOOL) _isFrontCamera{
    isFrontCamera = !isFrontCamera;
//    isFrontCamera = _isFrontCamera;
    [self initializeCamera];
}

- (UIImage *)getImageCapture{
    return imgCaptureComplete;
}

- (void) closeImage{
    [self.imagePreview setHidden:NO];
    inShowPhoto = NO;
}

@end
