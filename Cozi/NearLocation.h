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

@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *idNear;
@property (nonatomic, copy) NSString *placeId;
@property (nonatomic, copy) NSString *nearName;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *types;
@property (nonatomic, copy) NSString *vicinity;

@end
