//
//  StatusModel.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusModel.h"

#import "MJExtension.h"

@implementation StatusModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"photos" : @"StatusPhoto",
             @"comments" : @"StatusComment"
             };
}

@end


@implementation StatusPhoto



@end


@implementation StatusComment

- (NSString *)unionComment
{
    return [NSString stringWithFormat:@"%@: %@", self.commentName, self.commentDetail];
}

@end
