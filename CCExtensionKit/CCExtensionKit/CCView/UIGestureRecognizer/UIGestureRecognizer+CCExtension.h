//
//  UIGestureRecognizer+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (CCExtension)

+ (instancetype) common ;

- (instancetype) ccAction : (void(^)( __kindof UIGestureRecognizer *gr)) action ;
- (instancetype) ccTarget : (id) target
                   action : (void(^)( __kindof UIGestureRecognizer *gr)) action ;

@end

#pragma mark - -----

@interface UITapGestureRecognizer (CCExtension)

/// default 1 tap
- (instancetype) ccTap : (void(^)(UITapGestureRecognizer *tapGR)) action ;
- (instancetype) ccTap : (NSInteger) iCount
                action : (void(^)(UITapGestureRecognizer *tapGR)) action ;

@end

#pragma mark - -----

@interface UILongPressGestureRecognizer (CCExtension)

/// default .5f seconds
- (instancetype) ccPress : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;
- (instancetype) ccPress : (CGFloat) fSeconds
                  action : (void(^)(UILongPressGestureRecognizer *pressGR)) action ;

@end
