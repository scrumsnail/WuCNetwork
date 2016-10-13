//
//  WuCNetworkManager.m
//  WuCMusic
//
//  Created by Hello World on 16/5/28.
//  Copyright © 2016年 allthings_LuYD. All rights reserved.
//

#import "WuCNetworkManager.h"

@interface WuCNetworkManager()
@property (nonatomic,copy)   NSString * url;
@property (nonatomic,assign) RequestType requestType;
@property (nonatomic,assign) RequestSerializer requestSerialize;
@property (nonatomic,assign) ResponseSerializer responseSerialize;
@property (nonatomic,copy)   id parameters;
@property (nonatomic,copy)   NSDictionary * httpHeader;
@property (nonatomic,assign) ApiVersion version;
@property (nonatomic,strong) WuCNetworkFormData * formData;
@end

@implementation WuCNetworkManager

+ (WuCNetworkManager *)manager {
    static WuCNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WuCNetworkManager alloc]init];
        [manager replace];
    });
    return manager;
}

- (WuCNetworkManager *(^)(NSString *))setRequest {
    return ^WuCNetworkManager* (NSString * url) {
        self.url = url;
        return self;
    };
}

- (WuCNetworkManager *(^)(RequestType))RequestType {
    return ^WuCNetworkManager* (RequestType type) {
        self.requestType = type;
        return self;
    };
}

- (WuCNetworkManager* (^)(id parameters))Parameters {
    return ^WuCNetworkManager* (id parameters) {
        self.parameters = parameters;
        return self;
    };
}
- (WuCNetworkManager *(^)(NSDictionary *))HTTPHeader {
    return ^WuCNetworkManager* (NSDictionary * HTTPHeaderDic) {
        self.httpHeader = HTTPHeaderDic;
        return self;
    };
}

- (WuCNetworkManager *(^)(RequestSerializer))RequestSerialize {
    return ^WuCNetworkManager* (RequestSerializer requestSerializer) {
        self.requestSerialize = requestSerializer;
        return self;
    };
}

- (WuCNetworkManager *(^)(ApiVersion))Version {
    return ^WuCNetworkManager * (ApiVersion version) {
        self.version = version;
        return self;
    };
}

- (WuCNetworkManager *(^)(ResponseSerializer))ResponseSerialize {
    return ^WuCNetworkManager* (ResponseSerializer responseSerializer) {
        self.responseSerialize = responseSerializer;
        return self;
    };
}

- (WuCNetworkManager *(^)(WuCNetworkFormData *))FormData {
    return ^ WuCNetworkManager * (WuCNetworkFormData * formData){
        self.formData = formData;
        return self;
    };
}

- (WuCNetworkManager *)setUpBeforeStart {
    WuCNetworkManager * manager = [[self class]manager];
    //设置请求头
    [self setupRequestSerializerWithManager:manager];
    [self setupHTTPHeaderWithManager:manager];
    //设置返回头
    [self setupResponseSerializerWithManager:manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    return manager;
}
//- (AFSecurityPolicy *)customSecurityPolicy
//{
//    //先导入证书，找到证书的路径
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Admin" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    
//    //AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
//    securityPolicy.pinnedCertificates = set;
//    
//    return securityPolicy;
//}
- (void)startRequestWithSuccess:(void (^)(id))success failure:(void (^)(NSError * error))failure {
    [self startRequestWithProgress:nil success:success failure:failure];
}

- (void)startRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError * error))failure {
    
    WuCNetworkManager * manager = [self setUpBeforeStart];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    NSString * url = [self setupUrl];
    switch (self.requestType) {
        case GET: {
            [manager GET:url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress != nil) {progress(downloadProgress);}else{}
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case POST: {
            if (self.formData) {
                [manager POST:url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    [formData appendPartWithFileData:self.formData.data name:self.formData.name fileName:self.formData.fileName mimeType:self.formData.mimeType];
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (progress != nil) {progress(uploadProgress);}else{}
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
            } else {
                [manager POST:url parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (progress != nil) {progress(uploadProgress);}else{}
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
            }
        }
            break;
            
        case PUT: {
            [manager PUT:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case PATCH: {
            [manager PATCH:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        default:
            break;
    }
    [self replace];
}

- (WuCNetworkManager *)setupRequestSerializerWithManager:(WuCNetworkManager *)manager {
    
    switch (self.requestSerialize) {
        case RequestSerializerJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case RequestSerializerHTTP: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (WuCNetworkManager *)setupResponseSerializerWithManager:(WuCNetworkManager *)manager {
    switch (self.responseSerialize) {
        case ResponseSerializerJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case ResponseSerializerHTTP: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (WuCNetworkManager *)setupHTTPHeaderWithManager:(WuCNetworkManager *)manager {
    for (NSString * key in self.httpHeader.allKeys) {
        [manager.requestSerializer setValue:self.httpHeader[key] forHTTPHeaderField:key];
    }
    return manager;
}

- (NSString *)setupUrl {
    NSString * version = @"";
    switch (self.version) {
        case V1: {
            version = @"v1";
        }
            break;
        case V2: {
            version = @"v2";
        }
            break;
        case NONE: {
            return self.url;
        }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@,%@",self.url,version];
}

//重置
- (void)replace {
    self.url = nil;
    self.version = NONE;
    self.requestType = GET;
    self.parameters = nil;
    self.httpHeader = nil;
    self.requestSerialize = RequestSerializerHTTP;
    self.responseSerialize = ResponseSerializerJSON;
    self.formData = nil;
}
@end
