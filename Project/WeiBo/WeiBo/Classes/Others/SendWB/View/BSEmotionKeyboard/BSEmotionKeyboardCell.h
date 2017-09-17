//
//  BSEmotionKeyboardCell.h
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSEmotionItem;

@interface BSEmotionKeyboardCell : UICollectionViewCell
{
    BSEmotionItem *_item;
}

@property (nonatomic, strong) BSEmotionItem *item;

@end


@interface PTSmallEmotionKeyboardCell : BSEmotionKeyboardCell

@end


@interface BSEmojiEmotionKeyboardCell : BSEmotionKeyboardCell

@end


@interface PTLargeEmotionKeyboardCell : BSEmotionKeyboardCell

@end
