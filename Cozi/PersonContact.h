//
//  PersonContact.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/28/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersonContact : NSObject
{
    
}

@property (nonatomic, strong) NSString              *firstName;
@property (nonatomic, strong) NSString              *lastName;
@property (nonatomic, strong) NSString              *midName;
@property (nonatomic, strong) NSString              *fullName;
@property (nonatomic, strong) NSString              *phone;
@property (nonatomic, strong) UIImage               *imgThumbnail;
@end
