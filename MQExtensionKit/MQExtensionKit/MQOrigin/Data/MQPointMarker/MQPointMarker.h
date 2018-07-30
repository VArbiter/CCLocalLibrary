//
//  MQPointMarker.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/27.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 MQPointMarker collect the IDFA , // MQPointMarker 收集了 IDFA
 therefore "AdSupport.framework" must be added in project . // 所以 工程必须引入 "AdSupport.framework"
 
 WARNING:
    be sure you have to check the IDFA issues in App Store . // 确认你解决了 App Store 的 IDFA 问题
    otherwise will cause binary reject . // 否则会引起 二进制拒绝 .
 
 */

@class CLLocation ;
@class MQPointMarker , MQMarkerEvent ;

typedef NSString * MQPointMarkerEventKey NS_EXTENSIBLE_STRING_ENUM;

/// regist event . // 注册事件
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_regist_event_key ;
/// login event . // 登录事件
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_login_event_key ;
/// logout event . // 登出事件
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_logout_event_key ;
/// begin track a page . // 开始记录页面
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_page_begin_event_key ;
/// end track a page . // 结束记录界面
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_page_end_event_key ;
/// track app active times . // 记录应用重新进入前台次数
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_app_active_event_key ;
/// track app resign active times . // 记录应用从前台退出次数
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_app_resign_active_event_key ;
/// track users' location . // 记录用户的地址
FOUNDATION_EXPORT MQPointMarkerEventKey mq_point_marker_track_location_event_key ;

@protocol MQPointMarkerDelegate < NSObject >

@required
/// when a event has been marked . this method will allow you to get and upload its' JSON (generated by MQMarkEvent) .
// 当事件被记录 , 这个方法将会允许你获得并上传事件的 JSON .
- (void) mq_point_maker : (MQPointMarker *) marker
                  event : (__kindof MQMarkerEvent *) event
                 params : (NSDictionary *) t_params // if your're using AFNetworking . // 如果你使用的是 AFNetworking
            upload_JSON : (NSString *) s_JSON ; // json was transfer from t_params . // 从 t_params 转换得来

@optional

/// has effect when sth goes wrong . such as no event id . // 出现错误时起效 , 例如没有 event id .
- (void) mq_point_maker : (MQPointMarker *) marker
                  event : (__kindof MQMarkerEvent *) event
                  error : (NSError *) error ;

/// only worked when invoke "[MQPointMarker mq_enable_logging_to_local_file]"
// 只有在 调用 "[MQPointMarker mq_enable_logging_to_local_file]"时 起效
- (void) mq_point_maker : (MQPointMarker *) marker
updating_local_logging_file_complete : (NSString *) s_file_path ;

- (void) mq_point_maker : (MQPointMarker *) marker
updating_local_logging_file_error : (NSError *) error ;

@end

/// mark specific point to your own server .// 打特定的点到自己的服务器
@interface MQPointMarker : NSObject

/// decide that whether if use it in release environment .// 用来决定是否用于生产 .
+ (void) mq_is_product : (BOOL) is_production ;
/// app's channel . // 用户下载应用的渠道
+ (void) mq_channel : (NSString *) s_channel ;
/// have to invoke it before make any markers . // 必须在调用任何打点方法之前 调用它
+ (void) mq_set_delegate : (id <MQPointMarkerDelegate>) delegate ;

/// enable logging . default is NO // 启用日志 , 默认禁用
+ (void) mq_enable_logging ;
/// enable logging and write to sandbox .  default is NO . // 启用日志并写入到沙盒 , 默认禁用
+ (void) mq_enable_logging_to_local_file : (BOOL) is_ascending ;
/// if enable logging in local file , this method will return the folder path .
// 如果启用了写入日志到文件 , 返回这个文件夹的 路径
+ (NSString *) mq_logging_folder_path ;
/// if enable logging in local file , this method will return all the logging files' path .
// 如果启用了写入日志到文件 , 返回这个文件夹内所有日志的 路径
+ (NSArray <NSString *> *) mq_all_logging_file ;

/// track event . // 跟踪事件
+ (void) mq_track_event : (__kindof MQMarkerEvent *) event ;

/// track regist event . // 跟踪 注册事件
+ (void) mq_track_regist : (NSString *) s_account_id
                   extra : (NSDictionary *) d_extra ;
/// track login event . // 跟踪登录事件
+ (void) mq_track_login : (NSString *) s_account_id
                  extra : (NSDictionary *) d_extra ;
/// track logout event . // 跟踪登出事件.
+ (void) mq_track_logout : (NSString *) s_account_id
                   extra : (NSDictionary *) d_extra ;

/*
 
 if you're using location record . // 如果使用地理位置记录
 link "CoreLocation.framework" and "#import <CoreLocation/CoreLocation.h>" .
 remember adding these to your info.plist . // 记得添加这些到 info.plist 文件 .
 
 <key>NSLocationAlwaysUsageDescription</key>
 <string> ${PRODUCT_NAME} + description / 描述 </string>
 
 <key>NSLocationUsageDescription</key>
 <string> ${PRODUCT_NAME} + description / 描述 </string>
 
 <key>NSLocationWhenInUseUsageDescription</key>
 <string> ${PRODUCT_NAME} + description / 描述 </string>
 
 */

/// track users' latitude && longitude . // 跟踪用户的经纬度
+ (void) mq_track_latitude : (double) latitude
                 longitude : (double) longitude ;
