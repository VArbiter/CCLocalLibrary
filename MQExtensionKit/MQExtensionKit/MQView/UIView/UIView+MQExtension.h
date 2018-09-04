//
//  UIView+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const _MQ_DEFAULT_ANIMATION_COMMON_DURATION_;

typedef struct CG_BOXABLE CGPoint MQPoint;
MQPoint MQPointMake(CGFloat x , CGFloat y);
MQPoint MQMakePointFrom(CGPoint point);
CGPoint CGMakePointFrom(MQPoint point);

typedef struct CG_BOXABLE CGSize MQSize;
MQSize MQSizeMake(CGFloat width , CGFloat height);
MQSize MQMakeSizeFrom(CGSize size);
CGSize CGMakeSizeFrom(MQSize size);

typedef struct CG_BOXABLE CGRect MQRect;
MQRect MQRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
MQRect MQMakeRectFrom(CGRect rect);
CGRect CGMakeRectFrom(MQRect rect);

CGRect CGRectFull(void); // main screen bounds . // 等于屏幕的边界

typedef struct CG_BOXABLE UIEdgeInsets MQEdgeInsets;
MQEdgeInsets MQEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
MQEdgeInsets MQMakeEdgeInsetsFrom(UIEdgeInsets insets);
UIEdgeInsets UIMakeEdgeInsetsFrom(MQEdgeInsets insets);

/// scaled width && height (based on main screen's width && height resolution) // 按比例缩放后的 宽/高 (基于屏幕宽和高的分辨率)
CGFloat MQScaleW(CGFloat w);
CGFloat MQScaleH(CGFloat h);

/// aspect fit the width && height . (based on main screen's width resolution) // 按照特定比例缩放后的 宽 / 高 (基于屏幕宽的分辨率)
CGFloat MQAspectRatio(void);
CGFloat MQAspectW(CGFloat w);
CGFloat MQAspectH(CGFloat h);

/// length scale // 计算 宽/高 所占屏幕比例
CGFloat MQWScale(CGFloat w);
CGFloat MQHScale(CGFloat h);
CGPoint MQScaleOrigin(CGPoint origin);
CGSize MQScaleSize(CGSize size);

@interface UIView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame ;

/// for some designer use basic UI that is not for iPhone 6/6s/7/8 // 针对于一些设计人员基于 iPhone 6/6s/7/8 所设计的尺寸
/// set H && W only once in somewhere for "+ (void) load" // 设置基准 宽 && 高 , 在 "+ (void) load "设置里调用一次即可
+ (void) mq_set_scale : (CGFloat) fWidth
               height : (CGFloat) fHeight ;

+ (void) mq_disable_animation : (void (^)(void)) action ;

@property (nonatomic , class , assign , readonly) CGFloat f_width;
@property (nonatomic , class , assign , readonly) CGFloat f_height;

@property (nonatomic , assign) CGSize size;
@property (nonatomic , assign) CGPoint origin;

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;

@property (nonatomic , assign) CGFloat center_x;
@property (nonatomic , assign) CGFloat center_y;

@property (nonatomic , assign , readonly) CGFloat in_center_x ;
@property (nonatomic , assign , readonly) CGFloat in_center_y ;
@property (nonatomic , assign , readonly) CGPoint in_center ;

@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat right;

@property (nonatomic , assign , readonly) CGFloat in_top;
@property (nonatomic , assign , readonly) CGFloat in_left;
@property (nonatomic , assign , readonly) CGFloat in_bottom;
@property (nonatomic , assign , readonly) CGFloat in_right;

/// an easy way to margin // 一个方便的方式进行校准
- (instancetype) mq_frame : (CGRect) frame ;
- (instancetype) mq_size : (CGSize) size ;
- (instancetype) mq_origin : (CGPoint) point ;

- (instancetype) mq_width : (CGFloat) f_width ;
- (instancetype) mq_height : (CGFloat) f_height ;

- (instancetype) mq_x : (CGFloat) f_x ;
- (instancetype) mq_y : (CGFloat) f_y ;

- (instancetype) mq_center_x : (CGFloat) f_center_x ;
- (instancetype) mq_center_y : (CGFloat) f_center_y ;
- (instancetype) mq_center : (CGPoint) p_center ;

- (instancetype) mq_top : (CGFloat) f_top ;
- (instancetype) mq_left : (CGFloat) f_left ;
- (instancetype) mq_bottom : (CGFloat) f_bottom ;
- (instancetype) mq_right : (CGFloat) f_right ;

/// for xibs // 针对 xib 的
+ (instancetype) mq_from_xib ;
+ (instancetype) mq_from_xib : (Class) cls ;
+ (instancetype) mq_from_xib_b : (NSBundle *) bundle;

/// add && remove (return itself) // 添加和移除 , 返回他本省
- (instancetype) mq_add : (__kindof UIView *) view ;
- (void) mq_remove_from : (void (^)(__kindof UIView *viewSuper)) action ;
- (instancetype) mq_bring_to_front : (__kindof UIView *) view ;
- (instancetype) mq_send_to_back : (__kindof UIView *) view ;
- (instancetype) mq_make_to_front ;
- (instancetype) mq_make_to_back ;

/// enable / disable userinteraction // 启用 / 禁用用户交互
- (instancetype) mq_enable ;
- (instancetype) mq_disable ;

/// color && cornerRadius && contentMode // 颜色 / 圆角 / 包裹模式
- (instancetype) mq_color : (UIColor *) color ;
- (instancetype) mq_radius : (CGFloat) f_radius
                     masks : (BOOL) is_mask ;
- (instancetype) mq_round_corner : (UIRectCorner) corners
                          radius : (CGFloat) f_radius ;
- (instancetype) mq_content_mode : (UIViewContentMode) mode ;

/// copy it self . // 复制自身
- (instancetype) mq_duplicate ;

/// find its absolute location in screen . // 找到 view 在屏幕中的绝对位置 
- (CGRect) mq_location_in_window ;

- (UIImage *) mq_capture_image_after_screen_updates : (BOOL) is_after_updates ;

@end

#pragma mark - -----

@interface UIView (MQExtension_Delay_Operate)

/// make user interaction disable for a certain time . // 使得用户交互在特定的时间内禁止
// using dispatch_after . // 使用 dispatch_after
- (instancetype) mq_cold : (NSTimeInterval) interval ;

/// make user interaction enable for a certain time . // 使得用户交互在特定的时间内允许
// using dispatch_after . // 使用 dispatch_after
- (instancetype) mq_hot : (NSTimeInterval) interval ;

- (instancetype) mq_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) mq_complete_block ;


@end
