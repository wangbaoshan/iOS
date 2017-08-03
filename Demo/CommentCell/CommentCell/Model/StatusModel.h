//
//  StatusModel.h
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatusPhoto;
@class StatusComment;

@interface StatusModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray<StatusPhoto *> *photos;
@property (nonatomic, copy) NSArray<StatusComment *> *comments;

@end


@interface StatusPhoto : NSObject

@property (nonatomic, copy) NSString *imageUrlString;

@end


@interface StatusComment : NSObject

@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *commentDetail;

@property (nonatomic, copy, readonly) NSString *unionComment;

@end
