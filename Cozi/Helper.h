//
//  Helper.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Base64.h"
#import "Friend.h"
#import "Messenger.h"
#import "SVGKImage.h"
#import "Reachability.h"
#import "UIImage+ImageEffects.h"

@interface Helper : NSObject
{
        Reachability        *internetReachable;
}

@property (nonatomic, strong) NSDictionary          *dictColor;

+ (id) shareInstance;

- (NSString*) encoded:(NSString*)data;
- (NSString*) encoded:(NSString*)data withKey:(NSString*)_key;
- (NSString*) decode:(NSString*)data;
- (NSString*)encodedBase64:(NSData*)data;
- (NSData*) decodeBase64:(NSString*)data;
- (NSData*) stringToNSData:(NSString*)data;

- (UIColor *) colorWithHex:(int)hex;
- (UIColor *) colorFromRGBWithAlpha:(int)hex withAlpha:(float)_alpha;
- (BOOL) endOfWith:(NSString*)data withKey:(NSString*)key;
- (int) indexof:(NSString*)value withKey:(NSString*)key;
- (BOOL) validateEmail:(NSString*)_email;
- (int) saveUser:(NSString*)str;
- (NSString*) loaduser;
- (int) saveFriends:(NSString*)str;
- (NSString*) loadFriends;
- (UIImage*) imageWithView:(UIView*)view;
- (UIImage *) resizeImage:(UIImage*)orginalImage resizeSize:(CGSize)size;
- (NSData *) compressionImage: (UIImage*)img;

//- (void) cacheMessage:(int)friendIns withMessage:(Messenger *)_newMessage;
- (UIFont*) getFontLight:(CGFloat)size;
- (UIFont *) getFontMedium:(CGFloat)size;
- (UIFont *) getFontThin:(CGFloat)size;

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageWithColor:(UIColor *)color;
- (int) getHexIntColorWithKey:(NSString*)key;
- (NSDate*) convertNSDateWithFormat:(NSDate*)_date;
- (NSString*) convertNSDateToString:(NSDate*)_date;
- (NSString*) convertNSDateToString:(NSDate*)_date withFormat:(NSString*)_strFormat;
- (NSDate*) convertNSStringToDate:(NSString*)_strDate;
- (NSDate*) convertNSStringToDate:(NSString*)_strDate withFormat:(NSString*)_strFormat;
- (NSDate*) convertStringToDate:(NSString*)_strDate;
- (UIImage *)takeSnapshotOfView:(UIView *)view;
- (UIImage *) getImageFromSVGName:(NSString*)svgName;
- (UIImage *) getImageSVGContentFile:(NSString*)svgName;
- (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path ;
- (UIImage*) cropImage:(UIImage *)image withFrame:(CGRect)_frameImage;
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)_img withSize:(CGSize)targetSize;

- (NSString *) getDateFormatMessage:(NSDate *)_time;
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

- (BOOL) checkConnected;

- (UIImage *)blurWithImageEffectsRestore:(UIImage *)image withRadius:(CGFloat)_radius;
- (UIImage *)scaleUIImage:(UIImage *)_img scaledToSize:(CGSize)newSize;

- (BOOL) saveImageToDocument:(UIImage*)_img withName:(NSString*)_name;
@end
