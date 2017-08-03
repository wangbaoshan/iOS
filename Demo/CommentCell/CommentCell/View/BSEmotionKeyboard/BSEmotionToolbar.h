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
- (void)emotionToolbarDidClickAddItem:(BSEmotionToolbar *)toolbar;
- (void)emotionToolbarDidClickSettingItem:(BSEmotionToolbar *)toolbar;
@end

@interface BSEmotionToolbar : UIView

+ (__kindof BSEmotionToolbar *)toolbar;
- (void)addToolbarItem:(PTToolbarItem *)toolbarItem;
- (void)removeAllItems;
- (void)selectItemWithIndex:(NSInteger)index;

@property (nonatomic, weak) id<BSEmotionToolbarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
