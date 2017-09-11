//
//  HttpTool.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool
DEF_SINGLETON(HttpTool)

#pragma mark get请求
-(void)Get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary * dic = nil;
    NSString * Url = @"";
    if (params!=nil) {
        if ([params isKindOfClass:[NSString class]] ) {
            Url = [NSString stringWithFormat:@"%@%@",url,params];
             dic= [NSMutableDictionary dictionary];
        }
        else{
            Url = url;
            dic = [NSMutableDictionary dictionaryWithDictionary:params];
        }
    }else{
        Url = url;
        dic = [NSMutableDictionary dictionary];
    }
    [self requestWihtMethod:RequestMethodTypeGet url:Url params:dic success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
-(void)Get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure platform:(RequestPlatformType)platformType
{
    NSMutableDictionary * dic = nil;
    NSString * Url = @"";
    if (params!=nil) {
        if ([params isKindOfClass:[NSString class]] ) {
            Url = [NSString stringWithFormat:@"%@%@",url,params];
            dic= [NSMutableDictionary dictionary];
        }
        else{
            Url = url;
            dic = [NSMutableDictionary dictionaryWithDictionary:params];
        }
    }else{
        Url = url;
        dic = [NSMutableDictionary dictionary];
    }
    [self requestWihtMethod:RequestMethodTypeGet url:Url params:dic success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        if (err) {
            failure(err);
        }
    } requestPlatform:  platformType];

}

#pragma mark post请求
-(void)Post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //由于新增loginId故在此新加一个字典
    NSMutableDictionary * dic = nil;
    
    NSString * Url = @"";
    if (params != nil) {
        
        if ([params isKindOfClass:[NSString class]] ) {
            Url = [NSString stringWithFormat:@"%@%@",url,params];
            dic = [NSMutableDictionary dictionary];
        }
        else{
            Url = url;
            dic = [NSMutableDictionary dictionaryWithDictionary:params];
        }
        
    }
    else{
        Url = url;
        dic = [NSMutableDictionary dictionary];
    }
    
    [self requestWihtMethod:RequestMethodTypePost url:Url params:dic success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
    
    
}

-(void)Post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure platform:(RequestPlatformType)platformType
{
    //由于新增loginId故在此新加一个字典
    NSMutableDictionary * dic = nil;
    
    NSString * Url = @"";
    if (params != nil) {
        
        if ([params isKindOfClass:[NSString class]] ) {
            Url = [NSString stringWithFormat:@"%@%@",url,params];
            dic = [NSMutableDictionary dictionary];
        }
        else{
            Url = url;
            dic = [NSMutableDictionary dictionaryWithDictionary:params];
        }
        
    }
    else{
        Url = url;
        dic = [NSMutableDictionary dictionary];
    }
    
    [self requestWihtMethod:RequestMethodTypePost url:Url params:dic success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        if (err) {
            failure(err);
        }
    } requestPlatform:platformType];
    
}


#pragma mark 网络请求
- (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(id)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //是否信任服务器无效或过期的SSL证书。默认为“不”。
    securityPolicy.allowInvalidCertificates = YES;
    //是否验证域名证书的CN字段。默认为“是”。
    securityPolicy.validatesDomainName = NO;
    
    NSString * Url = [[NSString stringWithFormat:@"%@%@",self.baseUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"接口%@",Url);
    //获得请求管理者
    //AFHTTPRequestOperationManager* mgr = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    mgr.securityPolicy = securityPolicy;
    
    // 设置请求头
   // [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //设置超时时间
    mgr.requestSerializer.timeoutInterval = 20.5f;
    
    if ([url isEqualToString:checkNet]) {
        //设置服务端返回类型 二进制
         mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            
            [mgr GET:Url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@ error",error);
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:Url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"uploadProgress:%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            break;
    }
    
    
}

//网络请求（根据平台类型处理相应请求）
- (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(id)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
            requestPlatform:(RequestPlatformType)platformType
{
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //是否信任服务器无效或过期的SSL证书。默认为“不”。
    securityPolicy.allowInvalidCertificates = YES;
    //是否验证域名证书的CN字段。默认为“是”。
    securityPolicy.validatesDomainName = NO;
    NSString * Url=@"";
    //web平台
    if (platformType==RequestTypePlatformWeb) {
        Url = [[NSString stringWithFormat:@"%@%@",self.baseUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"接口%@",Url);
    }else if(platformType==RequestTypePlatformCommunication){
        //通信平台
        Url = [[NSString stringWithFormat:@"%@%@",self.serverUrl,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"接口%@",Url);
    }else{
        return;
    }
    
    
    //获得请求管理者
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    mgr.securityPolicy = securityPolicy;
    
    // 设置请求头
    // [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //设置超时时间
    mgr.requestSerializer.timeoutInterval = 20.5f;
    
    if ([url isEqualToString:checkNet]) {
        //设置服务端返回类型 二进制
        mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            
            [mgr GET:Url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@ error",error);
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:Url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"uploadProgress:%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            break;
    }

}

@end
