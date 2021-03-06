//
//  ArtUIStyle.m
//  ChangeTheme_OC
//
//  Created by weijingyun on 2017/8/21.
//  Copyright © 2017年 weijingyun. All rights reserved.
//

#import "ArtUIStyle.h"
#import "ArtUIStyleManager.h"
#import "UIColor+HexColor.h"


#pragma mark - ArtUIStyle

@interface ArtUIStyle ()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSDictionary* style;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) ArtLayoutInfo *layoutInfo;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ArtUIStyle

+ (ArtUIStyle *)styleForKey:(NSString *)aKey
{
    return [[ArtUIStyleManager shared] styleForKey:aKey];
}


- (id)initWithStyle:(NSDictionary *)aStyle
{
    if (self = [super init]) {
        _style = aStyle;
        _cache = [NSCache new];
        _cache.countLimit = 50;
    }
    return self;
}

- (ArtUIStyle *)styleForKey:(NSString *)aKey
{
    NSString *key = [NSString stringWithFormat:@"Style_%@",aKey];
    ArtUIStyle *style = [self.cache objectForKey:key];
    if (style == nil) {
        style = [[ArtUIStyle alloc] initWithStyle:self.style[@"Style"][aKey]];
        [self.cache setObject:style forKey:key];
    }
    return style;
}

- (UIFont *)font
{
    if (!_font) {
        NSNumber *num = [self.style objectForKey:kArtUIStyleFontKey];
        NSAssert(num != nil, @"配置的字体大小不存在请检查");
        _font = [UIFont systemFontOfSize:[num doubleValue]];
    }
    return _font;
}

