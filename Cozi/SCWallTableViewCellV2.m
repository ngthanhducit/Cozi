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
@synthesize vImages = _vImages;
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
@synthesize vDistance;

@synthesize imgAvatar;
@synthesize imgView;
@synthesize lblLike;
@synthesize lblComment;
@synthesize lblFullName;
@synthesize lblLocation;
@synthesize lblStatus;
@synthesize lblStatusTextOnly;
@synthesize lblViewAllComment;
@synthesize statusText = _statusText;
@synthesize nickNameText = _nickNameText;
@synthesize wallData = _wallData;
@synthesize spinner;
@synthesize btnMore;
@synthesize imgQuotes;
@synthesize imgQuotesWhite;
@synthesize imgQuotesWhiteRight;
@synthesize bottomLike;
@synthesize bottomStatusTextOnly;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setUserInteractionEnabled:NO];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.mainView setBackgroundColor:[UIColor whiteColor]];

        [self.contentView addSubview:self.mainView];
        
        [self setupVariable];
        [self setup];
    }
    
    return self;
}

- (void) setupVariable{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    
    widthBlock = [[UIScreen mainScreen] bounds].size.width;
    
    //Init Image Default
//    dImageLike = [helperIns getImageSVGContentFile:@"icon-LikeGreen"];
//    dImageMore = [helperIns getImageSVGContentFile:@"icon-openMenuGreen"];
//    dImageQuote = [helperIns getImageSVGContentFile:@"icon-QuoteGreen"];
//    dImageQuoteWhite = [helperIns getImageSVGContentFile:@"icon-QuoteWhite"];
//    dImageMoreComment = [helperIns getImageSVGContentFile:@"MoreCommentsGreen"];
//    dIconLike = [helperIns getImageSVGContentFile:@"icon-LikeWhite"];
    
    dImageLike = [helperIns getImageFromSVGName:@"icon-LikeGreenv2.svg"];
    dImageMore = [helperIns getImageFromSVGName:@"icon-openMenuGreen.svg"];
    dImageQuote = [helperIns getImageFromSVGName:@"icon-QuoteGreenv2.svg"];
    dImageQuoteWhite = [helperIns getImageFromSVGName:@"icon-QuoteWhite.svg"];
    dImageMoreComment = [helperIns getImageFromSVGName:@"icon-MoreCommentsGreen.svg"];
    dIconLike = [helperIns getImageFromSVGName:@"icon-LikeWhite.svg"];
}

