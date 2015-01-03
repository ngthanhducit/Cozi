//
//  SCWallTableViewCellV2.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/24/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCWallTableViewCellV2.h"

@implementation SCWallTableViewCellV2

@synthesize mainView;
@synthesize vImages;
@synthesize vLike;
@synthesize vProfile;
@synthesize vStatus;
@synthesize vAllComment;
@synthesize vComment;
@synthesize vTool;
@synthesize vLikeButton;
@synthesize vCommentButton;
@synthesize btnLike;
@synthesize btnComment;

@synthesize imgAvatar;
@synthesize imgView;
@synthesize lblLike;
@synthesize lblComment;
@synthesize lblFullName;
@synthesize lblLocation;
@synthesize lblStatus;
@synthesize lblViewAllComment;
@synthesize statusText = _statusText;
@synthesize nickNameText = _nickNameText;
@synthesize wallData = _wallData;
@synthesize spinner;
@synthesize imgMore;
@synthesize imgQuotes;
@synthesize imgQuotesWhite;
@synthesize imgQuotesWhiteRight;
@synthesize bottomLike;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setUserInteractionEnabled:NO];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.mainView = [[UIView alloc] initWithFrame:self.bounds];
        [self.mainView setBackgroundColor:[UIColor whiteColor]];

        [self.contentView addSubview:self.mainView];
        
        [self setupVariable];
        [self setup];
    }
    
    return self;
}

- (void) setupVariable{
    spacing = 0;
    leftSpacing = 30;
    heightDefault = 40; //height like, view all comment
    leftSpacingComment = 40;
    spacingLineComment = 10;
    heightVTool = 30;
    
    sizeIconLeft = CGSizeMake(30, 30);
    sizeAvatarComment = CGSizeMake(40, 40);

    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    
    widthBlock = self.bounds.size.width;
}

- (void) setup{
    
    self.vImages = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [vImages setBackgroundColor:[UIColor clearColor]];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgView setAutoresizingMask:UIViewAutoresizingNone];
    self.imgView.layer.borderWidth = 0.0f;
    [self.imgView setClipsToBounds:YES];
    
    [self.vImages addSubview:self.imgView];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setBackgroundColor:[UIColor clearColor]];
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = NO;
    [self.spinner setContentMode:UIViewContentModeCenter];
    [self.spinner setHidden:YES];
    self.spinner.frame = CGRectMake(0, 0, widthBlock, widthBlock);
    
    [self.vImages addSubview:self.spinner];

    [self.mainView addSubview:vImages];

    self.vLike = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + spacing, widthBlock, heightDefault)];
    [vLike setBackgroundColor:[UIColor clearColor]];
    
    self.bottomLike = [CALayer layer];
    [self.bottomLike setFrame:CGRectMake(0.0f, self.vLike.bounds.size.height - 0.5, widthBlock, 0.5f)];
    [self.bottomLike setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vLike.layer addSublayer:self.bottomLike];

    UIImageView *imgLike = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-LikeGreen.svg"]];
    [imgLike setBackgroundColor:[UIColor clearColor]];
    [imgLike setFrame:CGRectMake(0, 5, sizeIconLeft.width, sizeIconLeft.height)];
    [vLike addSubview:imgLike];
    
    self.lblLike = [[UILabel alloc] initWithFrame:CGRectMake(leftSpacing, 0, 80, heightDefault)];
    [self.lblLike setText:@"8568 likes"];
    [self.lblLike setTextColor:[UIColor grayColor]];
    [self.lblLike setTextAlignment:NSTextAlignmentLeft];
    [self.lblLike setFont:[helperIns getFontLight:18.0f]];
    [vLike addSubview:self.lblLike];
    
    self.imgMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imgMore setImage:[helperIns getImageFromSVGName:@"icon-openMenuGreen.svg"] forState:UIControlStateNormal];
    [self.imgMore setContentMode:UIViewContentModeCenter];
    [self.imgMore setFrame:CGRectMake(widthBlock - 40, 0, 40, 40)];
    [self.vLike addSubview:self.imgMore];

    [self.mainView addSubview:vLike];
    
    self.vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + spacing, widthBlock, 18.5)];
    
    self.imgQuotes = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-QuoteGreen.svg"]];
    [self.imgQuotes setBackgroundColor:[UIColor clearColor]];
    [self.imgQuotes setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotes setFrame:CGRectMake(0, -5, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotes];
    
    self.imgQuotesWhite = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-QuoteWhite.svg"]];
    [self.imgQuotesWhite setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotesWhite setFrame:CGRectMake(0, -5, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotesWhite];
    
    self.imgQuotesWhiteRight = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-QuoteWhite.svg"]];
    [self.imgQuotesWhiteRight setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotesWhiteRight setFrame:CGRectMake(widthBlock - sizeIconLeft.width, 0, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotesWhiteRight];


    self.lblStatus = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(leftSpacing, 0, self.bounds.size.width - 60, 18.5)];
    [self.lblStatus setTextAlignment:NSTextAlignmentJustified];
    self.lblStatus.font = [helperIns getFontLight:14.0f];
    self.lblStatus.textColor = [UIColor darkGrayColor];
    self.lblStatus.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblStatus.numberOfLines = 0;
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.lblStatus.linkAttributes = mutableLinkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.lblStatus.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.lblStatus.highlightedTextColor = [UIColor whiteColor];
    self.lblStatus.shadowColor = [UIColor colorWithWhite:0.87f alpha:1.0f];
    self.lblStatus.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lblStatus.highlightedShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    self.lblStatus.highlightedShadowOffset = CGSizeMake(0.0f, -1.0f);
    self.lblStatus.highlightedShadowRadius = 1;
    self.lblStatus.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [self.lblStatus setFont:[helperIns getFontLight:14.0f]];
    
    [vStatus addSubview:self.lblStatus];

    [self.mainView addSubview:vStatus];

    //View All Comment
    self.vAllComment = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock, heightDefault)];
    [self.mainView addSubview:self.vAllComment];
    
    CALayer *topLine = [CALayer layer];
    [topLine setFrame:CGRectMake(0.0f, 0, widthBlock, 0.5f)];
    [topLine setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vAllComment.layer addSublayer:topLine];
    
    CALayer *bottomLine = [CALayer layer];
    [bottomLine setFrame:CGRectMake(0.0f, self.vAllComment.bounds.size.height - 0.5, widthBlock, 0.5f)];
    [bottomLine setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vAllComment.layer addSublayer:bottomLine];
    
    UIImageView *iconViewAllComment = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-MoreCommentsGreen.svg"]];
    [iconViewAllComment setFrame:CGRectMake(widthBlock - 40, 0, 40, 40)];
    [self.vAllComment addSubview:iconViewAllComment];
    
        //lblView All Comment
    self.lblViewAllComment = [[UILabel alloc] initWithFrame:CGRectMake(iconViewAllComment.frame.origin.x - (widthBlock - 100), 0, widthBlock - 100, heightDefault)];
    [self.lblViewAllComment setTextAlignment:NSTextAlignmentRight];
    [self.lblViewAllComment setText:@"view all 70 comment"];
    [self.lblViewAllComment setFont:[helperIns getFontLight:13]];
    [self.lblViewAllComment setTextColor:[UIColor grayColor]];
    [self.vAllComment addSubview:self.lblViewAllComment];
    
    vComment = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + lblViewAllComment.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock - 20, 0)];
