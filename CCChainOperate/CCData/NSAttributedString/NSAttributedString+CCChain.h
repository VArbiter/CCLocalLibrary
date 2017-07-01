//
//  NSAttributedString+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (CCChain)

@property (nonatomic , class , copy , readonly) NSMutableAttributedString *(^color)(UIColor *color , NSString *string) ;

@property (nonatomic , copy , readonly) NSMutableAttributedString *(^color)(UIColor *color);
@property (nonatomic , copy , readonly) NSMutableAttributedString *(^operate)(NSMutableAttributedString * (^t)(NSMutableAttributedString * sender)) ;

@end