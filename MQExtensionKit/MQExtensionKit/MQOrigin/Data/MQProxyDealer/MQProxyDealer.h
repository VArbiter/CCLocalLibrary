//
//  MQProxyDealer.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE
    #define MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE
#endif

#ifdef MQ_PROXY_DELER_PROTOCOL_TEST_EXAMPLE

/// simply simulat the muti-inhert of objective-C // 在 OC 中模仿多继承
/// note : if you want that MQProxyDealer to simulate the muti-inhert values // 如果你想使用 MQProxyDealer 来模仿多继承
///     all your methods must be instance and interface in a protocol // 所有方法必须在 一个协议中声明
/// eg :
///
/// @@protocol MQTestProtocol : <NSObject>
/// - (void) testMethod ;
/// @end
///
/// @interface MQSomeClass : NSObject < MQTestProtocol >
/// @end
///
/// @implementation MQSomeClass
///
/// - (void) testMethod {/* do sth. */}
///
/// @end

@interface MQProxyDealer : NSProxy

/// it's not a singleton . // 不是单例
+ (instancetype) common ;
+ (instancetype) common : (NSArray <id> *) array_targets ;

/// regist targets , only instance methods allowed (MQProxyDealer is an instance) // 注册目标 , 只有对象被允许
- (instancetype) mq_regist_methods : (NSArray <id> *) array_targets ;

@end

#endif