//    [vComment setBackgroundColor:[UIColor purpleColor]];
    [self.mainView addSubview:vComment];
 
    vTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.bounds.size.height - (self.mainView.bounds.size.height - 20), widthBlock, heightVTool)];
    [vTool setBackgroundColor:[UIColor clearColor]];
    
    self.vLikeButton = [[SCLikeView alloc] initWithFrame:CGRectMake(0, 0, (widthBlock / 2) + 9, vTool.bounds.size.height)];
    [self.vLikeButton setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor1"]]];
    [self.vTool addSubview:self.vLikeButton];
    
    self.btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLike setFrame:self.vLikeButton.bounds];
    [self.btnLike setTitle:@"LIKE" forState:UIControlStateNormal];
    [self.btnLike.titleLabel setFont:[helperIns getFontLight:13.0f]];
    [self.btnLike setImage:[helperIns getImageFromSVGName:@"icon-LikeWhite.svg"] forState:UIControlStateNormal];
    [self.btnLike.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnLike setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.vLikeButton addSubview:self.btnLike];
    
    self.vCommentButton = [[SCCommentView alloc] initWithFrame:CGRectMake((widthBlock / 2) - 9, 0,
                                                                   (widthBlock / 2) + 10, vTool.bounds.size.height)];
    [self.vCommentButton setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GrayColor2"]]];
    [self.vTool addSubview:self.vCommentButton];
    
    self.btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnComment setFrame:self.vCommentButton.bounds];
    [self.btnComment setTitle:@"COMMENT" forState:UIControlStateNormal];
    [self.btnComment.titleLabel setFont:[helperIns getFontLight:13.0f]];
    [self.btnComment setImage:[helperIns getImageFromSVGName:@"icon-QuoteWhite.svg"] forState:UIControlStateNormal];
    [self.btnComment.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnComment setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.vCommentButton addSubview:self.btnComment];
    
    [self.mainView addSubview:vTool];
}

- (void) setDataWall:(DataWall*)_wall{

    NSString *strStatus = [NSString stringWithFormat:@"%@ %@", _wall.fullName, _wall.content];
    self.lblStatus.text = strStatus;
    [self.lblStatus setFont:[helperIns getFontLight:14.0f]];
    NSRange r = [strStatus rangeOfString:_wall.fullName];
    [self.lblStatus addLinkToURL:[NSURL URLWithString:@"action://show-profile"] withRange:r];
}

- (void) setStatusText:(NSString *)statusText{
    _statusText = statusText;
}

- (void) setNickNameText:(NSString *)nickNameText{
    _nickNameText = nickNameText;
}

