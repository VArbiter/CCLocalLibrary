//
//  UIImage+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCExtension)

/// for image size && width
@property (nonatomic , readonly) CGFloat width ;
@property (nonatomic , readonly) CGFloat height ;

/// scale size with radius
- (CGSize) ccZoom : (CGFloat) fRadius ;
- (instancetype) ccResizable : (UIEdgeInsets) insets ;
- (instancetype) ccRendaring : (UIImageRenderingMode) mode ;
- (instancetype) ccAlwaysOriginal ;

/// class , imageName
+ (instancetype) ccBundle : (Class) cls
                     name : (NSString *) sName;
+ (instancetype) ccName : (NSString *) sName ;
+ (instancetype) ccName : (NSString *) sName
                 bundle : (NSBundle *) bundle ;
+ (instancetype) ccFile : (NSString *) sPath ;

@end

#pragma mark - -----

@interface UIImage (CCExtension_Gaussian)

FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_VALUE_ ;
FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ ;

// for gaussian issues

/// using Accelerate
- (instancetype) ccGaussianAcc ;
- (instancetype) ccGaussianAcc : (CGFloat) fRadius ;
- (instancetype) ccGaussianAcc : (CGFloat) fRadius
                     iteration : (NSInteger) iteration
                          tint : (UIColor *) tint ;
- (instancetype) ccGaussianAcc : (CGFloat) fRadius
                     iteration : (NSInteger) iteration
                          tint : (UIColor *) tint
                      complete : (void(^)(UIImage *origin , UIImage *processed)) complete ;

/// using CoreImage
- (instancetype) ccGaussianCI ; // sync , not recommended
- (instancetype) ccGaussianCI : (CGFloat) fRadius ; // sync , not recommended
- (instancetype) ccGaussianCI : (CGFloat) fRadius
                     complete : (void(^)(UIImage *origin , UIImage *processed)) complete ; // async


@end

#pragma mark - -----

@interface UIImage (CCExtension_Data)

FOUNDATION_EXPORT CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ ; // 400 kb

// available for PNG && JPEG

@property (nonatomic , readonly) NSData *toData ;
/// compress and limit it with in a fitable range .
- (NSData *) ccCompresssJPEG : (CGFloat) fQuility;
/// arguments with Mbytes .
- (BOOL) ccIsOverLimitFor : (CGFloat) fMBytes ;

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger , CCImageType) {
    CCImageType_Unknow = 0 ,
    CCImageType_JPEG ,
    CCImageType_PNG ,
    CCImageType_Gif ,
    CCImageType_Tiff ,
    CCImageType_WebP
};

@interface NSData (CCExtension_Image)

/// technically , you have to read all 8-Bytes length to specific an imageType .
/// for now , i just use the first to decide is type . (borrowed from SDWebImage) .
@property (nonatomic , readonly) CCImageType type ;

@end

#pragma mark - -----

@interface UIImageView (CCExtension_Gaussian)

/// using Accelerate

- (instancetype) ccGaussian ;
- (instancetype) ccGaussian : (CGFloat) fRadius;

@end