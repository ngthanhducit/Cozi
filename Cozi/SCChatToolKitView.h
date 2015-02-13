//
//  SCChatToolKitView.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/27/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "Helper.h"

@interface SCChatToolKitView : UIView <HPGrowingTextViewDelegate>
{
    CGPoint                 preTouchLocation;
    CGFloat                 alphaView;
    NSTimer                 *timerLoop;
    Helper                  *helperIns;
}

@property (nonatomic, strong) UIView                *vTextChat;
@property (nonatomic, strong) HPGrowingTextView     *hpTextChat;
@property (nonatomic, strong) UIButton              *btnSendMessage;
@property (nonatomic, strong) UIView                *vTextView;
@property (nonatomic, strong) UIView                *vTool;
@property (nonatomic, strong) UIView                *vLine;

@property (nonatomic, strong) UIButton              *btnText;
@property (nonatomic, strong) UIButton              *btnCamera;
@property (nonatomic, strong) UIButton              *btnPhoto;
@property (nonatomic, strong) UIButton              *btnLocation;
@property (nonatomic, strong) UIButton              *btnPing;

- (void) reset;
- (void) showTextField;
@end
