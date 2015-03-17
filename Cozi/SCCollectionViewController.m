//
//  SCCollectionViewController.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/23/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "SCCollectionViewController.h"

@interface SCCollectionViewController ()

@end

const CGFloat spacingCell = 10.0f;
@implementation SCCollectionViewController

static NSString * const reuseIdentifier = @"reuseRecentCell";

- (id) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup{
    increment = YES;
    indexPathSelected = [[NSMutableDictionary alloc] init];
    indexNewMessenger = [[NSMutableArray alloc] init];
    
    self.storeIns = [Store shareInstance];
    self.helperIns = [Helper shareInstance];
    
    imgNotify = [self.helperIns getImageFromSVGName:@"notify"];
    
    gColor = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]];
//    newMessageColor = [UIColor colorWithRed:242/255.0f green:50/255.0f blue:2/255.0f alpha:1];
    newMessageColor = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"RedColor1"]];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:YES];
}

- (void) initWithData:(NSMutableArray *)_itemData withType:(int)_type{

    itemData = [[NSMutableArray alloc] init];
    
    type = _type;
    
    if (type == 1) {
        int count = (int)[_itemData count];
        for (int i = 0; i < count; i++) {
            ImageSelected *_newImg = [[ImageSelected alloc] init];
            _newImg.isSelected = NO;
            _newImg.imgShow = [_itemData objectAtIndex:i];
            _newImg.index = i;
            [itemData addObject:_newImg];
        }
    }else{
        if (_itemData != nil) {
            itemData = _itemData;
        }
    }

    // Register cell classes
    [self registerClass:[SCCollectionViewCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self setDelegate:self];
    [self setDataSource:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return [self.storeIns.friends count];
    return [itemData count];
//    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (type == 0) {
        SCCollectionViewCell *scCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                                 forIndexPath:indexPath];
        
        
        scCell.layer.shouldRasterize = YES;
        scCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [scCell.imgView setFrame:CGRectMake((scCell.bounds.size.width / 2) - (scCell.imgView.bounds.size.width / 2), (scCell.bounds.size.width / 2) - (scCell.imgView.bounds.size.width / 2), scCell.imgView.bounds.size.width, scCell.imgView.bounds.size.height)];
        
//        Friend *_friend = [itemData objectAtIndex:indexPath.section];
        Recent *_recent = [itemData objectAtIndex:indexPath.section];
        
        CGFloat margin = (scCell.bounds.size.height - (scCell.imgView.bounds.size.height + (scCell.lblName.bounds.size.height / 2))) / 2;
        
//        [scCell.viewBorder setFrame:CGRectMake((scCell.bounds.size.width / 2) - (scCell.viewBorder.bounds.size.width / 2), margin - 5, scCell.viewBorder.bounds.size.width, scCell.viewBorder.bounds.size.height)];
//        [scCell.viewBorder setBackgroundColor:[UIColor clearColor]];
//        [scCell.viewBorder setContentMode:UIViewContentModeScaleAspectFill];
//        [scCell.viewBorder setAutoresizingMask:UIViewAutoresizingNone];
//        
//        [scCell.viewBorder setClipsToBounds:YES];
//        scCell.viewBorder.layer.cornerRadius = CGRectGetHeight(scCell.viewBorder.frame)/2;
        
        [scCell.shadowImage setFrame:CGRectMake((scCell.bounds.size.width / 2) - (scCell.shadowImage.bounds.size.width / 2), margin, scCell.shadowImage.bounds.size.width, scCell.shadowImage.bounds.size.height)];
        [scCell.shadowImage setContentMode:UIViewContentModeScaleAspectFill];
        [scCell.shadowImage setAutoresizingMask:UIViewAutoresizingNone];
        [scCell.shadowImage setClipsToBounds:NO];
        scCell.shadowImage.layer.cornerRadius = CGRectGetHeight(scCell.shadowImage.frame)/2;
        
        scCell.shadowImage.layer.shadowColor = [UIColor grayColor].CGColor;
        scCell.shadowImage.layer.shadowOffset = CGSizeMake(1, 1.5);
        scCell.shadowImage.layer.shadowOpacity = 1;
        scCell.shadowImage.layer.shadowRadius = 1.0;
        
        CGFloat marginAvatar = (scCell.shadowImage.bounds.size.height - scCell.imgView.bounds.size.height) / 2;
        
        if (_recent.thumbnail) {
            
            [scCell.imgView setImage:_recent.thumbnail];
            
        }else{
            if (![_recent.urlThumbnail isEqualToString:@""]) {
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_recent.urlThumbnail] options:4 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image && finished) {
                        _recent.thumbnail = image;
                        [scCell.imgView setImage:image];
                    }
                }];
                
            }else{
                
                _recent.thumbnail = [self.helperIns getDefaultAvatar];
                [scCell.imgView setImage:[self.helperIns getDefaultAvatar]];
            
            }
        }
        
        [scCell.imgView setFrame:CGRectMake(marginAvatar, marginAvatar, scCell.imgView.bounds.size.width, scCell.imgView.bounds.size.height)];
        
        [scCell.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [scCell.imgView setAutoresizingMask:UIViewAutoresizingNone];
        [scCell.imgView setClipsToBounds:NO];
        scCell.imgView.layer.cornerRadius = CGRectGetHeight(scCell.imgView.frame)/2;
        scCell.imgView.layer.masksToBounds = YES;


        [scCell.lblName setTextAlignment:NSTextAlignmentCenter];
        [scCell.lblName setFrame:CGRectMake(0, scCell.bounds.size.height - (scCell.lblName.bounds.size.height) + 2, scCell.bounds.size.width, scCell.lblName.bounds.size.height)];
        [scCell.lblName setFont:[self.helperIns getFontLight:11]];
        [scCell.lblName setBackgroundColor:[UIColor clearColor]];
        NSString *name = [_recent.nameRecent uppercaseString];
        [scCell.lblName setText:name];

        [scCell.vBorderNotify setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1]];
        scCell.vBorderNotify.layer.cornerRadius = scCell.vBorderNotify.bounds.size.width / 2;
        [scCell.vBorderNotify setContentMode:UIViewContentModeCenter];
        [scCell.vBorderNotify setAutoresizingMask:UIViewAutoresizingNone];
        [scCell.vBorderNotify setClipsToBounds:YES];
        [scCell.vBorderNotify setHidden:NO];
        
        [scCell.imgNotify setHidden:NO];
        [scCell.imgNotify setImage:imgNotify];
        scCell.imgNotify.layer.cornerRadius = scCell.imgNotify.bounds.size.width / 2;
        [scCell.imgNotify setContentMode:UIViewContentModeCenter];
        [scCell.imgNotify setAutoresizingMask:UIViewAutoresizingNone];
        [scCell.imgNotify setClipsToBounds:YES];
        
        if (_recent.typeRecent == 0) {
            if ([_recent.friendIns.friendMessage count] > 0 && [[_recent.friendIns.friendMessage lastObject] statusMessage] == 1 &&
                [[_recent.friendIns.friendMessage lastObject] senderID] > 0) {
                
                //            NSAttributedString *textAttribute = [[NSAttributedString alloc] initWithString:scCell.lblName.text attributes:@{ NSForegroundColorAttributeName : gColor }];
                //            [scCell.lblName setAttributedText:textAttribute];
                
                scCell.imgView.layer.borderWidth = 2.0f;
                scCell.imgView.layer.borderColor = gColor.CGColor;
                
                [scCell.imgNotify setBackgroundColor:newMessageColor];
            }else{
                if (_recent.friendIns.isFriendWithYour == 0) {
                    
                    //            [scCell.lblName setTextColor:[UIColor blackColor]];
                    
                    scCell.imgView.layer.borderWidth = 0.0f;
                    scCell.imgView.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    [scCell.imgNotify setHidden:YES];
                    [scCell.vBorderNotify setHidden:YES];
                    
                }else{
                    
                    scCell.imgView.layer.borderWidth = 2.0f;
                    scCell.imgView.layer.borderColor = gColor.CGColor;
                    
                    [scCell.imgNotify setBackgroundColor:newMessageColor];
                    
                }
            }
    
        }else{  //Group Chat
            
            if ([_recent.messengerRecent count] > 0 && [[_recent.messengerRecent lastObject] statusMessage] == 1 &&
                [[_recent.messengerRecent lastObject] senderID] > 0) {
                
                scCell.imgView.layer.borderWidth = 2.0f;
                scCell.imgView.layer.borderColor = gColor.CGColor;
                
                [scCell.imgNotify setBackgroundColor:newMessageColor];
            }else{
                if (_recent.friendIns.isFriendWithYour == 0) {
                    
                    scCell.imgView.layer.borderWidth = 0.0f;
                    scCell.imgView.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    [scCell.imgNotify setHidden:YES];
                    [scCell.vBorderNotify setHidden:YES];
                    
                }else{
                    
                    scCell.imgView.layer.borderWidth = 2.0f;
                    scCell.imgView.layer.borderColor = gColor.CGColor;
                    
                    [scCell.imgNotify setBackgroundColor:newMessageColor];
                    
                }
            }
            
        }
        