- (void) setup{
    
    self.vImages = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [_vImages setBackgroundColor:[UIColor clearColor]];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgView setAutoresizingMask:UIViewAutoresizingNone];
    self.imgView.layer.borderWidth = 0.0f;
    [self.imgView setClipsToBounds:YES];
    
    [self.vImages addSubview:self.imgView];
    
    self.imgWaiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imgWaiting setFrame:CGRectMake(0, 0, widthBlock, widthBlock)];
    [self.vImages addSubview:self.imgWaiting];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setBackgroundColor:[UIColor clearColor]];
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = NO;
    [self.spinner setContentMode:UIViewContentModeCenter];
    [self.spinner setHidden:YES];
    self.spinner.frame = CGRectMake(0, 0, widthBlock, widthBlock);
    
    [self.vImages addSubview:self.spinner];

    [self.mainView addSubview:_vImages];

    self.vLike = [[UIView alloc] initWithFrame:CGRectMake(0, _vImages.bounds.size.height + spacing, widthBlock, heightDefault)];
    [vLike setBackgroundColor:[UIColor clearColor]];
    
    self.bottomLike = [CALayer layer];
    [self.bottomLike setFrame:CGRectMake(0.0f, self.vLike.bounds.size.height - 0.5, widthBlock, 0.5f)];
    [self.bottomLike setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vLike.layer addSublayer:self.bottomLike];
    
    UIImageView *imgLike = [[UIImageView alloc] initWithImage:dImageLike];
    [imgLike setBackgroundColor:[UIColor clearColor]];
    [imgLike setFrame:CGRectMake(0, 5, sizeIconLeft.width, sizeIconLeft.height)];
    [vLike addSubview:imgLike];
    
    self.lblLike = [[UILabel alloc] initWithFrame:CGRectMake(leftSpacing, 0, 80, heightDefault)];
    [self.lblLike setText:@"8568 likes"];
    [self.lblLike setTextColor:[UIColor grayColor]];
    [self.lblLike setTextAlignment:NSTextAlignmentLeft];
    [self.lblLike setFont:[helperIns getFontLight:13.0f]];
    [vLike addSubview:self.lblLike];
    
    self.btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnMore setImage:dImageMore forState:UIControlStateNormal];
    [self.btnMore setContentMode:UIViewContentModeCenter];
    [self.btnMore setFrame:CGRectMake(widthBlock - 40, 0, 40, 40)];
    [self.vLike addSubview:self.btnMore];

    [self.mainView addSubview:vLike];
    
    self.vStatus = [[UIView alloc] initWithFrame:CGRectMake(0, _vImages.bounds.size.height + vLike.bounds.size.height + spacing, widthBlock, 18.5)];
    
    self.imgQuotes = [[UIImageView alloc] initWithImage:dImageQuote];
    [self.imgQuotes setBackgroundColor:[UIColor clearColor]];
    [self.imgQuotes setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotes setFrame:CGRectMake(0, -5, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotes];
    
    self.imgQuotesWhite = [[UIImageView alloc] initWithImage:dImageQuote];
    [self.imgQuotesWhite setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotesWhite setFrame:CGRectMake(0, -5, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotesWhite];
    
    self.imgQuotesWhiteRight = [[UIImageView alloc] initWithImage:dImageQuote];
    [self.imgQuotesWhiteRight setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgQuotesWhiteRight setFrame:CGRectMake(widthBlock - sizeIconLeft.width, 0, sizeIconLeft.width, sizeIconLeft.height)];
    [self.vStatus addSubview:self.imgQuotesWhiteRight];
    
    self.bottomStatusTextOnly = [CALayer layer];
    [self.bottomStatusTextOnly setFrame:CGRectMake(0.0f, self.vStatus.bounds.size.height - 0.5, widthBlock, 0.5f)];
    [self.bottomStatusTextOnly setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vStatus.layer addSublayer:self.bottomStatusTextOnly];

    self.lblStatus = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(leftSpacing, 0, self.bounds.size.width - 60, 18.5)];
    self.lblStatus.font = [helperIns getFontLight:14.0f];
    self.lblStatus.textColor = [UIColor darkGrayColor];
    self.lblStatus.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblStatus.numberOfLines = 0;
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    
    UIFont *baseFont = [helperIns getFontRegular:14.0f];
    CTFontRef baseFontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
    mutableLinkAttributes[(__bridge NSString *)kCTFontAttributeName] = (__bridge id)baseFontRef;
    CFRelease(baseFontRef);
    
    self.lblStatus.linkAttributes = mutableLinkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.lblStatus.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.lblStatus.highlightedTextColor = [UIColor whiteColor];
    self.lblStatus.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [self.lblStatus setTextAlignment:NSTextAlignmentLeft];
    [self.lblStatus setFont:[helperIns getFontLight:14.0f]];
    
    [vStatus addSubview:self.lblStatus];
    
    //Status Text Only
    self.lblStatusTextOnly = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(leftSpacing, 0, self.bounds.size.width - 60, 18.5)];
    self.lblStatusTextOnly.font = [helperIns getFontLight:14.0f];
    self.lblStatusTextOnly.textColor = [UIColor darkGrayColor];
    self.lblStatusTextOnly.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblStatusTextOnly.numberOfLines = 0;
    self.lblStatusTextOnly.linkAttributes = mutableLinkAttributes;
    self.lblStatusTextOnly.activeLinkAttributes = mutableActiveLinkAttributes;
    self.lblStatusTextOnly.highlightedTextColor = [UIColor whiteColor];
    self.lblStatusTextOnly.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [self.lblStatusTextOnly setTextAlignment:NSTextAlignmentCenter];
    [self.lblStatusTextOnly setFont:[helperIns getFontItalic
                                     :14.0f]];
    
    [vStatus addSubview:self.lblStatusTextOnly];

    [self.mainView addSubview:vStatus];

