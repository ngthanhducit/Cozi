//
//  Helper.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "Helper.h"

@implementation Helper

const NSString                  *_cKey = @"PTCSYC22";

@synthesize dictColor;

+ (id) shareInstance{
    static Helper   *shareIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns = [[Helper alloc] init];
    });
    
    return shareIns;
}

- (id) init{
    self = [super init];
    if (self) {
        [self initVariable];
    }
    
    return self;
}

- (void) initVariable{
    self.dictColor = [[NSDictionary alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    self.dictColor = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
}

- (int) getHexIntColorWithKey:(NSString *)key{
    NSString *bgColor = [self.dictColor valueForKey:key];
    NSScanner *scanner = [NSScanner scannerWithString:bgColor];
    unsigned int temp;
    [scanner scanHexInt:&temp];
    
    return temp;
}

- (NSString*) encoded:(NSString*)data{
    const char *cKey = [_cKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *signature = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return signature;
}

- (NSString*) encoded:(NSString*)data withKey:(NSString*)_key{
    NSString *newKey = [NSString stringWithFormat:@"%@%@", _cKey, _key];
    const char *cKey = [newKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *signature = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return signature;
}

- (NSString*) decode:(NSString *)data{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

- (NSString*)encodedBase64:(NSData*)data{
    return [Base64 encode:data];
}

- (NSData *) decodeBase64:(NSString *)data{
    return [Base64 decode:data];
}

- (NSData*)stringToNSData:(NSString *)data{
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

- (UIColor *) colorWithHex:(int)hex{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

- (UIColor *) colorFromRGBWithAlpha:(int)hex withAlpha:(float)_alpha{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:_alpha];
}

- (BOOL) endOfWith:(NSString *)data withKey:(NSString *)key{
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF endswith %@", key];
    BOOL result = [_predicate evaluateWithObject:data];
    return result;
}

- (int) indexof:(NSString*)value withKey:(NSString*)key{
    return (int)[value rangeOfString:key].location;
}

- (BOOL) validateEmail:(NSString *)_email{
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    NSPredicate *emailValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //
    //    return [emailValidate evaluateWithObject:emailRegex];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValid = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailValid evaluateWithObject:_email];
}

- (int) saveUser:(NSString *)str{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dataDict setObject:str forKey:@"userInfo"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *_filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"saveUser"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:_filePath];
    
    return 0;
}

- (NSString*) loaduser{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *_filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"saveUser"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:_filePath];
        NSDictionary *unArchiver = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([unArchiver objectForKey:@"userInfo"] != nil) {
            NSString *result = [[unArchiver objectForKey:@"userInfo"] description];
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (int) saveFriends:(NSString *)str{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dataDict setObject:str forKey:@"friends"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *_filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"saveFriends"];
    
    BOOL _isComplete = [NSKeyedArchiver archiveRootObject:dataDict toFile:_filePath];
    
    if (_isComplete) {
        return 0;
    }
    
    return 0;
}

- (NSString*) loadFriends{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *_filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"saveFriends"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:_filePath];
        NSDictionary *unArchiver = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([unArchiver objectForKey:@"friends"] != nil) {
            NSString *result = [[unArchiver objectForKey:@"friends"] description];
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (UIImage*) imageWithView:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
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

-(UIImage*) cropImage:(UIImage *)image withFrame:(CGRect)_frameImage { //process captured image, crop, resize and rotate
    
    _frameImage = CGRectMake(_frameImage.origin.x*image.scale,
                      _frameImage.origin.y*image.scale,
                      _frameImage.size.width*image.scale,
                      _frameImage.size.height*image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], _frameImage);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:image.scale
                                    orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)_img withSize:(CGSize)targetSize;
{
    NSLog(@"size image width: %f - height: %f", _img.size.width, _img.size.height);
    
    UIImage *sourceImage = _img;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    if ([[UIScreen mainScreen] bounds].size.height >= 568){
        thumbnailRect.origin.y = -40;
    }else{
        thumbnailRect.origin.y = thumbnailRect.origin.y / 2;
    }

    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

//- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)_img withSize:(CGSize)targetSize
//{
//    UIImage *sourceImage = _img;
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
//    
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
//    {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//        
//        if (widthFactor > heightFactor)
//        {
//            scaleFactor = widthFactor; // scale to fit height
//        }
//        else
//        {
//            scaleFactor = heightFactor; // scale to fit width
//        }
//        
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//        
//        // center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = ((targetHeight - scaledHeight) * 0.5) / 2;
////            thumbnailPoint.y = 0;
//        }
//        else
//        {
//            if (widthFactor < heightFactor)
//            {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//            }
//        }
//    }
//    
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    
//    CGRect thumbnailRect = CGRectZero;
//    if ([[UIScreen mainScreen] bounds].size.height == 568)
//    {
//        //iphone 5
//        thumbnailRect.origin = CGPointMake(0, 0);
////        thumbnailRect.size = targetSize;
////        thumbnailRect.origin = thumbnailPoint;
//        thumbnailRect.size.width  = scaledWidth;
//        thumbnailRect.size.height = scaledHeight;
//    }
//    else
//    {
//        thumbnailRect.origin = CGPointMake(0, 0);
//        thumbnailRect.size = targetSize;
//        thumbnailRect.origin = thumbnailPoint;
//        thumbnailRect.size.width  = scaledWidth;
//        thumbnailRect.size.height = scaledHeight;
//
//    }
//    
//    [sourceImage drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    if(newImage == nil)
//    {
//        NSLog(@"could not scale image");
//    }
//    
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

- (NSData *) compressionImage:(UIImage *)img{
    CGFloat compression = 0.7f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(img, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(img, compression);
    }
    
    return imageData;
}

- (void) cacheMessage:(int)_friendID withMessage:(Messenger *)_newMessage{
    NSUserDefaults *_defaultUser = [NSUserDefaults standardUserDefaults];
    NSData *nsDataMessage = [_defaultUser objectForKey:[NSString stringWithFormat:@"%i", _friendID]];
    if (nsDataMessage != nil) {
        NSMutableDictionary *dicMessage = [NSKeyedUnarchiver unarchiveObjectWithData:nsDataMessage];
        
        if (dicMessage != nil) {
            
            if (_newMessage.typeMessage == 0) {
                for(id key in dicMessage) {
                    NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%@%@",
                                            _newMessage.senderID, _newMessage.strMessage, _newMessage.typeMessage,
                                            _newMessage.statusMessage, @"" , @"",
                                            _newMessage.friendID, _newMessage.timeMessage,
                                            _newMessage.keySendMessage, [self convertNSDateToString:_newMessage.timeServerMessage]];
                    
                    [((NSMutableArray*)[dicMessage objectForKey:key]) addObject:strMessage];
                }
                
                NSData *dataMessage = [NSKeyedArchiver archivedDataWithRootObject:dicMessage];
                [_defaultUser setObject:dataMessage forKey:[NSString stringWithFormat:@"%i", _friendID]];
                
                [_defaultUser synchronize];
            }else{
                for(id key in dicMessage) {
                    NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%@}%@",
                                            _newMessage.senderID, @"", _newMessage.typeMessage,
                                            _newMessage.statusMessage, [self encodedBase64:_newMessage.dataImage], @"",
                                            _newMessage.friendID, _newMessage.timeMessage,
                                            _newMessage.keySendMessage, [self convertNSDateToString:_newMessage.timeServerMessage]];
                    
                    [((NSMutableArray*)[dicMessage objectForKey:key]) addObject:strMessage];
                }
                
                NSData *dataMessage = [NSKeyedArchiver archivedDataWithRootObject:dicMessage];
                [_defaultUser setObject:dataMessage forKey:[NSString stringWithFormat:@"%i", _friendID]];
                
                [_defaultUser synchronize];
            }
        }
    }else{
        NSMutableDictionary *dictMessage = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *messageArr = [[NSMutableArray alloc] init];
        
        if (_newMessage.typeMessage == 0) {
            NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%@}%@",
                                    _newMessage.senderID, _newMessage.strMessage, _newMessage.typeMessage,
                                    _newMessage.statusMessage, @"" , @"",
                                    _newMessage.friendID, _newMessage.timeMessage,
                                    _newMessage.keySendMessage, [self convertNSDateToString:_newMessage.timeServerMessage]];
            
            [messageArr addObject:strMessage];
            
            [dictMessage setObject:messageArr forKey:[NSNumber numberWithInt: _friendID]];
        }else{
            NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%@}%@",
                                    _newMessage.senderID, @"", _newMessage.typeMessage,
                                    _newMessage.statusMessage, [self encodedBase64:_newMessage.dataImage] , @"",
                                    _newMessage.friendID, _newMessage.timeMessage,
                                    _newMessage.keySendMessage, [self convertNSDateToString:_newMessage.timeServerMessage]];
            
            [messageArr addObject:strMessage];
            
            [dictMessage setObject:messageArr forKey:[NSNumber numberWithInt: _friendID]];
        }
        
        NSData *dataMessage = [NSKeyedArchiver archivedDataWithRootObject:dictMessage];
        [_defaultUser setObject:dataMessage forKey:[NSString stringWithFormat:@"%i", _friendID]];
    }
}