//        [scCell.imgNotify setFrame:CGRectMake((scCell.bounds.size.width / 2) - (scCell.imgNotify.bounds.size.width / 2) + 26, (scCell.bounds.size.height / 2) - (scCell.imgNotify.bounds.size.height / 2) - 25, 20, 20)];
        
        [scCell.vBorderNotify setFrame:CGRectMake((scCell.bounds.size.width / 2) - (scCell.vBorderNotify.bounds.size.width / 2) + 26, (scCell.bounds.size.height / 2) - (scCell.imgNotify.bounds.size.height / 2) - 25, 24, 24)];
        
        return scCell;
    }
    
    
    if (type == 1) {
        SCCollectionViewCell *scCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                                forIndexPath:indexPath];
        [scCell setBackgroundColor:[UIColor grayColor]];
        
        ImageSelected *_img = [itemData objectAtIndex:indexPath.section];
        
        [scCell.imgView setImage:_img.imgShow];
        [scCell.imgView setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
        [scCell.imgView setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GrayColor1"]]];
        [scCell.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [scCell.imgView setAutoresizingMask:UIViewAutoresizingNone];
        [scCell.imgView setClipsToBounds:YES];
        
        [scCell.shadowImage setFrame:CGRectMake(0, 0, scCell.bounds.size.width, scCell.bounds.size.height)];
        [scCell.shadowImage setBackgroundColor:[UIColor whiteColor]];
        scCell.shadowImage.layer.borderWidth = 4.0f;
        
        if (_img.isSelected) {
            scCell.shadowImage.layer.borderColor = gColor.CGColor;
        }else{
            scCell.shadowImage.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        return scCell;
    }

    return nil;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type == 0) {

//        [timerNewMessenger invalidate];
//        timerNewMessenger = nil;
        Recent *_recent = [itemData objectAtIndex:indexPath.section];
        NSString *key = @"tapCellIndex";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_recent forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postTapCellIndex" object:nil userInfo:dictionary];
        
    }
    
    if (type == 1) {
        
        ImageSelected *_newImage = [itemData objectAtIndex:indexPath.section];
        if (_newImage.isSelected) {
            [[itemData objectAtIndex:indexPath.section] setIsSelected:NO];
            
        }else{
            
            [[itemData objectAtIndex:indexPath.section] setIsSelected:YES];
        }
        
        [self reloadData];
    }
}

- (UIBezierPath*) drawRectangle:(CGSize)_size{
    UIBezierPath        *path = [UIBezierPath bezierPath];
    [path setLineWidth:0.5f];
    
    [path moveToPoint:CGPointMake(1.0, 1.0)];
    [path addLineToPoint:CGPointMake(1.0, _size.height - 1)];
    [path addLineToPoint:CGPointMake(_size.width - 1, _size.height- 1)];
    [path addLineToPoint:CGPointMake(_size.width - 1, 1.0)];
    [path addLineToPoint:CGPointMake(-0.5, 1.0)];
    
    return path;
}

- (NSMutableArray*) getItemSelected{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (itemData != nil) {
        int count = (int)[itemData count];
        for (int i = 0; i < count; i++) {
            if ([[itemData objectAtIndex:i] isSelected]) {
                [result addObject:[itemData objectAtIndex:i]];
            }
        }
    }
    
    return result;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scCollectionDelegate && [self.scCollectionDelegate respondsToSelector:@selector(delegateScrollView:)]) {
        [self.scCollectionDelegate delegateScrollView:scrollView];
    }
}

