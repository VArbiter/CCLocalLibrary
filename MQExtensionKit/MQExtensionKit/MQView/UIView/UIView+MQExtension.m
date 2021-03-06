//
//  UIView+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIView+MQExtension.h"

static CGFloat MQ_DEFAULT_SCALE_WIDTH = 750.f;
static CGFloat MQ_DEFAULT_SCALE_HEIGHT = 1334.f;
CGFloat const mq_default_animation_common_duration = .3f;

void mq_set_UI_designed_default_size(CGSize size) {
    MQ_DEFAULT_SCALE_WIDTH = size.width;
    MQ_DEFAULT_SCALE_HEIGHT = size.height;
}

#pragma mark - ----- ###########################################################

/// internal functions

UIDeviceOrientation mq_internal_current_device_orientation(BOOL is_portrait , BOOL is_use_status_bar_orientation) {
    if (is_portrait) return UIDeviceOrientationPortrait;
    if (is_use_status_bar_orientation) {
        UIDeviceOrientation orientation = ((UIDeviceOrientation)UIApplication.sharedApplication.statusBarOrientation);
        return orientation;
    }
    else {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        return orientation;
    }
}

MQPoint mq_internal_pointer_make_precise(BOOL is_portrait , CGFloat x , CGFloat y) {
    MQPoint o;
    
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(is_portrait, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        o.x = x / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
        o.y = y / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
    }
    else {
        o.x = x / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.height;
        o.y = y / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.width;
    }
    
    return o;
}

MQSize  mq_internal_size_make_precise(BOOL is_portrait , CGFloat width , CGFloat height) {
    MQSize s;
    
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(is_portrait, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        s.width = width / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
        s.height = height / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
    }
    else {
        s.width = width / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.height;
        s.height = height / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.width;
    }
    
    return s;
}

MQRect mq_internal_rect_make_precise(BOOL is_portrait , CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    MQRect r;
    r.origin = mq_internal_pointer_make_precise(is_portrait, x, y);
    r.size = mq_internal_size_make_precise(is_portrait, width, height);
    return r;
}

MQEdgeInsets mq_internal_edge_insets_make_precise(BOOL is_portrait , CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    MQEdgeInsets i;
    
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(is_portrait, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        i.top = top / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
        i.left = left / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
        i.bottom = bottom / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
        i.right = right / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
    }
    else {
        i.top = top / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.width;
        i.left = left / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.height;
        i.bottom = bottom / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.width;
        i.right = right / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.height;
    }
    
    return i;
}

#pragma mark - ----- ###########################################################
#pragma mark - Struct

MQPoint MQPointMake_Precise(CGFloat x , CGFloat y) {
    return mq_internal_pointer_make_precise(YES, x, y);
}
MQPoint MQPointMake(CGFloat x , CGFloat y) {
    MQPoint o = MQPointMake_Precise(x, y);
    if (CGFLOAT_IS_DOUBLE) {
        o = (MQPoint){ceil(o.x),ceil(o.y)};
    }
    else o = (MQPoint){ceilf(o.x),ceilf(o.y)};
    return o;
}
MQPoint MQMakePointFrom(CGPoint point) {
    return MQPointMake(point.x, point.y);
}

MQPoint MQPointMake_Precise_o(CGFloat x , CGFloat y) {
    return mq_internal_pointer_make_precise(false, x, y);
}
MQPoint MQPointMake_o(CGFloat x , CGFloat y) {
    MQPoint o = MQPointMake_Precise_o(x, y);
    if (CGFLOAT_IS_DOUBLE) {
        o = (MQPoint){ceil(o.x),ceil(o.y)};
    }
    else o = (MQPoint){ceilf(o.x),ceilf(o.y)};
    return o;
}
MQPoint MQMakePointFrom_o(CGPoint point) {
    return MQPointMake_o(point.x, point.y);
}

CGPoint CGMakePointFrom(MQPoint point) {
    return CGPointMake(point.x, point.y);
}

#pragma mark - -----

