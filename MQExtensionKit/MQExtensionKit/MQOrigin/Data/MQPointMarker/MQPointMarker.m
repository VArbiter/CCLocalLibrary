//
//  MQPointMarker.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/6/27.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "MQPointMarker.h"
#import "NSDictionary+MQExtension.h"

@import UIKit;
@import CoreLocation;
@import AdSupport;
#import <sys/utsname.h>

MQPointMarkerEventKey mq_point_marker_track_regist_event_key = @"mq_regist_event" ;
MQPointMarkerEventKey mq_point_marker_track_login_event_key = @"mq_login_event" ;
MQPointMarkerEventKey mq_point_marker_track_logout_event_key = @"mq_logout_event" ;
MQPointMarkerEventKey mq_point_marker_track_page_begin_event_key = @"mq_page_begin_event" ;
MQPointMarkerEventKey mq_point_marker_track_page_end_event_key = @"mq_page_end_event" ;
MQPointMarkerEventKey mq_point_marker_track_app_active_event_key = @"mq_app_active_event" ;
MQPointMarkerEventKey mq_point_marker_track_app_resign_active_event_key = @"mq_app_resign_active_event" ;
MQPointMarkerEventKey mq_point_marker_track_location_event_key = @"mq_location_event";

static MQPointMarker * __marker = nil;

@interface MQPointMarker ()

@property (nonatomic , assign) id < MQPointMarkerDelegate > delegate_t ;

@property (nonatomic , assign) BOOL is_production ;
@property (nonatomic , copy) NSString * s_channel ;

@property (nonatomic , assign) BOOL is_enable_logging ;
@property (nonatomic , assign) BOOL is_enable_logging_to_local_file ;
@property (nonatomic , assign) BOOL is_enable_logging_to_local_file_ascending ;

@property (nonatomic , copy) NSString * s_today_local_file ;
@property (nonatomic , copy) NSString * s_today_local_file_path ;

@property (nonatomic , copy) NSString * s_previous_page ;
@property (nonatomic , assign) unsigned long long ull_app_use_time ;
@property (nonatomic , assign) unsigned long long ull_page_use_time ;

void mq_debug_print_logging(NSString * s_log) ;

- (void) mq_application_did_enter_background : (NSNotification *) sender ;

@end

@implementation MQPointMarker

+ (void)initialize {
    if (!__marker) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __marker = [[MQPointMarker alloc] init];
            __marker.ull_app_use_time = 0;
            __marker.ull_page_use_time = 0;
        });
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *s_logging_path = [self mq_logging_folder_path];
    
    BOOL isDir = false;
    if ([manager fileExistsAtPath:s_logging_path
                      isDirectory:&isDir]) {
        if (!isDir) {
            [manager removeItemAtPath:s_logging_path error:nil];
        }
    }
    
    if (!isDir) {
        [manager createDirectoryAtPath:s_logging_path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:__marker
                                           selector:@selector(mq_application_did_enter_background:)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
}

+ (void) mq_is_product : (BOOL) is_production {
    __marker.is_production = is_production;
}

+ (void) mq_channel : (NSString *) s_channel {
    __marker.s_channel = s_channel;
}

+ (void) mq_set_delegate : (id <MQPointMarkerDelegate>) delegate {
    __marker.delegate_t = delegate;
}

+ (void) mq_enable_logging {
    __marker.is_enable_logging = YES;
}

+ (void) mq_enable_logging_to_local_file : (BOOL) is_ascending {
    __marker.is_enable_logging = YES;
    __marker.is_enable_logging_to_local_file = YES;
    __marker.is_enable_logging_to_local_file_ascending = is_ascending;
}

+ (NSString *) mq_logging_folder_path {
    NSString *s_logging_path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory ,
                                                                     NSUserDomainMask,
                                                                     YES).firstObject
                                 stringByAppendingPathComponent:@"MQExtensionKit"]
                                stringByAppendingPathComponent:@"MQPointMarkerLog"];
    return s_logging_path;
}
+ (NSArray <NSString *> *) mq_all_logging_file {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e = nil;
    NSArray <NSString *> *array = [manager contentsOfDirectoryAtPath:[self mq_logging_folder_path]
                                                               error:&e];
    
    NSMutableArray <NSString *> *array_t = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *s = [[self mq_logging_folder_path] stringByAppendingPathComponent:obj];
        if (s) [array_t addObject:s];
    }];
    
    if (e) {
#if DEBUG
        NSLog(@"%@ read log error :\n %@",NSStringFromClass(self.class),e);
#endif
        return nil;
    }
    return array_t;
}