- (UIFont *) getFontLight:(CGFloat)size{
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}

- (UIFont *) getFontMedium:(CGFloat)size{
    return [UIFont fontWithName:@"Roboto-Medium" size:size];
}

- (UIFont *) getFontThin:(CGFloat)size{
    return [UIFont fontWithName:@"Roboto-Thin" size:size];
}

- (UIFont *) getFontRegular:(CGFloat)size{
    return [UIFont fontWithName:@"Roboto-Regular" size:size];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){.size = size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithColor:(UIColor *)color{
    
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path {
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0);
    [path addClip];
    [originalImage drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}

- (NSString*) convertNSDateToString:(NSDate*)_date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringDate = [dateFormatter stringFromDate:_date];
    
    return stringDate;
}

- (NSString*) convertNSDateToString:(NSDate*)_date withFormat:(NSString*)_strFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_strFormat];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringDate = [dateFormatter stringFromDate:_date];
    
    return stringDate;
}

- (NSDate*) convertNSStringToDate:(NSString*)_strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [dateFormatter dateFromString:_strDate];
    
    return dateFromString;
}

- (NSDate*) convertStringToDate:(NSString*)_strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [dateFormatter dateFromString:_strDate];
    
    return dateFromString;
}

- (NSDate*) convertNSStringToDate:(NSString*)_strDate withFormat:(NSString*)_strFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_strFormat];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [dateFormatter dateFromString:_strDate];
    
    return dateFromString;
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    CGFloat reductionFactor = 1;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *) getImageFromSVGName:(NSString*)svgName{
    return [SVGKImage imageNamed:svgName].UIImage;
}