- (void) animationNewMessenger:(NSIndexPath*)_index{

    timerNewMessenger = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(processNewMessenger) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timerNewMessenger forMode:NSRunLoopCommonModes];
}

- (void) processNewMessenger{
    
    if (increment) {
        
        [UIView beginAnimations:@"scaleDown" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        for (int i = 0; i < [indexNewMessenger count]; i++) {
            SCCollectionViewCell *scCell = (SCCollectionViewCell*)[self cellForItemAtIndexPath:[indexNewMessenger objectAtIndex:i]];
            scCell.viewBorder.transform = CGAffineTransformMakeScale(0.7, 0.7);
            scCell.viewBorder.alpha = 0.8; // use if you want it to glow too
        }
        [UIView commitAnimations];
        
        increment = NO;
        
    }else{
        
        [UIView beginAnimations:@"scaleUp" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        for (int i = 0; i < [indexNewMessenger count]; i++) {
            SCCollectionViewCell *scCell = (SCCollectionViewCell*)[self cellForItemAtIndexPath:[indexNewMessenger objectAtIndex:i]];
            scCell.viewBorder.transform = CGAffineTransformMakeScale(1, 1);
            scCell.viewBorder.alpha = 0.8; // use if you want it to glow too
        }
        
        [UIView commitAnimations];
        
        increment = YES;
    }
}

@end
