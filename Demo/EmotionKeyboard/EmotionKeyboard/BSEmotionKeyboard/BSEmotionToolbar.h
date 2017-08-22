//
//  BSEmotionToolbar.h
//  CommentCell
//
//  Created by power on 2017/6/5.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTToolbarItem;
@class BSEmotionToolbar;

@protocol BSEmotionToolbarDelegate <NSObject>
@optional
- (void)emotionToolbar:(BSEmotionToolbar *)toolbar didSelectIndex:(NSInteger)index;

@end

@interface BSEmotionToolbar : UIView

+ (__kindof BSEmotionToolbar *)toolbar;

- (void)addToolbarItem:(PTToolbarItem *)toolbarItem;
- (void)removeAllToolbarItems;
- (void)insertToolbarItem:(PTToolbarItem *)toolbarItem atIndex:(NSInteger)index;
- (void)selectToolbarItemAtIndex:(NSInteger)index;
- (void)removeToolbarItemAtIndex:(NSInteger)index;

@property (nonatomic, weak) id<BSEmotionToolbarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
