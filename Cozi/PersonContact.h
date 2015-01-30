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

@property (nonatomic, copy  ) NSString *firstName;
@property (nonatomic, copy  ) NSString *lastName;
@property (nonatomic, copy  ) NSString *midName;
@property (nonatomic, copy  ) NSString *fullName;
@property (nonatomic, copy  ) NSString *phone;
@property (nonatomic, strong) UIImage  *imgThumbnail;
@end
