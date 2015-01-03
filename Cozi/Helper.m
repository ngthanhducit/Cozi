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
                    NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%ld}%@",
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
                    NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%ld}%@",
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
            NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%ld}%@",
                                    _newMessage.senderID, _newMessage.strMessage, _newMessage.typeMessage,
                                    _newMessage.statusMessage, @"" , @"",
                                    _newMessage.friendID, _newMessage.timeMessage,
                                    _newMessage.keySendMessage, [self convertNSDateToString:_newMessage.timeServerMessage]];
            
            [messageArr addObject:strMessage];
            
            [dictMessage setObject:messageArr forKey:[NSNumber numberWithInt: _friendID]];
        }else{
            NSString *strMessage = [NSString stringWithFormat:@"%i}%@}%i}%i}%@}%@}%i}%@}%ld}%@",
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
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
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
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:_strDate];
    
    return dateFromString;
}

- (NSDate*) convertStringToDate:(NSString*)_strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:_strDate];
    
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

- (NSString *) getDateFormatMessage:(NSDate *)_time{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm a"];
    NSString *strTime = [DateFormatter stringFromDate:_time];
    
    return strTime;
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
@end
