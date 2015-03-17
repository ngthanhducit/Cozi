//
//  SCRequestChat.h
//  Cozi
//
//  Created by ChjpCoj on 3/2/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLikeView.h"
#import "SCCommentView.h"
#import "Helper.h"

@interface SCRequestChat : UIView
{
    SCLikeView          *vDeneyChat;
    SCCommentView       *vAllowChat;
}

@property (nonatomic, strong) UIButton                  *btnDeny;
@property (nonatomic, strong) UIButton                  *btnAllow;
@end
