//
//  DIYConst.h
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//  自定义宏

#ifndef DIYConst_h
#define DIYConst_h

// 颜色相关
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define kUIColorRGBA(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define kUIColorRGB(r, g, b) kUIColorRGBA(r, g, b, 1.0)

#define kCSSColorRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kCSSColorRGB(r, g, b) kCSSColorRGBA(r, g, b, 1.0)

#define kCSSHexColor(hexString) [UIColor colorFromHexString:hexString]

// 打印台日志
#ifdef DEBUG
#define STLog(FORMAT, ...) fprintf(stderr,"[文件:%s, 第%d行] : %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define STLog(FORMAT, ...)
#endif

#define STLogMothodFunc STLog(@"%s", __func__)
#define STLogViewFrame(view) STLog(@"%@.frame:%@", NSStringFromClass([view class]),NSStringFromCGRect(view.frame))

// Setting

// NavBar
#define kSystemNavigationBarBackgroundColor kUIColorRGB(1.0, 1.0, 1.0)
#define kSystemNavigationBarLineColor kUIColorRGB(0.84, 0.84, 0.84)
#define kSystemNavigationTitleFont [UIFont boldSystemFontOfSize:18.0]
#define kSystemNavigationItemFont [UIFont systemFontOfSize:16]
#define kSystemNavigationTitleColor kCSSHexColor(@"#333333")
#define kSystemNavigationItemNormalColor kCSSColorRGB(227, 64, 85)
#define kSystemNavigationItemHighlightColor kCSSHexColor(@"#F35D00")
#define kSystemNavigationItemDisableColor kCSSHexColor(@"#BABABA")

// TabBar
#define kSystemTabBarTitleFont [UIFont boldSystemFontOfSize:11.5]
#define kSystemTabBarItemNormalColor kCSSHexColor(@"#4B4746")
#define kSystemTabBarItemSelectedColor kCSSHexColor(@"#4B4746")

#endif /* DIYConst_h */
