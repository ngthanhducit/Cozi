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
@synthesize vComment;
@synthesize vTool;

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
    spacing = 5;
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
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = NO;
    [self.spinner setContentMode:UIViewContentModeCenter];
    [self.spinner setHidden:YES];
    self.spinner.frame = CGRectMake(0, 0, widthBlock, widthBlock);
    
    [self.vImages addSubview:self.spinner];

    [self.mainView addSubview:vImages];

    self.vLike = [[UIView alloc] initWithFrame:CGRectMake(0, vImages.bounds.size.height + spacing, widthBlock, 20)];
    [vLike setBackgroundColor:[UIColor clearColor]];

    UIImageView *imgLike = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
    [imgLike setBackgroundColor:[UIColor clearColor]];
    [imgLike setFrame:CGRectMake(0, 0, 40, 40)];
//    [vLike addSubview:imgLike];
    
    self.lblLike = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    [self.lblLike setText:@"8568 likes"];
    [self.lblLike setTextColor:[UIColor grayColor]];
    [self.lblLike setTextAlignment:NSTextAlignmentLeft];
    [self.lblLike setFont:[helperIns getFontLight:13.0f]];
    [vLike addSubview:self.lblLike];

    [self.mainView addSubview:vLike];
    
    self.vStatus = [[UIView alloc] initWithFrame:CGRectMake(20, vImages.bounds.size.height + vLike.bounds.size.height + spacing, widthBlock - 20, 18.5)];

    self.lblStatus = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 18.5)];
    self.lblStatus.font = [helperIns getFontLight:14.0f];
    self.lblStatus.textColor = [UIColor darkGrayColor];
    self.lblStatus.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblStatus.numberOfLines = 0;
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
//    [mutableLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
//    [mutableLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];

    self.lblStatus.linkAttributes = mutableLinkAttributes;
    
//    self.lblStatus.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
    
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
    self.lblStatus.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self.lblStatus setFont:[helperIns getFontLight:14.0f]];
    
    [vStatus addSubview:self.lblStatus];

    [self.mainView addSubview:vStatus];

    //lblView All Comment
    self.lblViewAllComment = [[UILabel alloc] initWithFrame:CGRectMake(20, vImages.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock - 10, 20)];
    [self.lblViewAllComment setText:@"view all 70 comment"];
    [self.lblViewAllComment setFont:[helperIns getFontLight:13]];
    [self.lblViewAllComment setTextColor:[UIColor grayColor]];
    [self.lblViewAllComment setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.lblViewAllComment];
    
    vComment = [[UIView alloc] initWithFrame:CGRectMake(20, vImages.bounds.size.height + lblViewAllComment.bounds.size.height + vLike.bounds.size.height + vStatus.bounds.size.height + spacing, widthBlock - 20, 100)];
//    [vComment setBackgroundColor:[UIColor purpleColor]];
    [self.mainView addSubview:vComment];
 
    vTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.bounds.size.height - (self.mainView.bounds.size.height - 20), widthBlock, 40)];
    [vTool setBackgroundColor:[UIColor orangeColor]];
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
    [self.lblStatus setNeedsDisplay];
}

- (void) renderComment{
    
    //calculation height cell + spacing top and bottom
    CGSize textSize = CGSizeMake(self.bounds.size.width - 20, 10000);
    CGSize sizeComment = { 0, 0 };

    if ([self.wallData.comments count] > 0) {
        int max = 4;
        if ([self.wallData.comments count] < 4) {
            int count = (int)[self.wallData.comments count];
            max = count;
        }
        
        CGFloat y = 0;
        int count = (int)[self.wallData.comments count];
        for (int i = count - 1; i >= count - max; i--) {

            PostComment *postComment = (PostComment*)[self.wallData.comments objectAtIndex:i];
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@", strFullName, postComment.contentComment];
            sizeComment = [str sizeWithFont:[helperIns getFontLight:14.0f] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
            
            TTTAttributedLabel *_lblComment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width - 20, sizeComment.height)];
            [_lblComment setDelegate:self];
            _lblComment.font = [helperIns getFontLight:14.0f];
            _lblComment.textColor = [UIColor darkGrayColor];
            _lblComment.lineBreakMode = NSLineBreakByCharWrapping;
            _lblComment.numberOfLines = 0;
            
            NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
            [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
            [mutableLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
            
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
            _lblComment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
            [_lblComment setFont:[helperIns getFontLight:14.0f]];
            
            [_lblComment setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                return mutableAttributedString;
            }];
            
            y += sizeComment.height;
            
            NSRange r = [str rangeOfString:[NSString stringWithFormat:@"%@ %@", postComment.firstName, postComment.lastName]];
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
