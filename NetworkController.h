//
//  NetworkController.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cozi/DataWall.h"
#import "Cozi/Helper.h"
#import "Cozi/NetworkCommunication.h"

@interface NetworkController : NSObject
{
    Helper          *helperIns;
    NetworkCommunication *networkIns;
}

+ (id) shareInstance;

- (void) getUploadPostUrl;
- (void) resultUploadImagePost:(int)code withCodeThumb:(int)codeThumb;
- (void) addPost:(NSString*)_content withImage:(NSString*)_image withVideo:(NSString*)_video withLocation:(NSString*)_location withClientKey:(NSString*)clientKey;
- (void) getWall:(int)_countPost withClientKeyStart:(NSString*)_startClientKey;
- (void) getWallByUser:(int)_countPost withClientKeyStart:(NSString*)_startClientKey withUserID:(int)_userID;
- (void) getNoise:(int)_countPost withClientKeyStart:(NSString*)_startClientKey;

//LIKE
- (void) addPostLike:(DataWall*)_wall;

@end
