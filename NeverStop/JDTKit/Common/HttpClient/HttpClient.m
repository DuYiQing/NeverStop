//
//  HttpClient.m
//  EAKit
//
//  Created by Eiwodetianna on 16/9/20.
//  Copyright © 2016年 Eiwodetianna. All rights reserved.
//

#import "HttpClient.h"

#import "AFNetworking.h"
@implementation HttpClient

+ (void)GET:(NSString *)url body:(id)body headerFile:(NSDictionary *)headers response:(JYX_ResponseStyle)responseStyle success:(successBlock)success failure:(failureBlock)failure{
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"Loading";
    
    [hud showAnimated:YES];
    
    //1.设置网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求头
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //创建返回值类型
    switch (responseStyle) {
        case JYX_JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case JYX_XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case JYX_DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    //4.设置响应类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    //5.UTF8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@", url);
    //6.使用AFN进行网络请求
    [manager GET:url parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            // 隐藏系统风火轮
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [hud hideAnimated:YES];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [hud hideAnimated:YES];
        if (error) {
            failure(error);
            
        }
    }];
}






+ (void)POST:(NSString *)url body:(id)body bodyStyle:(JYX_RequestStyle)bodyStyle headerFile:(NSDictionary *)headers response:(JYX_ResponseStyle)responseStyle success:(successBlock)success failure:(failureBlock)failure{
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"Loading";
    
    [hud showAnimated:YES];

    //1.设置网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置body 数据类型
    switch (bodyStyle) {
        case JYX_BodyJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case JYX_BodyString:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable * _Nullable error) {
                return parameters;
            }];
            break;
        default:
            break;
    }
    //3.设置请求头
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //创建返回值类型
    switch (responseStyle) {
        case JYX_JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case JYX_XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case JYX_DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    //4.设置响应类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    //5.UTF8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //6.使用AFN进行网络请求
    
    [manager POST:url parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏系统风火轮
        if (responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud hideAnimated:YES];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hud hideAnimated:YES];
            failure(error);
        }

    }];
    
    
}



@end
