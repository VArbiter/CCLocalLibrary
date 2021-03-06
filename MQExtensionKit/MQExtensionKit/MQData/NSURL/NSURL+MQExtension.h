//
//  NSURL+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MQExtension)

+ (instancetype) mq_url : (NSString *) s_url ;
+ (instancetype) mq_local : (NSString *) s_url ;

@end

@interface NSString (MQExtension_UrlEncode)

@property (nonatomic , readonly) NSURL *to_web_url ; // encode chinese character using origin // 使用原生转换为 在线 URL
@property (nonatomic , readonly) NSURL *to_local_url ; // decode chinese character using origin // 使用原生转换为 本地 URL

@end