MQSize MQSizeMake_Precise(CGFloat width , CGFloat height) {
    return mq_internal_size_make_precise(YES, width, height);
}
MQSize MQSizeMake(CGFloat width , CGFloat height) {
    MQSize s = MQSizeMake_Precise(width, height);
    if (CGFLOAT_IS_DOUBLE) {
        s = (MQSize){ceil(s.width),ceil(s.height)};
    }
    else s = (MQSize){ceilf(s.width),ceilf(s.height)};
    return s;
}
MQSize MQMakeSizeFrom(CGSize size) {
    return MQSizeMake(size.width, size.height);
}

MQSize MQSizeMake_Precise_o(CGFloat width , CGFloat height) {
    return mq_internal_size_make_precise(false, width, height);
}
MQSize MQSizeMake_o(CGFloat width , CGFloat height) {
    MQSize s = MQSizeMake_Precise_o(width, height);
    if (CGFLOAT_IS_DOUBLE) {
        s = (MQSize){ceil(s.width),ceil(s.height)};
    }
    else s = (MQSize){ceilf(s.width),ceilf(s.height)};
    return s;
}
MQSize MQMakeSizeFrom_o(CGSize size) {
    return MQSizeMake_o(size.width, size.height);
}

CGSize CGMakeSizeFrom(MQSize size) {
    return CGSizeMake(size.width, size.height);
}

#pragma mark - -----

MQRect MQRectMake_Precise(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    return mq_internal_rect_make_precise(YES, x, y, width, height);
}
MQRect MQRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    MQRect r = MQRectMake_Precise(x, y, width, height);
    if (CGFLOAT_IS_DOUBLE) {
        r = (MQRect){.origin = {ceil(r.origin.x),ceil(r.origin.y)},
            .size = {ceil(r.size.width),ceil(r.size.height)}};
    }
    else {
        r = (MQRect){.origin = {ceilf(r.origin.x),ceilf(r.origin.y)},
            .size = {ceilf(r.size.width),ceilf(r.size.height)}};
    }
    return r;
}
MQRect MQMakeRectFrom(CGRect rect) {
    return MQRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

MQRect MQRectMake_Precise_o(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    return mq_internal_rect_make_precise(false, x, y, width, height);
}
MQRect MQRectMake_o(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    MQRect r = MQRectMake_Precise_o(x, y, width, height);
    if (CGFLOAT_IS_DOUBLE) {
        r = (MQRect){.origin = {ceil(r.origin.x),ceil(r.origin.y)},
            .size = {ceil(r.size.width),ceil(r.size.height)}};
    }
    else {
        r = (MQRect){.origin = {ceilf(r.origin.x),ceilf(r.origin.y)},
            .size = {ceilf(r.size.width),ceilf(r.size.height)}};
    }
    return r;
}
MQRect MQMakeRectFrom_o(CGRect rect) {
    return MQRectMake_o(rect.origin.x,
                        rect.origin.y,
                        rect.size.width,
                        rect.size.height);
}

CGRect CGMakeRectFrom(MQRect rect) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

CGRect CGRectFull(void){
    return UIScreen.mainScreen.bounds;
}

#pragma mark - -----

MQEdgeInsets MQEdgeInsetsMake_Precise(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    return mq_internal_edge_insets_make_precise(YES, top, left, bottom, right);
}
MQEdgeInsets MQEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    MQEdgeInsets i = MQEdgeInsetsMake_Precise(top, left, bottom, right);
    
    if (CGFLOAT_IS_DOUBLE) {
        i = (MQEdgeInsets){ceil(i.top),ceil(i.left),ceil(i.bottom),ceil(i.right)};
    }
    else i = (MQEdgeInsets){ceilf(i.top),ceilf(i.left),ceilf(i.bottom),ceilf(i.right)};
    
    return i;
}
MQEdgeInsets MQMakeEdgeInsetsFrom(UIEdgeInsets insets) {
    return MQEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}

