//
//  EmotionConst.h
//  CommentCell
//
//  Created by power on 2017/5/27.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#ifndef EmotionConst_h
#define EmotionConst_h

// 表情的最大行数
#define EmotionMaxRows 3
// 表情的最大列数
#define EmotionMaxCols 7
// 每页最多显示多少个表情
#define EmotionMaxCountPerPage (EmotionMaxRows * EmotionMaxCols - 1)

// 颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* EmotionConst_h */