#pragma mark - -----

- (NSString *)s_today_local_file {
    if(_s_today_local_file) return _s_today_local_file;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *s_date = [format stringFromDate:NSDate.date];
    self.s_today_local_file_path = [[MQPointMarker mq_logging_folder_path]
                                    stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.log",NSStringFromClass(self.class),s_date]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.s_today_local_file_path]) {
        NSError *e = nil;
        NSString *s_temp = [NSString stringWithContentsOfFile:self.s_today_local_file_path
                                                     encoding:NSUTF8StringEncoding
                                                        error:&e];
        if (e) {
            s_temp = @"";
#if DEBUG
            NSLog(@"%@",e);
#endif
        }
        else {
            _s_today_local_file = s_temp;
        }
    }
    else _s_today_local_file = @"";
    return _s_today_local_file;
}

void mq_debug_print_logging(id t_log) {
    if (!__marker.is_enable_logging) return ;
    NSString * s_log = [NSString stringWithFormat:@"%@",t_log];
    NSString *s_output = [NSString stringWithFormat:@"%@ : \n %@",NSStringFromClass(MQPointMarker.class),s_log];
    NSLog(@"%@ :\n %@", NSStringFromClass(MQPointMarker.class), s_output);
    
    if (!__marker.is_enable_logging_to_local_file) return;

    NSString *s_local_file = __marker.s_today_local_file;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *s_date = [format stringFromDate:NSDate.date];
    if (__marker.is_enable_logging_to_local_file_ascending) {
        [[s_local_file stringByAppendingString:[NSString stringWithFormat:@"\n------ %@ ------\n",s_date]]
         stringByAppendingString:s_log];
    }
    else {
        if (!s_log || !s_log.length) return;
        [[s_log stringByAppendingString:[NSString stringWithFormat:@"\n------ %@ ------\n",s_date]]
         stringByAppendingString:s_local_file];
    }
    
    __marker.s_today_local_file = s_local_file;
}

- (void) mq_application_did_enter_background : (NSNotification *) sender {
    if (!__marker.is_enable_logging) return ;
    if (!__marker.is_enable_logging_to_local_file) return ;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e ;
    [manager removeItemAtPath:self.s_today_local_file_path error:&e];
#if DEBUG
    NSLog(@"%@ : %@" , NSStringFromClass(self.class) , e);
#endif
    
    [self.s_today_local_file writeToFile:self.s_today_local_file_path
                              atomically:YES
                                encoding:NSUTF8StringEncoding
                                   error:&e];
    if (e) {
#if DEBUG
        NSLog(@"%@ : %@" , NSStringFromClass(self.class) , e);
#endif
        if (__marker.delegate_t
            && [__marker.delegate_t
                respondsToSelector:@selector(mq_point_maker:updating_local_logging_file_error:)]) {
            [__marker.delegate_t mq_point_maker:__marker
              updating_local_logging_file_error:e];
        }
    }
    else if (__marker.delegate_t
             && [__marker.delegate_t
                 respondsToSelector:@selector(mq_point_maker:updating_local_logging_file_complete:)]) {
        [__marker.delegate_t mq_point_maker:__marker
       updating_local_logging_file_complete:__marker.s_today_local_file_path];
    }
    
    
}

#pragma mark - ----- tracking method