MQEdgeInsets MQEdgeInsetsMake_Precise_o(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    return mq_internal_edge_insets_make_precise(false, top, left, bottom, right);
}
MQEdgeInsets MQEdgeInsetsMake_o(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    MQEdgeInsets i = MQEdgeInsetsMake_Precise_o(top, left, bottom, right);
    
    if (CGFLOAT_IS_DOUBLE) {
        i = (MQEdgeInsets){ceil(i.top),ceil(i.left),ceil(i.bottom),ceil(i.right)};
    }
    else i = (MQEdgeInsets){ceilf(i.top),ceilf(i.left),ceilf(i.bottom),ceilf(i.right)};
    
    return i;
}
MQEdgeInsets MQMakeEdgeInsetsFrom_o(UIEdgeInsets insets) {
    return MQEdgeInsetsMake_o(insets.top,
                              insets.left,
                              insets.bottom,
                              insets.right);
}

UIEdgeInsets UIMakeEdgeInsetsFrom(MQEdgeInsets insets) {
    return UIEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}

#pragma mark - ----- Scale

CGFloat MQScaleW_Precise(CGFloat w) {
    return w / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
}
CGFloat MQScaleW(CGFloat w) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQScaleW_Precise(w));
    }
    return ceilf(MQScaleW_Precise(w));
}
CGFloat MQScaleH_Precise(CGFloat h) {
    return h / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
}
CGFloat MQScaleH(CGFloat h) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQScaleH_Precise(h));
    }
    return ceilf(MQScaleH_Precise(h));
}

CGFloat MQScaleW_Precise_o(CGFloat w) {
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(false, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return w / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.width;
    }
    else return w / MQ_DEFAULT_SCALE_WIDTH * UIScreen.mainScreen.bounds.size.height;
}
CGFloat MQScaleW_o(CGFloat w) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQScaleW_Precise_o(w));
    }
    return ceilf(MQScaleW_Precise_o(w));
}
CGFloat MQScaleH_Precise_o(CGFloat h) {
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(false, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return h / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.height;
    }
    else return h / MQ_DEFAULT_SCALE_HEIGHT * UIScreen.mainScreen.bounds.size.width;
}
CGFloat MQScaleH_o(CGFloat h) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQScaleH_Precise_o(h));
    }
    return ceilf(MQScaleH_Precise_o(h));
}

#pragma mark - -----

CGFloat MQAspectRatio(void) {
    return UIScreen.mainScreen.bounds.size.width / MQ_DEFAULT_SCALE_WIDTH ;
}
CGFloat MQAspectW_Precise(CGFloat w) {
    return w * MQAspectRatio();
}
CGFloat MQAspectW(CGFloat w) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQAspectW_Precise(w));
    }
    return ceilf(MQAspectW_Precise(w));
}
CGFloat MQAspectH_Precise(CGFloat h) {
    return h * MQAspectRatio();
}
CGFloat MQAspectH(CGFloat h) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQAspectH_Precise(h));
    }
    return ceilf(MQAspectH_Precise(h));
}

CGFloat MQAspectRatio_o(void) {
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(false, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return UIScreen.mainScreen.bounds.size.width / MQ_DEFAULT_SCALE_WIDTH ;
    }
    else return UIScreen.mainScreen.bounds.size.height / MQ_DEFAULT_SCALE_HEIGHT ;
}
CGFloat MQAspectW_Precise_o(CGFloat w) {
    return w * MQAspectRatio_o();
}
CGFloat MQAspectW_o(CGFloat w) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQAspectW_Precise_o(w));
    }
    return ceilf(MQAspectW_Precise_o(w));
}
CGFloat MQAspectH_Precise_o(CGFloat h) {
    return h * MQAspectRatio_o();
}
CGFloat MQAspectH_o(CGFloat h) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(MQAspectH_Precise_o(h));
    }
    return ceilf(MQAspectH_Precise_o(h));
}

#pragma mark - -----

