//
//  WuCNetworkFormData.m
//  WuCMusic
//
//  Created by Hello World on 16/5/28.
//  Copyright © 2016年 allthings_LuYD. All rights reserved.
//

#import "WuCNetworkFormData.h"

@implementation WuCNetworkFormData

+ (WuCNetworkFormData *)formDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    WuCNetworkFormData * dataObj = [[WuCNetworkFormData alloc]init];
    dataObj.data = data;
    dataObj.name = name;
    dataObj.fileName = fileName;
    dataObj.mimeType = mimeType;
    return dataObj;
}

+ (WuCNetworkFormData *)formDataWithImg:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName scale:(CGFloat)scale {
    WuCNetworkFormData * dataObj = [[WuCNetworkFormData alloc]init];
    if (UIImagePNGRepresentation(image) == nil) {
        dataObj.data = UIImageJPEGRepresentation(image, scale);
        dataObj.mimeType = @"JPEG";
    }else {
        dataObj.data = UIImagePNGRepresentation(image);
        dataObj.mimeType = @"PNG";
    }
    dataObj.name = name;
    dataObj.fileName = fileName;
    return dataObj;
}

@end