- (void) setWallData:(DataWall *)wallData{
    _wallData = wallData;
}

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
}

- (void) setTextStatus{
    NSArray *subArray = [self.statusText componentsSeparatedByString:@"^tt^"];
    
    NSString *str = [[NSString stringWithFormat:@"%@ %@", [self.nickNameText uppercaseString], self.statusText] stringByReplacingOccurrencesOfString:@"^tt^" withString:@""];
    
    [self.lblStatus setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        return mutableAttributedString;
    }];
    
    NSRange r = [str rangeOfString:[self.nickNameText uppercaseString]];
    NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", self.wallData.userPostID];
    strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [self.lblStatus addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
    
    if ([subArray count] > 0) {
        int count = (int)[subArray count];
        for (int i = 0; i < count; i++) {
            NSString *chunk = [subArray objectAtIndex:i];
            if ([chunk isEqualToString:@""])
            {
                continue;     // skip this loop if the chunk is empty
            }
            
            BOOL isTag = [chunk hasPrefix:@"@"];
            BOOL isSearch  = [chunk hasPrefix:@"#"];
            BOOL isLink = (BOOL)(isTag || isSearch);
            if (isLink) {
                
                NSRange rTag = [str rangeOfString:chunk];
                NSString *strTag = [NSString stringWithFormat:@"action://show-tag?%@", chunk];
                strTag = [strTag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.lblStatus addLinkToURL:[NSURL URLWithString:strTag] withRange:rTag];
                
            }
        }
    }
    [self.lblStatus setNeedsDisplay];
}

- (void) renderComment{
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 40, 10000);
    CGSize sizeComment = { 0, 0 };

    if ([self.wallData.comments count] > 0) {
        int max = 4;
        if ([self.wallData.comments count] < 4) {
            int count = (int)[self.wallData.comments count];
            max = count;
        }
        
        CGFloat y = 10;
        int count = (int)[self.wallData.comments count];
        for (int i = count - 1; i >= count - max; i--) {

            PostComment *postComment = (PostComment*)[self.wallData.comments objectAtIndex:i];
            UIImageView *imgAvatarComment = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"emptyAvatar.svg"]];
            [imgAvatarComment setBackgroundColor:[UIColor lightGrayColor]];
            [imgAvatarComment setFrame:CGRectMake(5, y, 30, 30)];
            [imgAvatarComment setContentMode:UIViewContentModeScaleAspectFill];
            [imgAvatarComment setAutoresizingMask:UIViewAutoresizingNone];
            imgAvatarComment.layer.borderWidth = 0.0f;
            [imgAvatarComment setClipsToBounds:YES];
            imgAvatarComment.layer.cornerRadius = imgAvatarComment.bounds.size.height / 2;
            [self.vComment addSubview:imgAvatarComment];

            Friend *_friend = [storeIns getFriendByID:postComment.userCommentId];
            if (_friend != nil) {
                [imgAvatarComment setImage:_friend.thumbnail];
            }else{
                [imgAvatarComment setImage:storeIns.user.thumbnail];
            }
            
            NSString *strFullName = [[NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName] uppercaseString];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@", strFullName, postComment.contentComment];
            sizeComment = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            
            TTTAttributedLabel *_lblComment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(leftSpacingComment, y, self.bounds.size.width - 45, sizeComment.height + 15)];
//            [_lblComment setBackgroundColor:[UIColor grayColor]];
            [_lblComment setContentMode:UIViewContentModeCenter];
            [_lblComment setDelegate:self];
            _lblComment.font = [helperIns getFontLight:14.0f];
            _lblComment.textColor = [UIColor darkGrayColor];
            _lblComment.lineBreakMode = NSLineBreakByCharWrapping;
            _lblComment.numberOfLines = 0;
            
            NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
            [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
            [mutableLinkAttributes setValue:(__bridge id)[[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
            
            _lblComment.linkAttributes = mutableLinkAttributes;
            
            NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
            [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
            [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
            [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
            [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
            [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
            [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
            _lblComment.activeLinkAttributes = mutableActiveLinkAttributes;
            
            _lblComment.highlightedTextColor = [UIColor whiteColor];
            _lblComment.shadowColor = [UIColor colorWithWhite:0.87f alpha:1.0f];
            _lblComment.shadowOffset = CGSizeMake(0.0f, 1.0f);
            _lblComment.highlightedShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
            _lblComment.highlightedShadowOffset = CGSizeMake(0.0f, -1.0f);
            _lblComment.highlightedShadowRadius = 1;
            _lblComment.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
            [_lblComment setFont:[helperIns getFontLight:14.0f]];
            
            [_lblComment setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                return mutableAttributedString;
            }];
            
            y += sizeComment.height + 20;
            
            NSRange r = [str rangeOfString:[[NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName] uppercaseString]];
            NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", self.wallData.userPostID];
            strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [_lblComment addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
            
            [self.vComment addSubview:_lblComment];
            
        }
        
    }

}

- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSLog(@"test");
}
@end