+ (void) mq_track_event : (__kindof MQMarkerEvent *) event {
    
    if (!event || !event.s_event_id.length) {
        if (__marker.delegate_t
            && [__marker.delegate_t respondsToSelector:@selector(mq_point_maker:event:error:)]) {
            NSError *e = [NSError errorWithDomain:@"elwinfrederick.MQExtensionKit.MQData.MQPointMarker"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey : @"event is invalid."}];
            [__marker.delegate_t mq_point_maker:__marker
                                          event:event
                                          error:e];
        }
        
        return ;
    }
    
    [event.d_default setValue:__marker.s_channel
                       forKey:mq_event_default_info_channel_key];
    [event.d_default setValue:@(!__marker.is_production)
                       forKey:mq_event_default_info_debug_key];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:event.s_event_id forKey:mq_event_default_info_event_id_key];
    [d setValue:event.s_description forKey:mq_event_default_extra_info_description_key];
    [d setValue:event.s_method forKey:mq_event_default_extra_info_method_key];
    [d setValue:event.d_extra forKey:mq_event_default_extra_info_extra_key];
    [d setValue:event.type forKey:mq_event_default_extra_info_type_key];
    if (event.is_adding_default_extra_info) {    
        [d setValue:event.d_default forKey:mq_event_default_extra_info_extra_default_key];
    }
    
    if (__marker.delegate_t
        && [__marker.delegate_t
            respondsToSelector:@selector(mq_point_maker:event:params:upload_JSON:)]) {
            [__marker.delegate_t mq_point_maker:__marker
                                          event:event
                                         params:d
                                    upload_JSON:d.to_json];
    }
}

+ (void) mq_track_regist : (NSString *) s_account_id
                   extra : (NSDictionary *) d_extra {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:s_account_id forKey:mq_event_default_extra_info_account_id_key];
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc] init_event_id:mq_point_marker_track_regist_event_key
                                                                    extra:d];
    [self mq_track_event:t];
}
+ (void) mq_track_login : (NSString *) s_account_id
                  extra : (NSDictionary *) d_extra {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:s_account_id forKey:mq_event_default_extra_info_account_id_key];
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc] init_event_id:mq_point_marker_track_login_event_key
                                                                    extra:d];
    [self mq_track_event:t];
}
+ (void) mq_track_logout : (NSString *) s_account_id
                   extra : (NSDictionary *) d_extra {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:s_account_id forKey:mq_event_default_extra_info_account_id_key];
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc] init_event_id:mq_point_marker_track_logout_event_key
                                                                    extra:d];
    [self mq_track_event:t];
}

+ (void) mq_track_latitude : (double) latitude
                 longitude : (double) longitude {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:@(latitude) forKey:mq_event_default_extra_info_latitude_key];
    [d setValue:@(longitude) forKey:mq_event_default_extra_info_longitude_key];
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc] init_event_id:mq_point_marker_track_location_event_key
                                                                    extra:d];
    [self mq_track_event:t];
}
+ (void) mq_track_loacation : (CLLocation *) location {
    if (CLLocationCoordinate2DIsValid(location.coordinate)) {
        double latitude = location.coordinate.latitude;
        double longitude = location.coordinate.longitude;
        [self mq_track_latitude:latitude
                      longitude:longitude];
    }
    else {
#if DEBUG
        NSLog(@"%@ : CLLocation is invalid", NSStringFromClass(self.class));
#endif
    }
}

static NSInteger __page_sequence = 0;
+ (void) mq_track_page_begin :  (NSString *) s_page
                       extra : (NSDictionary *) d_extra {
    __marker.ull_page_use_time = NSDate.date.timeIntervalSince1970 * 1000.f;
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:__marker.s_previous_page forKey:mq_event_default_extra_info_page_previous_key];
    [d setValue:s_page forKey:mq_event_default_extra_info_page_begin_key];
    [d setValue:@(__page_sequence) forKey:mq_event_default_extra_info_page_sequence_key];
    
    __page_sequence ++ ;
    
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc]
                               init_event_id:mq_point_marker_track_page_begin_event_key
                               extra:d];
    [self mq_track_event:t];
}
+ (void) mq_track_page_end :  (NSString *) s_page
                     extra : (NSDictionary *) d_extra {
    __marker.s_previous_page = s_page;
    
    unsigned long long interval = NSDate.date.timeIntervalSince1970 * 1000.f;
    __marker.ull_page_use_time = interval - __marker.ull_page_use_time;
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:@(__marker.ull_page_use_time) forKey:mq_event_default_extra_info_page_use_time_key];
    [d setValue:s_page forKey:mq_event_default_extra_info_page_end_key];
    MQMarkerEvent_Common *t = [[MQMarkerEvent_Common alloc]
                               init_event_id:mq_point_marker_track_page_end_event_key
                               extra:d];
    [self mq_track_event:t];
}

