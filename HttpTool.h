//
//  HttpTool.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RequestMethodType){
    RequestMethodTypeGet=1,
    RequestMethodTypePost=2
};

typedef NS_ENUM(NSInteger,RequestPlatformType){
    RequestTypePlatformWeb=1,
    RequestTypePlatformCommunication=2
};

@interface HttpTool : NSObject
AS_SINGLETON(HttpTool)

@property(nonatomic,strong) NSString *baseUrl;
@property(nonatomic,strong) NSString *serverUrl;
@property(nonatomic,strong) NSString *pingtaiUrl;

@property(nonatomic,strong) NSString *pingtaiIp;//平台ip
@property(nonatomic,strong) NSString *pingtaiPort;//平台端口
@property(nonatomic,strong) NSString *serverIp;//
@property(nonatomic,strong) NSString *serverPort;

@property(nonatomic,assign) int checkPingtaiNet; //200:表示成功 500:失败
@property(nonatomic,assign) int checkSocketNet;//200:表示成功 500:失败

//get请求
- (void)Get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

//带平台判断的get请求
- (void)Get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure platform:(RequestPlatformType)platformType;

//post请求
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)Post:(NSString *)url params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
//带平台判断的post请求
- (void)Post:(NSString *)url params:(id)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure platform:(RequestPlatformType)platformType;
@end