- (UIImage *) getImageSVGContentFile:(NSString*)svgName{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:svgName ofType:@"svg"];
    if (bundlePath) {
        return [SVGKImage imageWithContentsOfFile:bundlePath].UIImage;
    }
    
    return nil;
}

- (NSString *) getDateFormatMessage:(NSDate *)_time{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [DateFormatter setDateFormat:@"hh:mm a"];
    NSString *strTime = [DateFormatter stringFromDate:_time];
    
    return strTime;
}

- (NSDate*) convertNSDateWithFormat:(NSDate*)_date{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [DateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    
    NSString *strTime = [self convertNSDateToString:_date];
    NSDate *time = [DateFormatter dateFromString:strTime];
    
    return time;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (BOOL) checkConnected{
    NetworkStatus       internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable:
            return NO;
            break;
            
        case ReachableViaWiFi:
            return YES;
            break;
            
        case ReachableViaWWAN:
            return YES;
            break;
            
        default:
            break;
    }
}

- (UIImage *)blurWithImageEffectsRestore:(UIImage *)image withRadius:(CGFloat)_radius{
    
    return [image applyBlurWithRadius:_radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    
}

- (UIImage *)scaleUIImage:(UIImage *)_img scaledToSize:(CGSize)newSize{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL) saveImageToDocument:(UIImage*)_img withName:(NSString *)_name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:_name];
    
    // Save image.
    return [UIImagePNGRepresentation(_img) writeToFile:filePath atomically:YES];
}

#pragma mark - private function

- (int) uploadAvatarAmazon:(AmazonInfo *)info withImage:(NSData *)imgData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:info.url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"***";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // key
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // content-type
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content-type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // AWSAccessKeyId
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AWSAccessKeyId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.accessKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // acl
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"acl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"public-read" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // policy
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"policy\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.policy] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // signature
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"signature\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.signature] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"jpg"];
    //    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"ios.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
    NSHTTPURLResponse *response=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    int code = (int)[response statusCode];
    
    return code;
}
@end
