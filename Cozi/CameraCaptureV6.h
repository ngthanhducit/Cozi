//
//  CameraCaptureV6.h
//  VPix
//
//  Created by Nguyen Thanh Duc on 11/18/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Helper.h"

@interface CameraCaptureV6 : UIView <UIGestureRecognizerDelegate>
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
}

@property (nonatomic, retain) AVCaptureDevice            *backCamera;
@property (nonatomic, retain) AVCaptureDevice            *frontCamera;
@property (nonatomic, retain) AVCaptureSession           *session;

@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) AVCaptureStillImageOutput  *stillImageOutput;
@property (nonatomic, retain) UIView                     *imagePreview;
@property (nonatomic, retain) UIView                   *imgViewCapture;

-(void)enableTorch:(AVCaptureTorchMode)torchMode;
-(void)enableFlash: (AVCaptureFlashMode)flashMode;
-(void)switchCamera: (BOOL) _isFrontCamera;
-(void)captureImage : (UIImageView*)imgView;
-(void)tapFocus: (CGPoint)point;
- (void) resizeCameraPreview;
- (void) resizeCameraPreview:(CGRect)_frame;
- (void) setIsFullCameraCapture:(BOOL)_isFullCamera;
- (void)handlePinchGesture:(UIGestureRecognizer *)recognizer;
- (BOOL) getInShowPhoto;
- (void) closeImage;
- (UIImage *)getImageSend;
- (void) resetCamera;
- (void) stopStartSession;
@end
