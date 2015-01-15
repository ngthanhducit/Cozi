//
//  NearLocation.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearLocation : NSObject
{
    
}

@property (nonatomic, strong) NSString              *lng;
@property (nonatomic, strong) NSString              *lat;
@property (nonatomic, strong) NSString              *icon;
@property (nonatomic, strong) NSString              *idNear;
@property (nonatomic, strong) NSString              *placeId;
@property (nonatomic, strong) NSString              *nearName;
@property (nonatomic, strong) NSString              *reference;
@property (nonatomic, strong) NSString              *scope;
@property (nonatomic, strong) NSString              *types;
@property (nonatomic, strong) NSString              *vicinity;

@end
