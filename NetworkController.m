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

- (void) addListener:(id)instance{

    [instances addObject:instance];
    
}

- (void) removeListener:(id)instance{
    [instances removeObject:instance];
}

- (void) initVariable{
    instances = [NSMutableArray new];
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

- (void) addPost:(NSString*)_content withImage:(NSString*)_image withImageThumb:(NSString*)_imageThumb withVideo:(NSString*)_video withLocation:(NSString*)_location withClientKey:(NSString*)clientKey withCode:(int)code{
    NSString *cmd = [NSString stringWithFormat:@"ADDPOST{%@}%@}%@}%@}%@}%i<EOF>", _content, [NSString stringWithFormat:@"%@$%@", _imageThumb, _image], _video, _location, clientKey, code];
    [networkIns sendData:cmd];
}

- (void) addMood:(NSString*)_content withClientKey:(NSString*)clientKey withCode:(int)code{
    NSString *cmd = [NSString stringWithFormat:@"ADDPOST{%@}%@}%@}%@}%@}%i<EOF>", _content, @"", @"", @"", clientKey, code];
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

- (void) removePostLike:(DataWall*)_wall{
    
    NSString *_decodeClientKey = [helperIns encodedBase64:[_wall.clientKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *_cmdAddLike = [NSString stringWithFormat:@"REMOVEPOSTLIKE{%@}%i<EOF>", _decodeClientKey, _wall.userPostID];
    [networkIns sendData:_cmdAddLike];
    
}

- (void) addComment:(NSString*)_content withImageName:(NSString*)_imgName withPostClientKey:(NSString*)_postClientKey withCommentClientKey:(NSString*)_commentClientKey withUserPostID:(int)_userPostComment{
    
    NSString *_encodeContent = [helperIns encodedBase64:[_content dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *_encodeImageName = [helperIns encodedBase64:[_imgName dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *_encodePostClientKey = [helperIns encodedBase64:[_postClientKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *_encodeCommentClientKey = [helperIns encodedBase64:[_commentClientKey dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *cmd = [NSString stringWithFormat:@"ADDCOMMENT{%@}%@}%@}%@}%i<EOF>", _encodeContent, _encodeImageName, _encodePostClientKey, _encodeCommentClientKey, _userPostComment];
    [networkIns sendData:cmd];
}

- (void) getUserProfile:(int)_userID{
    NSString *cmd = [NSString stringWithFormat:@"GETUSERPROFILE{%i<EOF>", _userID];
    [networkIns sendData:cmd];
}

- (void) getUserFollower:(int)_userID{
    NSString *cmd = [NSString stringWithFormat:@"GETUSERFOLLOWER{%i<EOF>", _userID];
    [networkIns sendData:cmd];
}

- (void) getUserFollowing:(int)_userID{
    NSString *cmd = [NSString stringWithFormat:@"GETUSERFOLLOWING{%i<EOF>", _userID];
    [networkIns sendData:cmd];
}

- (void) getUserPost:(int)_userID withCountPost:(int)_countPost withClientKey:(NSString*)_clientKey{
    NSString *_encodeClientKey = [helperIns encodedBase64:[_clientKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *cmd = [NSString stringWithFormat:@"GETUSERPOST{%i}%i}%@<EOF>", _userID, _countPost, _encodeClientKey];
    [networkIns sendData:cmd];
}

- (void) addFollow:(int)_userFollowID{
    NSString *cmd = [NSString stringWithFormat:@"USERADDFOLLOW{%i<EOF>", _userFollowID];
    [networkIns sendData:cmd];
}

- (void) setResult:(NSString *)_strResult{
    if (instances != nil && [instances count] > 0) {
//        int count = (int)[instances count];
        for (int i = 0; i < (int)[instances count]; i++) {
            id ins = [instances objectAtIndex:i];
            if ([ins conformsToProtocol:@protocol(PNetworkCommunication)]) {
                
                [ins setResult:_strResult];
                
//                [instances removeObjectAtIndex:i];
                
//                i--;
            }
        }
    }
}
@end
