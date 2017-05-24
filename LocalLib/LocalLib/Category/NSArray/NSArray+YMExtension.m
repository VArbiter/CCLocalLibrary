//
//  NSArray+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSArray+YMExtension.h"

@implementation NSArray (YMExtension)

- (BOOL) ymIsArrayValued {
    if ([self isKindOfClass:[NSArray class]]) {
        if (self.count) {
            return YES;
        }
    }
    return false;
}

- (id) ymValue : (NSInteger) integerIndex {
    if (self) {        
        if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
            if (self.count > integerIndex) {
                return self[integerIndex];
            }
        }
    }
    return nil;
}


@end
