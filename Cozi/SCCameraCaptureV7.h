//
//  SCCameraCaptureV7.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/7/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Helper.h"

@interface SCCameraCaptureV7 : UIView <UIGestureRecognizerDelegate>
{
    BOOL                        isFrontCamera;
    BOOL                        isZoom;
    CGFloat beginGestureScale;
    CGFloat effectiveScale;
    UIButton            *btnCloseImage;
    UIImageView         *imgViewImageCapture;
    BOOL                isFullCameraCapture;
    Helper              *helperIns;
    BOOL                inShowPhoto;
    UIImage             *imgCaptureComplete;
}

@property (nonatomic, retain) AVCaptureDevice            *backCamera;
@property (nonatomic, retain) AVCaptureDevice            *frontCamera;
@property (nonatomic, retain) AVCaptureSession           *session;

@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) AVCaptureStillImageOutput  *stillImageOutput;
@property (nonatomic, retain) UIView                     *imagePreview;
@property (nonatomic, retain) UIView                   *imgViewCapture;

- (void)enableTorch:(AVCaptureTorchMode)torchMode;
- (void)enableFlash: (AVCaptureFlashMode)flashMode;
- (void)switchCamera: (BOOL) _isFrontCamera;
- (void)captureImage : (UIImageView*)imgView;
- (void)tapFocus: (CGPoint)point;
//- (void) resizeCameraPreview;
//- (void) setIsFullCameraCapture:(BOOL)_isFullCamera;
//- (void)handlePinchGesture:(UIGestureRecognizer *)recognizer;
//- (BOOL) getInShowPhoto;
- (void) closeImage;
- (UIImage *)getImageCapture;
- (void) resetCamera;
@end
