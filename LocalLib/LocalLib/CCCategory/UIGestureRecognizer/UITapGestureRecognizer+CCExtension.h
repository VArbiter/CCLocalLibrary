//
//  UITapGestureRecognizer+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer (CCExtension)

- (instancetype) initWithActionBlock : (dispatch_block_t) blockClick ;
- (instancetype) initWithTaps : (NSInteger) integerTaps
              withActionBlock : (dispatch_block_t) blockClick;


@end