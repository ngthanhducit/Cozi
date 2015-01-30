//
//  SCCommentTableViewCell.h
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "TTTAttributedLabel.h"

@interface SCCommentTableViewCell : UITableViewCell
{
    Helper                  *helperIns;
}

@property (nonatomic, strong) TTTAttributedLabel           *lblNickName;
@property (nonatomic, strong) UILabel           *lblComment;
@property (nonatomic, strong) UILabel           *lblTime;
@property (nonatomic, strong) UILabel           *lblLoadMore;
@property (nonatomic, strong) UIImageView       *imgAvatar;
@end
