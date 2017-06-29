//
//  NSArray+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/19.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CCExtension)

@property (nonatomic , readonly , copy) id(^valueAt)(NSInteger index) ;

- (id) ccValue : (NSInteger) index ;

@end
