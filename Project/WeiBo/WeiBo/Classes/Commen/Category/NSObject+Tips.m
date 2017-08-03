//
//  NSObject+Tips.m
//  Foomoo
//
//  Created by QFish on 6/6/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "NSObject+Tips.h"
#import "MBProgressHUD.h"

static const char kUIViewMBProgressHUDKey;

@interface UIView (PrivateTips)
@property (nonatomic, strong) MBProgressHUD * mb_hud;
@end

@implementation UIView (PrivateTips)

@dynamic mb_hud;

- (void)setMb_hud:(MBProgressHUD *)mb_hud
{
	objc_setAssociatedObject(self, &kUIViewMBProgressHUDKey, mb_hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)mb_hud
{
	return objc_getAssociatedObject(self, &kUIViewMBProgressHUDKey);
}
	
@end


@implementation UIView (Tips)

- (void)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
	UIView * container = self;
	
	if ( container )
	{
		if ( nil != self.mb_hud )
		{
			[self.mb_hud hide:NO];
		}
		
		UIView * view = self;
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.detailsLabelText = message;
		hud.detailsLabelFont = [UIFont systemFontOfSize:15];
		self.mb_hud = hud;
		
		if ( autoHide )
		{
			[hud hide:YES afterDelay:1.0f];

		}
        else
        {
            [hud hide:YES afterDelay:5.0f];
        }
	}
}

- (void)presentMessageTips:(NSString *)message
{
    [self showTips:message autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
	[self showTips:message autoHide:YES];
}

- (void)presentFailureTips:(NSString *)message
{
	[self showTips:message autoHide:YES];
}

- (void)presentLoadingTips:(NSString *)message
{
    [self presentLoadingTips:message customView:nil];
}

- (void)presentLoadingTips:(NSString *)message
                customView:(UIView *)customView
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != self.mb_hud )
        {
            [self.mb_hud hide:NO];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        hud.customView = customView;
        self.mb_hud = hud;
    }
}

- (void)dismissTips
{
	[self.mb_hud hide:YES];
	self.mb_hud = nil;
}

@end

@implementation UIViewController (Tips)

- (void)presentMessageTips:(NSString *)message
{
	[self.view showTips:message autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
	[self.view showTips:message autoHide:YES];
}

- (void)presentFailureTips:(NSString *)message
{
	[self.view showTips:message autoHide:YES];
}

- (void)presentLoadingTips:(NSString *)message
{
	[self.view presentLoadingTips:message];
}

- (void)presentLoadingTips:(NSString *)message
                customView:(UIView *)customView
{
    [self.view presentLoadingTips:message customView:customView];
}

- (void)dismissTips
{
	[self.view dismissTips];
}

@end