CGFloat MQWScale(CGFloat w) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(w / MQ_DEFAULT_SCALE_WIDTH);
    }
    return ceilf(w / MQ_DEFAULT_SCALE_WIDTH);
}
CGFloat MQHScale(CGFloat h) {
    if (CGFLOAT_IS_DOUBLE) {
        return ceil(h / MQ_DEFAULT_SCALE_HEIGHT);
    }
    return ceilf(h / MQ_DEFAULT_SCALE_HEIGHT);
}
CGPoint MQScaleOrigin(CGPoint origin) {
    return CGPointMake(MQScaleW(origin.x), MQScaleH(origin.y));
}
CGSize MQScaleSize(CGSize size) {
    return CGSizeMake(MQScaleW(size.width), MQScaleH(size.height));
}

CGFloat MQWScale_o(CGFloat w) {
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(false, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        if (CGFLOAT_IS_DOUBLE) {
            return ceil(w / MQ_DEFAULT_SCALE_WIDTH);
        }
        return ceilf(w / MQ_DEFAULT_SCALE_WIDTH);
    }
    else {
        if (CGFLOAT_IS_DOUBLE) {
            return ceil(w / MQ_DEFAULT_SCALE_HEIGHT);
        }
        return ceilf(w / MQ_DEFAULT_SCALE_HEIGHT);
    }
}
CGFloat MQHScale_o(CGFloat h) {
    UIDeviceOrientation orientation = mq_internal_current_device_orientation(false, YES);
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        if (CGFLOAT_IS_DOUBLE) {
            return ceil(h / MQ_DEFAULT_SCALE_HEIGHT);
        }
        return ceilf(h / MQ_DEFAULT_SCALE_HEIGHT);
    }
    else {
        if (CGFLOAT_IS_DOUBLE) {
            return ceil(h / MQ_DEFAULT_SCALE_WIDTH);
        }
        return ceilf(h / MQ_DEFAULT_SCALE_WIDTH);
    }
}
CGPoint MQScaleOrigin_o(CGPoint origin) {
    return CGPointMake(MQScaleW_o(origin.x), MQScaleH_o(origin.y));
}
CGSize MQScaleSize_o(CGSize size) {
    return CGSizeMake(MQScaleW_o(size.width), MQScaleH_o(size.height));
}

#pragma mark - -----

UIDeviceOrientation mq_current_device_orientation(BOOL is_use_status_bar_orientation) {
    return mq_internal_current_device_orientation(false, is_use_status_bar_orientation);
}

#pragma mark - ----- ###########################################################

@implementation UIView (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    CGRect g = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    return [[self alloc] initWithFrame:g];
}

+ (void) mq_disable_animation : (void (^)(void)) action {
    if (action) {
        [UIView setAnimationsEnabled:false];
        action();
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma mark - Setter && Getter
- (void) setMq_size:(CGSize)mq_size {
    CGRect frame = self.frame;
    frame.size = mq_size;
    self.frame = frame;
}
- (CGSize) mq_size {
    return self.frame.size;
}

- (void)setMq_origin:(CGPoint)mq_origin {
    CGRect frame = self.frame;
    frame.origin = mq_origin;
    self.frame = frame;
}
- (CGPoint) mq_origin {
    return self.frame.origin;
}

-(void)setMq_width:(CGFloat)mq_width{
    CGRect frame = self.frame;
    frame.size.width = mq_width;
    self.frame = frame;
}
- (CGFloat) mq_width {
    return self.frame.size.width;
}

- (void) setMq_height:(CGFloat)mq_height {
    CGRect frame = self.frame;
    frame.size.height = mq_height;
    self.frame = frame;
}
- (CGFloat) mq_height {
    return self.frame.size.height;
}

- (void) setMq_x:(CGFloat)mq_x{
    CGRect frame = self.frame;
    frame.origin.x = mq_x;
    self.frame = frame;
}
- (CGFloat) mq_x {
    return self.frame.origin.x;
}

- (void) setMq_y:(CGFloat)mq_y {
    CGRect frame = self.frame;
    frame.origin.y = mq_y;
    self.frame = frame;
}
- (CGFloat) mq_y {
    return self.frame.origin.y;
}

- (void)setMq_center_x:(CGFloat)mq_center_x {
    self.center = CGPointMake(mq_center_x, self.center.y);
}
- (CGFloat) mq_center_x {
    return self.center.x;
}

- (void)setMq_center_y:(CGFloat)mq_center_y {
    self.center = CGPointMake(self.center.x, mq_center_y);
}
- (CGFloat)mq_center_y {
    return self.center.y;
}

- (void)setMq_top:(CGFloat)mq_top {
    CGRect frame = self.frame;
    frame.origin.y = mq_top;
    self.frame = frame;
}
- (CGFloat)mq_top {
    return self.frame.origin.y;
}

- (void)setMq_left:(CGFloat)mq_left {
    CGRect frame = self.frame;
    frame.origin.x = mq_left;
    self.frame = frame;
}
- (CGFloat) mq_left {
    return self.frame.origin.x;
}

- (void)setMq_bottom:(CGFloat)mq_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mq_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat) mq_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMq_right:(CGFloat)mq_right {
    CGRect frame = self.frame;
    frame.origin.x = mq_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat) mq_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat) mq_in_top {
    return .0f;
}
- (CGFloat) mq_in_left {
    return .0f;
}
- (CGFloat) mq_in_bottom {
    return self.frame.size.height;
}
- (CGFloat) mq_in_right {
    return self.frame.size.width;
}

