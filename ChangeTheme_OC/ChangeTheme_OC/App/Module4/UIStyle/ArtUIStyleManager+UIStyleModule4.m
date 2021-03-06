//
//  ArtUIStyleManager+UIStyleModule4.m
//  ChangeTheme_OC
//
//  Created by weijingyun on 2017/8/22.
//  Copyright © 2017年 weijingyun. All rights reserved.
//

#import "ArtUIStyleManager+UIStyleModule4.h"
#import "ArtUIStyle.h"

@implementation ArtUIStyleManager (UIStyleModule4)

- (NSString *)getStyleName_Module4 {
    return @"Module4Style.plist";
}

- (NSString *)getHotReloaderStylePath_Module4 {
    return @"/App/Module4/UIStyle/Module4Style.plist";
}

@end


@implementation UIColor (UIStyleModule4)

+ (UIColor *)artModule4ForKey:(NSString *)aColorKey {
    return [self artModule:@"Module4" colorForKey:aColorKey];
}

+ (void)artModule4ForKey:(NSString *)aColorKey strongSelf:(id)strongSelf block:(void(^)(UIColor *color, id weakSelf))aBlock {
    [self artModule:@"Module4" colorForKey:aColorKey strongSelf:strongSelf block:aBlock];
}

@end

@implementation UIFont (UIStyleModule4)

+ (UIFont *)artModule4ForKey:(NSString *)aFontKey {
    return [self artModule:@"Module4" fontForKey:aFontKey];
}

+ (void)artModule4ForKey:(NSString *)aFontKey strongSelf:(id)strongSelf block:(void(^)(UIFont *font, id weakSelf))aBlock {
    [self artModule:@"Module4" fontForKey:aFontKey strongSelf:strongSelf block:aBlock];
}

@end

@implementation ArtLayoutInfo (UIStyleModule4)

+ (ArtLayoutInfo *)artModule4ForKey:(NSString *)aLayoutKey {
    return [self artModule:@"Module4" layoutForKey:aLayoutKey];
}

+ (void)artModule4ForKey:(NSString *)aLayoutKey strongSelf:(id)strongSelf block:(void(^)(ArtLayoutInfo *layoutInfo, id weakSelf))aBlock {
    [self artModule:@"Module4" layoutForKey:aLayoutKey strongSelf:strongSelf block:aBlock];
}

@end