static unsigned long long __app_use_time_devide = 0;
+ (void) mq_track_app_active :  (NSString *) s_page
                       extra : (NSDictionary *) d_extra {
    __app_use_time_devide = NSDate.date.timeIntervalSince1970 * 1000.f;
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:@(__marker.ull_app_use_time) forKey:mq_event_default_extra_info_app_total_use_time_key];
    MQMarkerEvent_Calculate *t = [[MQMarkerEvent_Calculate alloc]
                                  init_event_id:mq_point_marker_track_app_active_event_key
                                  extra:d];
    [self mq_track_event:t];
}
+ (void) mq_track_app_resign_active :  (NSString *) s_page
                              extra : (NSDictionary *) d_extra {
    unsigned long long interval = NSDate.date.timeIntervalSince1970 * 1000.f;
    __marker.ull_app_use_time += interval - __app_use_time_devide;
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:@(__marker.ull_app_use_time) forKey:mq_event_default_extra_info_app_total_use_time_key];
    MQMarkerEvent_Calculate *t = [[MQMarkerEvent_Calculate alloc]
                                  init_event_id:mq_point_marker_track_app_resign_active_event_key
                                  extra:d];
    [self mq_track_event:t];
}

@end

#pragma mark - -----

MQMarkerEventDefaultExtraInfoKey mq_event_default_info_channel_key = @"mq_channel_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_info_debug_key = @"mq_debug_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_extra_key = @"mq_extra_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_extra_default_key = @"mq_extra_default_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_channel_key = @"mq_channel_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_info_event_id_key = @"mq_event_id_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_key = @"mq_type_key";

MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_debug_key = @"mq_is_debug_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_method_key = @"mq_method_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_description_key = @"mq_description_key";

MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_common_key = @"mq_common_type_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_count_key = @"mq_count_type_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_type_calculate_key = @"mq_calculate_type_key";

MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_source_key = @"mq_source_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_bundle_id_key = @"mq_bundle_id_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_develop_team_key = @"mq_develop_team_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_occurrence_time_key = @"mq_occurrence_time_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_time_stamp_key = @"mq_time_stamp_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_UUID_key = @"mq_uuid_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_IDFA_key = @"mq_idfa_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_system_version_key = @"mq_system_version_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_device_info_key = @"mq_device_info_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_version_key = @"mq_version_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_build_version_key = @"mq_build_version_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_current_memory_key = @"mq_current_memory_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_memory_remain_key = @"mq_memory_remain_key" ;

MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_account_id_key = @"mq_account_id_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_latitude_key = @"mq_latitude_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_longitude_key = @"mq_longitude_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_active_key = @"mq_app_active_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_resign_active_key = @"mq_app_resign_active_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_previous_key = @"mq_page_previous_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_begin_key = @"mq_page_begin_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_end_key = @"mq_page_end_key" ;
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_app_total_use_time_key = @"mq_app_total_use_time_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_use_time_key = @"mq_page_use_time_key";
MQMarkerEventDefaultExtraInfoKey mq_event_default_extra_info_page_sequence_key = @"mq_page_sequence_key";

@interface MQMarkerEvent ()

@property (nonatomic , copy , readwrite) NSString * type ;
@property (nonatomic , copy , readwrite) NSString * s_event_id ;
@property (nonatomic , copy , readwrite) NSString * s_description ;
@property (nonatomic , copy , readwrite) NSMutableDictionary * d_extra ;
@property (nonatomic , copy , readwrite) NSMutableDictionary * d_default ;

