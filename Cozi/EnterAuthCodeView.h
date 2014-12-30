//
//  EnterAuthCodeView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/29/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextField.h"
#import "Helper.h"
#import "TriangleView.h"

@interface EnterAuthCodeView : UIView
{
    
}

@property (nonatomic, strong) UIView                *viewEnterCode;
@property (nonatomic, strong) SCTextField           *txtEnterCode;
@property (nonatomic, strong) UIButton              *btnSendCode;
@property (nonatomic, strong) UIButton              *btnSendCodeBack;
@end
