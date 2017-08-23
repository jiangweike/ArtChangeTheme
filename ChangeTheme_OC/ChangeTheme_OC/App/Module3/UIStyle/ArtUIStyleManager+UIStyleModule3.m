//
//  ArtUIStyleManager+UIStyleModule3.m
//  ChangeTheme_OC
//
//  Created by weijingyun on 2017/8/22.
//  Copyright © 2017年 weijingyun. All rights reserved.
//

#import "ArtUIStyleManager+UIStyleModule3.h"
#import "ArtUIStyle.h"

@implementation ArtUIStyleManager (UIStyleModule3)

- (NSString *)getStyleName_Module3 {
    return @"Module3Style.plist";
}

@end


@implementation UIColor (UIStyleModule3)

+ (void)artModule3ForKey:(NSString *)aColorKey strongSelf:(id)strongSelf block:(void(^)(UIColor *color, id weakSelf))aBlock {
    [self artModule:@"Module3" colorForKey:aColorKey strongSelf:strongSelf block:aBlock];
}

@end

@implementation UIFont (UIStyleCourseware)

+ (void)artModule3ForKey:(NSString *)aFontKey block:(id(^)(UIFont *))aBlock {
    [self artModule:@"Module3" fontForKey:aFontKey block:aBlock];
}

@end
