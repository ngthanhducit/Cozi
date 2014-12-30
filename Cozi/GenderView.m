//
//  GenderView.m
//  VPix
//
//  Created by DO PHUONG TRINH on 11/11/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "GenderView.h"
#import "Helper.h"

@implementation GenderView
@synthesize btnFemela;
@synthesize btnMale;
@synthesize numGender;

- (id) initWithFrame:(int)num withFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    Helper *helper = [Helper shareInstance];
    
    self.btnMale = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width/2, self.bounds.size.height)];
    [self.btnMale setBackgroundColor:[UIColor whiteColor]];
    [self.btnMale addTarget:self action:@selector(maleTap1) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnMale];
    
    self.lbMale=[ [UILabel alloc ] initWithFrame:CGRectMake((self.btnMale.bounds.size.width/2)-10, 0.0f, 100.0f, 40.0f) ];
    [self.lbMale setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    self.lbMale.text=@"MALE";
    self.lbMale.font=[helper getFontThin:16.0f];
    [self addSubview:self.lbMale];
    
    UIImageView* imgMaleView = [[UIImageView alloc] initWithFrame:CGRectMake((self.lbMale.frame.origin.x-25), 5.0f, 30.0f, 30.0f)];
    imgMaleView.image = [SVGKImage imageNamed:@"form-icon-male.svg"].UIImage;
    [self addSubview:imgMaleView];

    
    CALayer *centerGender = [CALayer layer];
    [centerGender setFrame:CGRectMake(self.bounds.size.width/2, 0.0f, 1.0f, self.bounds.size.height)];
    [centerGender setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.layer addSublayer:centerGender];
    
    self.btnFemela = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width/2), 0.0f, self.bounds.size.width/2, self.bounds.size.height)];
    [self.btnFemela setBackgroundColor:[UIColor whiteColor]];
    [self.btnFemela addTarget:self action:@selector(femelaTap1) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnFemela];
    
    
    self.lbFemela=[ [UILabel alloc ] initWithFrame:CGRectMake((self.bounds.size.width/2)+(self.btnFemela.bounds.size.width/2)-15, 0.0f, 100.0f, 40.0f) ];
    [self.lbFemela setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    self.lbFemela.text=@"FEMALE";
    self.lbFemela.font=[helper getFontThin:16.0f];
    [self addSubview:self.lbFemela];
    
    UIImageView* imgFMaleView = [[UIImageView alloc] initWithFrame:CGRectMake((self.lbFemela.frame.origin.x-25), 5.0f, 30.0f, 30.0f)];
    imgFMaleView.image = [SVGKImage imageNamed:@"form-icon-female.svg"].UIImage;
    [self addSubview:imgFMaleView];

    [self chooseGender:num];
    self.numGender=num;
    return self;
}
-(void)chooseGender:(int) num{
    if(num ==1)
    {
        [self.btnMale setBackgroundColor:[UIColor colorWithRed:0/255.0f green:166/255.0f blue:170/255.0f alpha:1.0]];
        [self.lbMale setTextColor:[UIColor whiteColor]];
        [self.btnFemela setBackgroundColor:[UIColor whiteColor]];
        [self.lbFemela setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    }else
    {
        [self.btnFemela setBackgroundColor:[UIColor colorWithRed:0/255.0f green:166/255.0f blue:170/255.0f alpha:1.0]];
        [self.lbFemela setTextColor:[UIColor whiteColor]];
        [self.btnMale setBackgroundColor:[UIColor whiteColor]];
        [self.lbMale setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    }
    self.numGender=num;
}
-(void)maleTap1{
    [self chooseGender:1];
    self.numGender=1;
}
-(void)femelaTap1{
    [self chooseGender:2];
    self.numGender=2;
}

-(NSString*)getGender{
    if(self.numGender==1)
    {
        return @"Male";
    }else
    {
        return @"Female";
    }
}
@end
