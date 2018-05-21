//
//  PHAsset+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2018/5/20.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "PHAsset+CCExtension.h"
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
/*
@interface PHAsset (CCExtension_Cache)

@property (nonatomic , strong , readwrite) NSMutableDictionary *cc_phasset_dict_normal_cache ;
@property (nonatomic , strong , readwrite) NSMutableDictionary *cc_phasset_dict_high_quality_cache ;
@property (nonatomic , strong , readwrite) NSMutableDictionary *cc_phasset_dict_fast_cache ;

- (void) cc_destory_normal_cache ;
- (void) cc_destory_high_quality_cache ;
- (void) cc_destory_fast_cache ;

@end

@implementation PHAsset (CCExtension_Cache)

- (void)setCc_phasset_dict_normal_cache:(NSMutableDictionary *)cc_phasset_dict_normal_cache {
    objc_setAssociatedObject(self, @selector(cc_phasset_dict_normal_cache),
                             cc_phasset_dict_normal_cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setCc_phasset_dict_high_quality_cache:(NSMutableDictionary *)cc_phasset_dict_high_quality_cache {
    objc_setAssociatedObject(self, @selector(cc_phasset_dict_high_quality_cache),
                             cc_phasset_dict_high_quality_cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setCc_phasset_dict_fast_cache:(NSMutableDictionary *)cc_phasset_dict_fast_cache {
    objc_setAssociatedObject(self, @selector(cc_phasset_dict_fast_cache),
                             cc_phasset_dict_fast_cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)cc_phasset_dict_normal_cache {
    NSMutableDictionary *t = objc_getAssociatedObject(self, _cmd);
    if (t) return t;
    t = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd,
                             t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return t;
}
- (NSMutableDictionary *)cc_phasset_dict_high_quality_cache {
    NSMutableDictionary *t = objc_getAssociatedObject(self, _cmd);
    if (t) return t;
    t = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd,
                             t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return t;
}
- (NSMutableDictionary *)cc_phasset_dict_fast_cache {
    NSMutableDictionary *t = objc_getAssociatedObject(self, _cmd);
    if (t) return t;
    t = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd,
                             t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return t;
}

- (void) cc_destory_normal_cache {
    [self.cc_phasset_dict_normal_cache removeAllObjects];
    self.cc_phasset_dict_normal_cache = nil;
}
- (void) cc_destory_high_quality_cache {
    [self.cc_phasset_dict_high_quality_cache removeAllObjects];
    self.cc_phasset_dict_high_quality_cache = nil;
}
- (void) cc_destory_fast_cache {
    [self.cc_phasset_dict_fast_cache removeAllObjects];
    self.cc_phasset_dict_fast_cache = nil;
}

@end
 */

#pragma mark - -----

@implementation PHAsset (CCExtension)

CCPHAssetType CCPHAssetType_Unknow = @"CCPHAssetType_Unknow" ;
CCPHAssetType CCPHAssetType_Video = @"CCPHAssetType_Video" ;
CCPHAssetType CCPHAssetType_Photo = @"CCPHAssetType_Photo" ;
CCPHAssetType CCPHAssetType_Audio = @"CCPHAssetType_Audio" ;
CCPHAssetType CCPHAssetType_Live_Photo = @"CCPHAssetType_Live_Photo" ;

- (CCPHAssetType)type_asset {
    if (self.mediaType == PHAssetMediaTypeVideo) return CCPHAssetType_Video;
    else if (self.mediaType == PHAssetMediaTypeImage) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.1) {
            return self.mediaSubtypes == PHAssetMediaSubtypePhotoLive ?
            CCPHAssetType_Live_Photo : CCPHAssetType_Photo;
        }
        return CCPHAssetType_Photo;
    }
    else if (self.mediaType == PHAssetMediaTypeAudio) return CCPHAssetType_Audio;
    
    return CCPHAssetType_Unknow;
}
/*
- (void) cc_cache_image_size : (CGSize) size
                        type : (CCPHAssetCacheType) type
                    complete : (void (^)(UIImage * image ,
                                         PHAsset * asset ,
                                         NSDictionary *dict_info)) cc_complete_block {
#warning TODO >>>
    // image cache .
}

- (void) cc_destory_cache : (CCPHAssetCacheType) type {
    switch (type) {
        case CCPHAssetCacheType_default:
        case CCPHAssetCacheType_Normal:{
            [self cc_destory_normal_cache];
        }break;
        case CCPHAssetCacheType_High_Quality:{
            [self cc_destory_high_quality_cache];
        }break;
        case CCPHAssetCacheType_Fast:{
            [self cc_destory_fast_cache];
        }break;
            
        default:
            break;
    }
}

- (void) cc_destory_all_cache {
    [self cc_destory_normal_cache];
    [self cc_destory_high_quality_cache];
    [self cc_destory_fast_cache];
}
*/
@end

#endif
