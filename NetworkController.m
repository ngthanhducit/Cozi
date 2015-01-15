//
//  NetworkController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/5/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+ (id) shareInstance{
    static NetworkController   *shareIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns = [[NetworkController alloc] init];
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
    helperIns = [Helper shareInstance];
    networkIns = [NetworkCommunication shareInstance];
}

- (void) getUploadPostUrl{
    NSString *cmd = @"GETUPLOADPOSTURL{<EOF>";
    [networkIns sendData:cmd];
}

- (void) resultUploadImagePost:(int)code withCodeThumb:(int)codeThumb{
    NSString *cmd = [NSString stringWithFormat:@"RESULTUPLOADPOSTIMAGE{%i}%i<EOF>", codeThumb, code];
    [networkIns sendData:cmd];
}

- (void) addPost:(NSString*)_content withImage:(NSString*)_image withVideo:(NSString*)_video withLocation:(NSString*)_location withClientKey:(NSString*)clientKey{
    NSString *cmd = [NSString stringWithFormat:@"ADDPOST{%@}%@}%@}%@}%@<EOF>", _content, _image, _video, _location, clientKey];
    [networkIns sendData:cmd];
}

- (void) getWall:(int)_countPost withClientKeyStart:(NSString *)_startClientKey{
    //Get wall
    NSString *_encodeClientKey = [helperIns encodedBase64:[_startClientKey dataUsingEncoding:NSUTF8StringEncoding]];
    
    [networkIns sendData:[NSString stringWithFormat:@"GETWALL{%i}%@<EOF>", 10, _encodeClientKey]];
}

- (void) getWallByUser:(int)_countPost withClientKeyStart:(NSString *)_startClientKey withUserID:(int)_userID{
    
}

- (void) getNoise:(int)_countPost withClientKeyStart:(NSString *)_startClientKey{
    
}

- (void) addPostLike:(DataWall *)_wall{
    NSString *_decodeClientKey = [helperIns encodedBase64:[_wall.clientKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *_cmdAddLike = [NSString stringWithFormat:@"ADDPOSTLIKE{%@}%i<EOF>", _decodeClientKey, _wall.userPostID];
    [networkIns sendData:_cmdAddLike];
}

@end