//    View All Comment
    self.vAllComment = [[UIView alloc] initWithFrame:CGRectMake(0, _vImages.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock, heightDefault)];
    [self.mainView addSubview:self.vAllComment];
    
    CALayer *topLine = [CALayer layer];
    [topLine setFrame:CGRectMake(0.0f, 0, widthBlock, 0.5f)];
    [topLine setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vAllComment.layer addSublayer:topLine];
    
    CALayer *bottomLine = [CALayer layer];
    [bottomLine setFrame:CGRectMake(0.0f, self.vAllComment.bounds.size.height - 0.5, widthBlock, 0.5f)];
    [bottomLine setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vAllComment.layer addSublayer:bottomLine];
    
    self.iconViewAllComment = [[UIImageView alloc] initWithImage:dImageMoreComment];
    [self.iconViewAllComment setUserInteractionEnabled:NO];
    [self.iconViewAllComment setFrame:CGRectMake(widthBlock - 40, 0, 40, 40)];
    [self.vAllComment addSubview:self.iconViewAllComment];
    
    //lblView All Comment
    self.lblViewAllComment = [[UILabel alloc] initWithFrame:CGRectMake(self.iconViewAllComment.frame.origin.x - (widthBlock - 100), 0, widthBlock - 100, heightDefault)];
    [self.lblViewAllComment setUserInteractionEnabled:NO];
    [self.lblViewAllComment setTextAlignment:NSTextAlignmentRight];
    [self.lblViewAllComment setText:@"view all 70 comment"];
    [self.lblViewAllComment setFont:[helperIns getFontLight:13]];
    [self.lblViewAllComment setTextColor:[UIColor grayColor]];
    [self.vAllComment addSubview:self.lblViewAllComment];
    
    vComment = [[UIView alloc] initWithFrame:CGRectMake(0, _vImages.bounds.size.height + lblViewAllComment.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock - 20, 0)];
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
    [self.btnLike setImage:dIconLike forState:UIControlStateNormal];
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
    [self.btnComment setImage:dImageQuoteWhite forState:UIControlStateNormal];
    [self.btnComment.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnComment setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.vCommentButton addSubview:self.btnComment];
    
    [self.mainView addSubview:vTool];
    
    self.vDistance = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mainView addSubview:vDistance];
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
    
    if (_wallData.codeType != 0) {

        NSArray *subArray = [self.statusText componentsSeparatedByString:@"^tt^"];
        
        NSString *str = [[NSString stringWithFormat:@"%@ %@", self.nickNameText, self.statusText] stringByReplacingOccurrencesOfString:@"^tt^" withString:@""];
        
        [self.lblStatus setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            return mutableAttributedString;
        }];
        
        NSRange r = [str rangeOfString:self.nickNameText];
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
    }else{
        
        NSArray *subArray = [self.statusText componentsSeparatedByString:@"^tt^"];
        
        NSString *str = [[NSString stringWithFormat:@"%@", self.statusText] stringByReplacingOccurrencesOfString:@"^tt^" withString:@""];
        
        [self.lblStatusTextOnly setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            return mutableAttributedString;
        }];
        
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
                    [self.lblStatusTextOnly addLinkToURL:[NSURL URLWithString:strTag] withRange:rTag];
                    
                }
            }
        }
    }
    
    [self.lblStatus setNeedsDisplay];
    [self.lblStatusTextOnly setNeedsDisplay];
}