+ (void) mq_track_loacation : (CLLocation *) location ;

/// track page begin . // 跟踪进入页面
+ (void) mq_track_page_begin :  (NSString *) s_page
                       extra : (NSDictionary *) d_extra ;
/// track page end .// 跟踪页面结束
+ (void) mq_track_page_end :  (NSString *) s_page
                     extra : (NSDictionary *) d_extra ;

/// track app active status . // 跟踪应用活跃状态
+ (void) mq_track_app_active :  (NSString *) s_page
                       extra : (NSDictionary *) d_extra ;
/// track app resign active. // 跟踪应用不活跃状态
+ (void) mq_track_app_resign_active :  (NSString *) s_page
                              extra : (NSDictionary *) d_extra ;

@end

#pragma mark - ----- EVENT

typedef NSString * MQMarkerEventDefaultExtraInfoKey NS_EXTENSIBLE_STRING_ENUM;

// always . // 一直存在

/// channel . // 发布渠道
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_info_channel_key ;
/// is debug or not . // 是否是开发环境
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_info_debug_key ;
/// event id . // 事件 id
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_info_event_id_key ;
/// event type . // 事件类型
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_key ;
/// extra info . // 额外信息 .
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_extra_key ; // for developer // 针对开发者
/// extra default info . // 额外默认信息 .
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_extra_default_key ;
/// method that record event . // 用来记录事件的方法
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_method_key ;
/// description for this event . // 这个事件的描述
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_description_key ;

// ------

/// common event type . // 公共事件类型
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_common_key ;
/// count event type . // 计数事件类型
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_count_key ;
///  calculate event type . // 计算事件类型
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_calculate_key ;

/// iPhone or iPad app . // iPhone 或 iPad 应用
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_source_key ;
/// app bundle id .// 应用的 bundle id
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_bundle_id_key ;
/// app developer team (need to be specified by developer).// 应用的开发团队 (开发者自己指定)
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_develop_team_key ;
/// event occurrence time . // 事件发生时间
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_occurrence_time_key ;
/// event time stamp. // 事件时间戳
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_time_stamp_key ;
/// device uuid .// 设备 uuid
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_UUID_key ;
/// device idfa .// 设备的 IDFA
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_IDFA_key ;
/// system version .// 系统版本号
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_system_version_key ;
/// device info .// 设备信息 eg : iPhone 8,1
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_device_info_key ;
/// app version .// 应用版本
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_version_key ;
/// build version. // 构建版本
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_build_version_key ;
/// current memory .// 当前使用内存
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_current_memory_key ;
/// memory remain . // 当前剩余内存
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_memory_remain_key ;

// ------

/// user id . // 用户 id
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_account_id_key ;
/// latitude // 经度
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_latitude_key ;
/// longitude // 纬度
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_longitude_key ;
/// app active status // 应用活跃状态
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_active_key ;
/// app resign active status // 应用不活跃状态
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_resign_active_key ;
/// the page that before entering a new page .  // 进入特定界面之前的一个界面
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_previous_key ;
/// the page that current in front . // 应用进入页面
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_begin_key ;
/// user leave a page .// 应用从特定页面退出
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_end_key ;
/// how long app in use before it has been destroyed . (millseconds) // 在应用被销毁前使用了多久 (毫秒)
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_total_use_time_key ;
/// how long user stay in this page . (millseconds) // 用户在这个页面待了多久 (毫秒)
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_use_time_key ;
/// the sequence that entering the page . // 用户进入界面序列
FOUNDATION_EXPORT MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_sequence_key ;


/// an abstract event for all events . // 所有 event 的聚合类
// not recommended to use directly . // 不建议直接使用
@interface MQMarkerEvent : NSObject

- (instancetype) init NS_UNAVAILABLE;

/// init method .
- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id NS_DESIGNATED_INITIALIZER ;
- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id
                         extra : (NSDictionary * _Nullable) d_extra ;
- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id
                   description : (NSString  * _Nullable ) s_description
                         extra : (NSDictionary * _Nullable) d_extra ;
/// event type . // 事件类型
@property (nonatomic , copy , readonly , nonnull) NSString * type ;
/// event identifier . must be unique . /// 事件 id , 必须唯一
@property (nonatomic , copy , readonly , nonnull) NSString * s_event_id ;
/// event description . can be NULL . /// 事件描述 , 可为空
@property (nonatomic , copy , readonly , nullable) NSString * s_description ;
/// extra info . can be NULL . /// 额外自定义统计信息 , 可为空
@property (nonatomic , copy , readonly , nullable) NSMutableDictionary * d_extra ;
/// default info . can't be NULL . // 默认统计信息 , 不可为空
@property (nonatomic , copy , readonly , nonnull) NSMutableDictionary * d_default ;
/// adding default extra info or not . (default YES) // 是否添加额外的统计信息 . (默认添加)
@property (nonatomic , assign) BOOL is_adding_default_extra_info ;

/// the name of which method using it . can be NULL  // 调用此函数方法名 , 可为空
@property (nonatomic , copy , nullable) NSString *s_method ;

@end

/// count event . // 计数事件
@interface MQMarkerEvent_Count : MQMarkerEvent

@end

/// calculate event . // 计算事件
@interface MQMarkerEvent_Calculate : MQMarkerEvent

@end

/// common event . // 普通事件
@interface MQMarkerEvent_Common : MQMarkerEvent

@end
