//
//  ImageRender.m
//  VPix
//
//  Created by khoa ngo on 10/30/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "ImageRender.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0f * M_PI)
@implementation ImageRender


-(NSData*) applySaturationWithData:(NSData*)data saturation:(float) sur;
{

    return data;
}

- (UIImage*)colorize:(UIImage *)input saturation:(CGFloat)saturation
{

    
    //NSLog(@"saturation: %0.2f", saturation);
    
    CIImage *inputImage = [CIImage imageWithCGImage:input.CGImage];
    
    //---
    CIFilter *saturationFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, inputImage, nil];
    [saturationFilter setDefaults];
    [saturationFilter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
    //---
    
    CIImage *outputImage = [saturationFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return outputUIImage;
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageBlackAndWhite:(UIImage*)source
{
    CIImage *beginImage = [CIImage imageWithCGImage:source.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}

- (UIImage*)colorize:(UIImage *)input hue:(CGFloat)hueDegrees
{

    
    CGFloat hue = DEGREES_TO_RADIANS(hueDegrees);
    
    CIImage *inputImage = [CIImage imageWithCGImage:input.CGImage];
    
    //---
    CIFilter *hueFilter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, inputImage, nil];
    [hueFilter setDefaults];
    [hueFilter setValue:[NSNumber numberWithFloat:hue] forKey:kCIInputAngleKey];
    //---
    
    CIImage *outputImage = [hueFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return outputUIImage;
}
- (UIImage*)colorize:(UIImage *)input brightness:(CGFloat)brightness
{
    
    CIImage *inputImage = [CIImage imageWithCGImage:input.CGImage];
    
    //---
    CIFilter *brightnessFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, inputImage, nil];
    [brightnessFilter setDefaults];
    [brightnessFilter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    //---
    
    CIImage *outputImage = [brightnessFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *outputUIImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return outputUIImage;
}
-(UIImage*) cutImageByRect:(UIImage*)input frame:(CGRect)frame
{
    CGFloat iW = input.size.width;
    CGFloat iH = input.size.height;
    CGFloat t;
    CGFloat nH=frame.size.width*iH/iW;
    if(iW>iH)
    {
        t=0;
    }
    else
    {
        t=-1*nH/5;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, frame.size.width, 0);
    CGContextAddLineToPoint(context, frame.size.width, frame.size.height);
    CGContextAddLineToPoint(context, 0, frame.size.height);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGRect rect=CGRectMake(0, t, frame.size.width   , nH);
    [input drawInRect:rect];
    UIImage *outImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  outImg;
}
-(UIImage*) makeHomeTopImage:(UIImage*)input frame:(CGRect)frame
{
    UIImage* fImg=[self cutImageByRect:input frame:frame];
    fImg=[self colorize:fImg saturation:0.0f];
    fImg=[self markRect:fImg];
    fImg=[self cutShape:fImg type:1];
    return fImg;
}

-(UIImage*) markRect:(UIImage*)input
{
    CGFloat iW = input.size.width;
    CGFloat iH = input.size.height;
    CGRect frame=CGRectMake(0, 0, iW, iH);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);

    [input drawAtPoint:CGPointZero];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);

    
    for(int x=0;x<=iW;x+=6)
    {
        for(int y=0;y<=iH;y+=6)
        {

            CGContextFillRect(context,  CGRectMake(x, y, 3, 3));
        }
    }

    UIImage *outImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImg;
}

-(UIImage*) cutShape:(UIImage*)input type:(int)type
{
    CGFloat iW = input.size.width;
    CGFloat iH = input.size.height;
    CGFloat div=iH/3;
    CGRect frame=CGRectMake(0, 0, iW, iH);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    if(type==0)
    {
        //cut Parallelogram
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, iW, div);
        CGContextAddLineToPoint(context, iW, iH);
        CGContextAddLineToPoint(context, 0, iH-div);
    }
    else
    {
        //cut Trapezoidal
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, iW, 0);
        CGContextAddLineToPoint(context, iW, iH);
        CGContextAddLineToPoint(context, 0, iH-div);
    }
    CGContextClosePath(context);
    CGContextClip(context);
    [input drawAtPoint:CGPointZero];
    UIImage *outImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImg;
}
@end
