//
//  UIBarButtonItem+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIBarButtonItem+MQExtension.h"
#import <objc/runtime.h>

static const char * _MQ_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_ = "MQ_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY";

@interface UIBarButtonItem (MQExtension_Assit)

- (void) ccBarButtonItemExtensionAction : ( __kindof UIBarButtonItem *) sender ;

@end

@implementation UIBarButtonItem (MQExtension_Assit)

- (void) ccBarButtonItemExtensionAction : ( __kindof UIBarButtonItem *) sender {
    void (^t)( __kindof UIBarButtonItem *) = objc_getAssociatedObject(self, _MQ_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) {
            t(sender);
        }
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

@end

#pragma mark - -----

@implementation UIBarButtonItem (MQExtension)

+ (instancetype) mq_common {
    return UIBarButtonItem.alloc.init;
}
- (instancetype) mq_title : (NSString *) sTitle {
    self.title = sTitle;
    return self;
}
- (instancetype) mq_image : (UIImage *) image {
    if (!CGSizeEqualToSize(image.size, CGSizeZero)) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else self.image = image;
    return self;
}
- (instancetype) mq_action : (void (^)( __kindof UIBarButtonItem *sender)) action {
    if (action) return [self mq_target:self action:action];
    return self;
}
- (instancetype) mq_target : (id) target
                   action : (void (^)( __kindof UIBarButtonItem *sender)) action {
    if (action) objc_setAssociatedObject(self, _MQ_UIBARBUTTONITEM_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(ccBarButtonItemExtensionAction:)];
    return self;
}

@end