- (UIColor *)color
{
    if (!_color) {
        NSString *colorStr = [self.style objectForKey:kArtUIStyleColorKey];
        colorStr = [colorStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSAssert(colorStr.length > 0, @"配置的颜色值不存在请检查");
        NSArray<NSString *> *colorArray = [colorStr componentsSeparatedByString:@","];
        NSString *hexStr = colorArray.firstObject;
        CGFloat alpha = 1.0;
        if (colorArray.count == 2) {
            alpha = [colorArray.lastObject doubleValue];
        }
        _color = [UIColor art_colorWithHexString:hexStr alpha:alpha];
        
    }
    return [_color copy];
}

- (ArtLayoutInfo *)layoutInfo {
    
    if (!_layoutInfo) {
        NSAssert(self.style.count > 0, @"不存在该配置请检查");
        ArtLayoutInfo *info = [ArtLayoutInfo new];
        [info setValuesForKeysWithDictionary:self.style];
        _layoutInfo = info;
    }
    return _layoutInfo;
}


- (UIImage *)imageForString:(NSString *)aImageString
{
    NSString *key = [NSString stringWithFormat:@"Image_%@",aImageString];
    ArtUIStyle *style = [self.cache objectForKey:key];
    if (style == nil) {
        style = [[ArtUIStyle alloc] initWithStyle:self.style[@"Image"]];
        [style saveImageString:aImageString];
        [self.cache setObject:style forKey:key];
    }
    return [style.image copy];
}

- (void)saveImageString:(NSString *)aImageString {
    
    ArtUIStyleManager *manager = [ArtUIStyleManager shared];
    NSString *toPath = self.style[@"toPath"];
    switch (manager.styleType) {
        case EArtUIStyleTypeDefault:
        {
             self.image = [UIImage imageNamed:aImageString];
        }
            break;
            
        case EArtUIStyleTypeBundle:
        {
            self.image =
            [self findImageForImageString:aImageString block:^NSString *(NSString *path) {
                return [[NSBundle bundleWithPath:manager.stylePath] pathForResource:path ofType:@"png" inDirectory:toPath];
            }];
            
        }
            break;
            
        case EArtUIStyleTypeStylePath:
        {
            self.image =
            [self findImageForImageString:aImageString block:^NSString *(NSString *path) {
                NSString *filePath = [[manager.stylePath stringByAppendingPathComponent:toPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",path]];
                return filePath;
            }];
        }
            break;
            
        default:
            break;
    }
}

- (UIImage *)findImageForImageString:(NSString *)aImageString block:(NSString *(^)(NSString * path))aBlock {
    NSMutableArray *arrayM = [NSMutableArray new];
    for (int i = 1; i <= 3; i ++) {
        [arrayM addObject:@(i)];
    }
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    [arrayM removeObject:@(scale)];
    [arrayM insertObject:@(scale) atIndex:0];
    
    __block UIImage *image = nil;
    [arrayM enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger scale = obj.integerValue;
        NSString *imageStr = aImageString;
        if (scale != 1) {
            imageStr = [NSString stringWithFormat:@"%@@%tux",aImageString,scale];
        }
        NSString *imagePath = aBlock(imageStr);
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            *stop = YES;
        }
    }];
    if (image == nil) {
        NSAssert(NO, @"未在资源中找到可用的图");
        image = [UIImage imageNamed:aImageString];
    }
    return image;
}

@end

@implementation UIColor (ArtUIStyleApp)

+ (UIColor *)artModule:(NSString *)aModule colorForKey:(NSString *)aColorKey {
    return [[[ArtUIStyle styleForKey:aModule] styleForKey:aColorKey] color];
}

+ (void)artModule:(NSString *)aModule colorForKey:(NSString *)aColorKey strongSelf:(id)strongSelf block:(void(^)(UIColor *color, id weakSelf))aBlock {
    if (strongSelf) {
        [[ArtUIStyleManager shared] saveStrongSelf:strongSelf block:^(id weakSelf) {
            UIColor *color = [self artModule:aModule colorForKey:aColorKey];
            aBlock(color,weakSelf);
        }];
    }
}

@end

@implementation UIFont (ArtUIStyleApp)

+ (UIFont *)artModule:(NSString *)aModule fontForKey:(NSString *)aFontKey {
    return [[[ArtUIStyle styleForKey:aModule] styleForKey:aFontKey] font];
}

+ (void)artModule:(NSString *)aModule fontForKey:(NSString *)aFontKey strongSelf:(id)strongSelf block:(void(^)(UIFont *font, id weakSelf))aBlock {

    if (strongSelf) {
        [[ArtUIStyleManager shared] saveStrongSelf:strongSelf block:^(id weakSelf) {
            UIFont *font = [self artModule:aModule fontForKey:aFontKey];
            aBlock(font,weakSelf);
        }];
    }
}

@end


@implementation ArtLayoutInfo (ArtUIStyleApp)

+ (ArtLayoutInfo *)artModule:(NSString *)aModule layoutForKey:(NSString *)aLayoutKey {
    return [[[ArtUIStyle styleForKey:aModule] styleForKey:aLayoutKey] layoutInfo];
}

+ (void)artModule:(NSString *)aModule layoutForKey:(NSString *)aLayoutKey strongSelf:(id)strongSelf block:(void(^)(ArtLayoutInfo *layoutInfo, id weakSelf))aBlock {
    
    if (strongSelf) {
        [[ArtUIStyleManager shared] saveStrongSelf:strongSelf block:^(id weakSelf) {
            ArtLayoutInfo *layoutInfo = [self artModule:aModule layoutForKey:aLayoutKey];
            aBlock(layoutInfo,weakSelf);
        }];
    }
}

@end


@implementation UIImage (ArtUIStyleApp)

+ (UIImage *)artModule:(NSString *)aModule imageString:(NSString *)aImageString {
    return [[ArtUIStyle styleForKey:aModule] imageForString:aImageString];
}

+ (void)artModule:(NSString *)aModule imageString:(NSString *)aImageString strongSelf:(id)strongSelf block:(void(^)(UIImage *image, id weakSelf))aBlock {
    
    if (strongSelf) {
        [[ArtUIStyleManager shared] saveStrongSelf:strongSelf block:^(id weakSelf) {
            UIImage *image = [self artModule:aModule imageString:aImageString];
            aBlock(image,weakSelf);
        }];
    }
}

@end
