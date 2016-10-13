//
//  WuCNetworkFormData.h
//  WuCMusic
//
//  Created by Hello World on 16/5/28.
//  Copyright © 2016年 allthings_LuYD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WuCNetworkFormData : NSObject

/**
 *  data
 */
@property(nonatomic,copy) NSData * data;

/**
 *  名字
 */
@property(nonatomic,copy)NSString * name;

/**
 *  文件名
 */
@property(nonatomic,copy)NSString * fileName;

/**
 *  文件类型
 */
@property(nonatomic,copy)NSString * mimeType;
/**
 *  快速创建
 */
+ (WuCNetworkFormData *)formDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

+ (WuCNetworkFormData *)formDataWithImg:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName scale:(CGFloat)scale;

@end
