//
//  WBStatusOriginalFrame.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusOriginalFrame.h"

#import "WBStatus.h"
#import "WBUser.h"
#import "WBStatusPhotosView.h"

@implementation WBStatusOriginalFrame

- (void)setStatus:(WBStatus *)status
{
    _status = status;
    
    CGFloat w = kScreenWidth;
    CGFloat h = 0;
    
    CGFloat iconX = kStatusCellInset + 3;
    CGFloat iconY = kStatusCellInset;
    CGFloat iconW = kStatusIconW;
    CGFloat iconH = iconW;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + kStatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [status.user.name sizeWithAttributes:@{NSFontAttributeName:kStatusOrginalNameFont}];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    CGFloat timeX = nameX;
    CGSize timeSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:kStatusOrginalTimeFont}];
    CGFloat timeY = CGRectGetMaxY(self.iconFrame) - timeSize.height;
    self.timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    CGFloat sourceX = CGRectGetMaxX(self.timeFrame) + kStatusCellInset * 0.5;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithAttributes:@{NSFontAttributeName:kStatusOrginalSourceFont}];
    self.sourceFrame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + kStatusCellInset;
    CGFloat maxW = w - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [status.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kStatusOrginalTextFont} context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    
    if (status.pic_urls.count) {
        CGSize photosSize = [WBStatusPhotosView sizeWithMaxWidth:maxW maxCount:status.pic_urls.count margin:kStatusThumbPictureMargin];
        self.photosFrame = (CGRect){{textX, CGRectGetMaxY(self.textFrame) + kStatusCellInset * 0.8}, photosSize};
    } else {
        self.photosFrame = (CGRect){{textX, CGRectGetMaxY(self.textFrame)}, CGSizeZero};
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    h = CGRectGetMaxY(self.photosFrame) + kStatusCellInset;
    
    self.selfFrame = CGRectMake(x, y, w, h);
}

@end
