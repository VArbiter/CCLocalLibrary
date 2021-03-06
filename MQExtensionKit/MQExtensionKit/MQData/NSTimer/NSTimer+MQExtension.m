//
//  NSTimer+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSTimer+MQExtension.h"

#import <objc/runtime.h>

static const char * MQ_NSTIMER_ASSOCIATE_TIMER_KEY = "MQ_NSTIMER_ASSOCIATE_TIMER_KEY";
static const char * MQ_NSTIMER_ASSOCIATE_SCHEDULED_KEY = "MQ_NSTIMER_ASSOCIATE_SCHEDULED_KEY";

@interface NSTimer (MQExtension_Assit)

+ (void) mq_timer_action : (NSTimer *) sender ;

@end

@implementation NSTimer (MQExtension_Assit)

+ (void) mq_timer_action : (NSTimer *) sender {
    void (^t)(NSTimer *) = objc_getAssociatedObject(sender, MQ_NSTIMER_ASSOCIATE_TIMER_KEY);
    if (t) t(sender);
    void (^s)(NSTimer *) = objc_getAssociatedObject(sender, MQ_NSTIMER_ASSOCIATE_SCHEDULED_KEY);
    if (s) s(sender);
}

@end

@implementation NSTimer (MQExtension)

/// timer
+ (instancetype) mq_timer : (NSTimeInterval) interval
                   action : (void (^)(NSTimer *sender)) action {
    return [self mq_timer:interval
                   repeat:YES
                   action:action];
}

+ (instancetype) mq_timer : (NSTimeInterval) interval
                   repeat : (BOOL) is_repeat
                   action : (void (^)(NSTimer *sender)) action {
    return [self mq_timer:interval
                 userInfo:nil
                   repeat:is_repeat
                   action:action];
}

+ (instancetype) mq_timer : (NSTimeInterval) interval
                 userInfo : (id) user_info
                   repeat : (BOOL) is_repeat
                   action : (void (^)(NSTimer *sender)) action {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(mq_timer_action:)
                                           userInfo:user_info
                                            repeats:is_repeat];
    objc_setAssociatedObject(timer, MQ_NSTIMER_ASSOCIATE_TIMER_KEY, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return timer;
}

/// scheduled
+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                       action : (void (^)(NSTimer *sender)) action {
    return [self mq_scheduled:interval
                       repeat:YES
                       action:action];
}

+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                       repeat : (BOOL) is_repeat
                       action : (void (^)(NSTimer *sender)) action {
    return [self mq_scheduled:interval
                     userInfo:nil
                       repeat:is_repeat
                       action:action];
}

+ (instancetype) mq_scheduled : (NSTimeInterval) interval
                     userInfo : (id) user_info
                       repeat : (BOOL) is_repeat
                       action : (void (^)(NSTimer *sender)) action {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                      target:self
                                                    selector:@selector(mq_timer_action:)
                                                    userInfo:user_info
                                                     repeats:is_repeat];
    objc_setAssociatedObject(timer, MQ_NSTIMER_ASSOCIATE_SCHEDULED_KEY, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return timer;
}

/// invalidate && set entity to nil.
void MQ_TIMER_DESTORY(NSTimer *timer) {
    [timer invalidate];
    timer = nil;
}

- (instancetype) mq_fire {
    if (self.isValid) {
        [self fire];
    }
    return self;
}
- (instancetype) mq_pause {
    if (self.isValid) {
        self.fireDate = NSDate.distantFuture;
        objc_setAssociatedObject(self, "mq_extensionkit_timer_associate_firedate_key", self.fireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return self;
}
- (instancetype)mq_continue {
    if (self.isValid) {
        NSDate *firedate = objc_getAssociatedObject(self, "mq_extensionkit_timer_associate_firedate_key");
        if (firedate) {
            self.fireDate = firedate;
        }
    }
    return self;
}
- (instancetype) mq_immediate {
    if (self.isValid) {
        self.fireDate = NSDate.date;
    }
    return self;
}
- (instancetype) mq_stop {
    [self invalidate];
    return self;
}

@end
