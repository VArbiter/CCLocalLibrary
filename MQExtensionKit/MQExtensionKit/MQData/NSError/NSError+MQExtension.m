//
//  NSError+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/8/13.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "NSError+MQExtension.h"

static NSString * MQ_NSError_DOMAIN = @"MQExtensionKit.custom.error.domain";

@implementation NSError (MQExtension)

+ (instancetype) mq_error_with_code : (NSInteger) i_code
                        description : (NSString *) s_description {
    return [self mq_error_with_domain:MQ_NSError_DOMAIN
                                 code:i_code
                          description:s_description];
}

+ (instancetype) mq_error_with_domain : (NSString *) s_domain
                                 code : (NSInteger) i_code
                          description : (NSString *) s_description {
    return [NSError errorWithDomain:s_domain
                               code:i_code
                           userInfo:@{NSLocalizedDescriptionKey : s_description ? s_description : @""}];
}

@end
