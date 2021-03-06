//
//  UIButton+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIButton+MQExtension.h"
#import <objc/runtime.h>

static const char * MQ_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY = "MQ_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY";

@interface UIButton (MQExtension_Assit)

- (void) mq_button_extension_action : ( __kindof UIButton *) sender ;

@end

@implementation UIButton (MQExtension_Assit)

- (void) mq_button_extension_action : ( __kindof UIButton *) sender {
    void (^t)( __kindof UIButton *) = objc_getAssociatedObject(self, MQ_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

@implementation UIButton (MQExtension)

+ (instancetype) mq_common {
    return [self mq_common:UIButtonTypeCustom];
}
+ (instancetype) mq_common : (UIButtonType) type {
    return [UIButton buttonWithType:type];
}

/// titles && images
- (instancetype) mq_title : (NSString *) s_title
                    state : (UIControlState) state {
    [self setTitle:s_title forState:state];
    return self;
}
- (instancetype) mq_image : (UIImage *) image
                    state : (UIControlState) state {
    [self setImage:image forState:state];
    return self;
}

/// actions , default is touchUpInside
- (instancetype) mq_action : (void (^)( __kindof UIButton *sender)) action {
    return [self mq_target:self action:action];
}
- (instancetype) mq_target : (id) target
                    action : (void (^)( __kindof UIButton *sender)) action {
    objc_setAssociatedObject(self, MQ_UIBUTTON_CHAIN_CLICK_ASSOCIATE_KEY, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(mq_button_extension_action:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}

/// custom actions .
- (instancetype) mq_custom : (id) target
                       sel : (SEL) sel
                    events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
             action:sel
   forControlEvents:events];
    return self;
}

@end