#pragma mark - -----
+ (CGFloat) mq_width {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat) mq_height {
    return UIScreen.mainScreen.bounds.size.height;
}

- (CGFloat) mq_in_center_x {
    return self.frame.size.width * .5f;
}
- (CGFloat) mq_in_center_y {
    return self.frame.size.height * .5f;
}
- (CGPoint) mq_in_center{
    return CGPointMake(self.mq_in_center_x, self.mq_in_center_y);
}

- (instancetype) mq_frame : (CGRect) frame {
    self.frame = frame;
    return self;
}
- (instancetype) mq_size : (CGSize) size {
    self.mq_size = size;
    return self;
}
- (instancetype) mq_origin : (CGPoint) point {
    self.mq_origin = point;
    return self;
}

- (instancetype) mq_width : (CGFloat) f_width {
    self.mq_width = f_width;
    return self;
}
- (instancetype) mq_height : (CGFloat) f_height {
    self.mq_height = f_height;
    return self;
}

- (instancetype) mq_x : (CGFloat) f_x {
    self.mq_x = f_x;
    return self;
}
- (instancetype) mq_y : (CGFloat) f_y {
    self.mq_y = f_y;
    return self;
}

- (instancetype) mq_center_x : (CGFloat) f_center_x {
    self.mq_center_x = f_center_x;
    return self;
}
- (instancetype) mq_center_y : (CGFloat) f_center_y {
    self.mq_center_y = f_center_y;
    return self;
}
- (instancetype) mq_center : (CGPoint) p_center {
    self.center = p_center;
    return self;
}

- (instancetype) mq_top : (CGFloat) f_top {
    self.mq_top = f_top;
    return self;
}
- (instancetype) mq_left : (CGFloat) f_left {
    self.mq_left = f_left;
    return self;
}
- (instancetype) mq_bottom : (CGFloat) f_bottom {
    self.mq_bottom = f_bottom;
    return self;
}
- (instancetype) mq_right : (CGFloat) f_right {
    self.mq_right = f_right;
    return self;
}

/// for xibs
+ (instancetype) mq_from_xib {
    return [self mq_from_xib_b:nil];
}
+ (instancetype) mq_from_xib : (Class) cls {
    
    return [self mq_from_xib_b:[NSBundle bundleForClass:cls]];
}
+ (instancetype) mq_from_xib_b : (NSBundle *) bundle {
    if (!bundle) bundle = NSBundle.mainBundle;
    return [[bundle loadNibNamed:NSStringFromClass(self)
                           owner:nil
                         options:nil] firstObject];
}