- (void) renderComment{
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 40, 10000);

    if ([self.wallData.comments count] > 0) {
        int max = 4;
        if ([self.wallData.comments count] < 4) {
            int count = (int)[self.wallData.comments count];
            max = count;
        }
        
        for (TTTAttributedLabel *comment in [self.vComment subviews]) {
            [comment removeFromSuperview];
        }
        
        CGFloat y = 10;
        int count = (int)[self.wallData.comments count];
        for (int i = count - 1; i >= count - max; i--) {

            __weak PostComment *postComment = (PostComment*)[self.wallData.comments objectAtIndex:i];
            UIImageView *imgAvatarComment = [[UIImageView alloc] init];
            [imgAvatarComment setBackgroundColor:[UIColor lightGrayColor]];
            [imgAvatarComment setFrame:CGRectMake(5, y, 30, 30)];
            [imgAvatarComment setContentMode:UIViewContentModeScaleAspectFill];
            [imgAvatarComment setAutoresizingMask:UIViewAutoresizingNone];
            imgAvatarComment.layer.borderWidth = 0.0f;
            [imgAvatarComment setClipsToBounds:YES];
            imgAvatarComment.layer.cornerRadius = imgAvatarComment.bounds.size.height / 2;
            [self.vComment addSubview:imgAvatarComment];

            __weak Friend *_friend = [storeIns getFriendByID:postComment.userCommentId];
            if (_friend != nil) {
                [imgAvatarComment setImage:_friend.thumbnail];
            }else if(postComment.userCommentId == storeIns.user.userID){
                [imgAvatarComment setImage:storeIns.user.thumbnail];
            }else{
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:postComment.urlAvatarThumb] options:3 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    if (image && finished) {
                        [imgAvatarComment setImage:image];
                    }
                    
                }];
            }
            
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@", strFullName, postComment.contentComment];
            CGSize sizeComment = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            
            TTTAttributedLabel *_lblComment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(leftSpacingComment, y, self.bounds.size.width - 45, sizeComment.height + 15)];
            [_lblComment setContentMode:UIViewContentModeCenter];
            [_lblComment setDelegate:self];
            _lblComment.font = [helperIns getFontLight:14.0f];
            _lblComment.textColor = [UIColor darkGrayColor];
            _lblComment.lineBreakMode = NSLineBreakByCharWrapping;
            _lblComment.numberOfLines = 0;
            
            NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
            [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
            [mutableLinkAttributes setValue:(__bridge id)[[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
            
            UIFont *baseFont = [helperIns getFontRegular:14.0f];
            CTFontRef baseFontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
            mutableLinkAttributes[(__bridge NSString *)kCTFontAttributeName] = (__bridge id)baseFontRef;
            CFRelease(baseFontRef);
            
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
            _lblComment.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
            [_lblComment setFont:[helperIns getFontLight:14.0f]];
            
            [_lblComment setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                return mutableAttributedString;
            }];
            
            y += sizeComment.height + 20;
            
            NSRange r = [str rangeOfString:[NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName]];
            NSString *strLink = [NSString stringWithFormat:@"action://show-profile?%i", postComment.userCommentId];
            strLink = [strLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [_lblComment addLinkToURL:[NSURL URLWithString:strLink] withRange:r];
            
            [self.vComment addSubview:_lblComment];
            
        }
        
    }

}

- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-profile"]) {
            //             load help screen
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            if ([query intValue] == storeIns.user.userID) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
            }else{
                NSString *key = @"tapFriend";
                NSNumber *userCommentID = [NSNumber numberWithInt:[query intValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:userCommentID forKey:key];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
            }
            
//            Friend *_friend = [storeIns getFriendByID:[query intValue]];
//            
//            if (_friend != nil) {
//                NSString *key = @"tapFriend";
//                NSNumber *userCommentID = [NSNumber numberWithInt:[query intValue]];
//                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:userCommentID forKey:key];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMyProfile" object:nil userInfo:nil];
//            }
            
        } else if ([[url host] hasPrefix:@"show-tag"]) {
            /* load settings screen */
            NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"Click Tag %@", query);
        }
    } else {
        /* deal with http links here */
    }
}

@end
