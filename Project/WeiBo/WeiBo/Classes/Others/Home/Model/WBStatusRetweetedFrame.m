//
//  WBStatusRetweetedFrame.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusRetweetedFrame.h"

#import "WBStatus.h"
#import "WBStatusPhotosView.h"

@implementation WBStatusRetweetedFrame

- (void)setRetweetedStatus:(WBStatus *)retweetedStatus
{
    _retweetedStatus = retweetedStatus;
    
    CGFloat w = kScreenWidth;
    
    CGFloat textX = kStatusCellInset + 3;
    CGFloat textY = kStatusCellInset;
    CGFloat maxW = w - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [retweetedStatus.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kStatusRetweetedTextFont} context:nil].size;
    self.retweetTextFrame = (CGRect){{textX, textY}, textSize};
    
    if (retweetedStatus.pic_urls.count) {
        CGSize photosSize = [WBStatusPhotosView sizeWithMaxWidth:maxW maxCount:retweetedStatus.pic_urls.count margin:kStatusThumbPictureMargin];
        self.photosFrame = (CGRect){{textX, CGRectGetMaxY(self.retweetTextFrame) + kStatusCellInset * 0.5}, photosSize};
    } else {
        self.photosFrame = (CGRect){{textX, CGRectGetMaxY(self.retweetTextFrame)}, CGSizeZero};
    }
    
    self.selfFrame = CGRectMake(0, 0, w, CGRectGetMaxY(self.photosFrame) + textY);
}

@end