@end

@implementation MQMarkerEvent

- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id {
    if (!s_event_id) return nil;
    if (![s_event_id isKindOfClass:NSString.class]) return nil;
    if (!s_event_id.length) return nil;
    
    if ((self = [super init])) {
        self.s_event_id = s_event_id;
        self.is_adding_default_extra_info = YES;
        
        if ([self isKindOfClass:MQMarkerEvent_Count.class]) {
            self.type = mq_event_default_extra_info_type_count_key;
        }
        else if ([self isKindOfClass:MQMarkerEvent_Calculate.class]) {
            self.type = mq_event_default_extra_info_type_calculate_key;
        }
        else if ([self isKindOfClass:MQMarkerEvent.class]) {
            self.type = mq_event_default_extra_info_type_common_key;
        }
        
    }
    return self;
}

- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id
                         extra : (NSDictionary * _Nullable) d_extra {
    id t = [self init_event_id:s_event_id];
    if (t) {
        if (d_extra && [d_extra isKindOfClass:NSDictionary.class]) {
            [self.d_extra addEntriesFromDictionary:d_extra];
        }
    }
    return self;
}

- (instancetype) init_event_id : (NSString  * _Nonnull ) s_event_id
                   description : (NSString  * _Nullable ) s_description
                         extra : (NSDictionary * _Nullable) d_extra {
    id t = [self init_event_id:s_event_id];
    if (t) {
        ((MQMarkerEvent *)t).s_description = s_description;
        
        if (d_extra && [d_extra isKindOfClass:NSDictionary.class]) {
            [self.d_extra addEntriesFromDictionary:d_extra];
        }

    }
    return ((MQMarkerEvent *)t);
}

- (void)setS_event_id:(NSString *)s_event_id {
    _s_event_id = [NSString stringWithFormat:@"%@",s_event_id];
}

- (NSMutableDictionary *)d_extra {
    if (_d_extra) return _d_extra;
    NSMutableDictionary *t = [NSMutableDictionary dictionary];
    _d_extra = t;
    return _d_extra;
}

- (NSMutableDictionary *)d_default {
    if (_d_default) return _d_default;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setValue:[UIDevice currentDevice].model forKey:mq_event_default_extra_info_source_key];
    [d setValue:[[NSBundle mainBundle] bundleIdentifier]
         forKey:mq_event_default_extra_info_bundle_id_key];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [format setTimeZone:timeZone];
    [d setValue:[format stringFromDate:NSDate.date]
         forKey:mq_event_default_extra_info_occurrence_time_key];
    [d setValue:@([NSDate.date timeIntervalSince1970] * 1000)
         forKey:mq_event_default_extra_info_time_stamp_key];
    
    NSString *s_uuid = UIDevice.currentDevice.identifierForVendor.UUIDString;
    [d setValue:s_uuid forKey:mq_event_default_extra_info_UUID_key];
    
    NSString *s_system_version = @(UIDevice.currentDevice.systemVersion.floatValue).stringValue ;
    [d setValue:s_system_version forKey:mq_event_default_extra_info_system_version_key];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *s_device_info = [NSString stringWithCString:systemInfo.machine
                                                 encoding:NSASCIIStringEncoding];
    [d setValue:s_device_info forKey:mq_event_default_extra_info_device_info_key];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    [d setValue:version forKey:mq_event_default_extra_info_version_key];
    [d setValue:build forKey:mq_event_default_extra_info_build_version_key];
    
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSString *idfa_s = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [d setValue:idfa_s forKey:mq_event_default_extra_info_IDFA_key];
    }
    else [d setValue:@"not_enabled" forKey:mq_event_default_extra_info_IDFA_key];
    
    _d_default = d;
    return _d_default;
}

@end

#pragma mark - -----

@implementation MQMarkerEvent_Count

@end

#pragma mark - -----

@implementation MQMarkerEvent_Calculate

@end

#pragma mark - -----

@implementation MQMarkerEvent_Common

@end