/// add && remove (return itself)
- (instancetype) mq_add : (__kindof UIView *) view {
    if (view) [self addSubview:view];
    return self;
}
- (void)mq_remove_from : (void (^)(__kindof UIView *)) action {
    if (action) action(self.superview);
    if (self.superview) [self removeFromSuperview];
}
- (instancetype) mq_bring_to_front : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self bringSubviewToFront:view];
    return self;
}
- (instancetype) mq_send_to_back : (__kindof UIView *) view {
    if (view && [self.subviews containsObject:view]) [self sendSubviewToBack:view];
    return self;
}
- (instancetype) mq_make_to_front {
    if (self.superview) [self.superview bringSubviewToFront:self];
    return self;
}
- (instancetype) mq_make_to_back {
    if (self.superview) [self.superview sendSubviewToBack:self];
    return self;
}

/// enable / disable userinteraction
- (instancetype) mq_enable {
    self.userInteractionEnabled = YES;
    return self;
}
- (instancetype) mq_disable {
    self.userInteractionEnabled = false;
    return self;
}

/// color && cornerRadius && contentMode
- (instancetype) mq_color : (UIColor *) color {
    self.layer.backgroundColor = color ? color.CGColor : UIColor.clearColor.CGColor;
    return self;
}
- (instancetype) mq_radius : (CGFloat) f_radius
                     masks : (BOOL) is_mask {
    self.layer.cornerRadius = f_radius;
    self.layer.masksToBounds = is_mask;
    return self;
}
- (instancetype) mq_round_corner : (UIRectCorner) corner
                          radius : (CGFloat) f_radius {
    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                            byRoundingCorners:corner
                                                  cornerRadii:(CGSize){f_radius, f_radius}];
    CAShapeLayer *l = [[CAShapeLayer alloc] init];
    l.frame = self.bounds;
    l.path = p.CGPath;
    self.layer.mask = l;
    return self;
}
- (instancetype) mq_shadow_make : (UIColor *) color
                        opacity : (float) f_opacity
                         radius : (CGFloat) f_radius
                         offset : (CGSize) size_offset {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = f_opacity;
    self.layer.shadowRadius = f_radius ;
    self.layer.shadowOffset = size_offset;
    return self;
}
- (instancetype) mq_content_mode : (UIViewContentMode) mode {
    self.contentMode = mode;
    return self;
}

- (instancetype) mq_duplicate {
#ifdef __IPHONE_12_0
    NSData * dt = [NSKeyedArchiver archivedDataWithRootObject:self
                                        requiringSecureCoding:false
                                                        error:nil];
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[self class]
                                             fromData:dt
                                                error:nil];
#else
    NSData * dt = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:dt];
#endif
}

- (CGRect) mq_location_in_window {
    UIWindow * window = UIApplication.sharedApplication.delegate.window;
    CGRect rect = [self convertRect:self.bounds
                             toView:window];
    return rect;
}

- (UIImage *) mq_capture_image_after_screen_updates : (BOOL) is_after_updates {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:is_after_updates];
    UIImage *t = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return t;
}

- (void) mq_force_window_to_orientation : (UIDeviceOrientation) orientation {
    if ([UIDevice.currentDevice respondsToSelector:@selector(setOrientation:)]) {
        SEL sel = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:sel]];
        [invocation setSelector:sel];
        [invocation setTarget:UIDevice.currentDevice];
        UIDeviceOrientation var = orientation;
        [invocation setArgument:&var atIndex:2];
        [invocation invoke];
    }
}

@end

#pragma mark - -----

@implementation UIView (MQExtension_Delay_Operate)

- (instancetype) mq_cold : (NSTimeInterval) interval {
    return [self mq_cold:YES time:interval complete:nil];
}

- (instancetype) mq_hot : (NSTimeInterval) interval {
    return [self mq_cold:false time:interval complete:nil];
}

- (instancetype) mq_cold : (BOOL) is_cold
                    time : (NSTimeInterval) interval
                complete : (void(^)(__kindof UIView *v_t , BOOL is_enable)) mq_complete_block {
    
    self.userInteractionEnabled = !is_cold ;
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.userInteractionEnabled = is_cold;
        if (mq_complete_block) mq_complete_block(strong_self , strong_self.userInteractionEnabled);
    });
    
    return self;
}

@end
