//
//  SDCJLRouteData.m
//  UrlRouteSample
//
//  Created by YYDD on 2017/9/6.
//  Copyright © 2017年 com.shudong.urlRoute. All rights reserved.
//

#import "SDCJLRouteData.h"
#import <JLRoutes.h>

#import "SDCUrlRouteMapping.h"
#import "UIViewController+SDCUrlRoute.h"
#import "SDCWebManager.h"

typedef void (^RouteCheckBlock)(NSString *routeUrlStr,NSDictionary *parameters);

@interface SDCJLRouteData()

@property(nonatomic,strong)SDCUrlRouteMapping *routeMapping;

@property(nonatomic,copy)RouteCheckBlock routeCheckBlock;

@end

@implementation SDCJLRouteData

+(SDCJLRouteData *)sharedData {

    static SDCJLRouteData *routeData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!routeData) {
            routeData = [[SDCJLRouteData alloc]init];
        }
    });
    return routeData;
}


+(BOOL)registerRoutesWithFile:(NSString *)filePath {

    [[SDCJLRouteData sharedData]addMappingFilePath:filePath];
    [[SDCJLRouteData sharedData]addAllRoutes];

    return YES;
}

-(void)addAllRoutes {

    __weak typeof(self) weakSelf = self;
    [[JLRoutes globalRoutes]addRoutes:self.routeMapping.mappingData.allKeys handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        [weakSelf goRouteWithParameters:parameters];
        return YES;
    }];
    
}

-(void)goRouteWithParameters:(NSDictionary *)parameters {
    
    NSString *routePattern = parameters[JLRoutePatternKey];
    
    if (self.routeCheckBlock) {

        self.routeCheckBlock(routePattern, parameters);
        return;
    }
    
    NSArray *routePatternArray = self.routeMapping.mappingData.allKeys;
    if ([routePatternArray containsObject:routePattern]) {

        NSString *className = self.routeMapping.mappingData[routePattern];
        if ([self isWebUrl:className]) {
            //是网页
            UIViewController *vc = [SDCWebManager createWebVCWithUrl:className WithTitle:nil];
            vc.routeUrlStr = routePattern;
            if (_routeCallBackBlock) {
                _routeCallBackBlock(YES,className,vc);
            }
            
        }else {
            
            Class class = nil;
            if (className) {
                class = NSClassFromString(className);
            }
            UIViewController *vc = nil;
#pragma clang diagnostic ignored "-Warc-createdRouteVCWithParams:-leaks"
            if ([class respondsToSelector:@selector(createdRouteVCWithParams:)]) {
                vc = [class createdRouteVCWithParams:nil];
            }
            
            for (NSString *key in parameters) {
                
                if ([key isEqualToString:JLRoutePatternKey] || [key isEqualToString:JLRouteURLKey] || [key isEqualToString:JLRouteSchemeKey] || [key isEqualToString:JLRouteWildcardComponentsKey] || [key isEqualToString:JLRoutesGlobalRoutesScheme]) {
                    continue;
                }
                
                [vc setValue:parameters[key] forKey:key];
            }
            
            vc.routeUrlStr = routePattern;
            if (_routeCallBackBlock) {
                _routeCallBackBlock(NO,nil,vc);
            }
        }
     }
}

-(void)goRouteWithUrl:(NSString *)urlStr WithExtraParameters:(NSDictionary *)param {
        
    if ([[JLRoutes globalRoutes]canRouteURL:[NSURL URLWithString:urlStr]]) {
        [[JLRoutes globalRoutes]routeURL:[NSURL URLWithString:urlStr] withParameters:param];
    }else {
        //没有注册路由
        if ([self isWebUrl:urlStr]) {
            
            if ([urlStr containsString:@"?"]) {

                NSArray *allKeys = param.allKeys;
                if (allKeys.count != 0) {
                    urlStr = [urlStr stringByAppendingString:@"?"];
                }
            }

            NSArray *allKeys = param.allKeys;
            for (NSString *key in allKeys) {
                
                NSUInteger index = [allKeys indexOfObject:key];
                if (index != 0) {
                    urlStr = [urlStr stringByAppendingString:@"&"];
                }
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,param[key]?:@""]];
            }
            
            UIViewController *vc = [SDCWebManager createWebVCWithUrl:urlStr WithTitle:nil];
            vc.routeUrlStr = urlStr;
            if (_routeCallBackBlock) {
                _routeCallBackBlock(YES,urlStr,vc);
            }
            
        }else {
            //错误页面
            if (_routeCallBackBlock) {
                _routeCallBackBlock(NO,nil,nil);
            }
        }
    }
}


- (void)checkRouteWithUrl:(NSString *)urlStr WithExtraParameters:(NSDictionary *)param WithBlock:(void (^)(NSString *routeUrlStr))block{

    self.routeCheckBlock = ^(NSString *routeUrlStr, NSDictionary *parameters) {
      
        if (block) {
            block(routeUrlStr);
        }
    };
    [self goRouteWithUrl:urlStr WithExtraParameters:param];

}


//读取对应的列表
-(SDCUrlRouteMapping *)routeMapping {
    if (!_routeMapping) {
        _routeMapping = [[SDCUrlRouteMapping alloc]init];
    }
    return _routeMapping;
}

-(void)addMappingFilePath:(NSString *)filePath {
    
    self.routeMapping.mappingFilePath = filePath;

}


//判断是否是网址
-(BOOL)isWebUrl:(NSString *)urlKey
{
    if (!urlKey) {
        return NO;
    }
    //先这样简单的判断 还有ftp:// 什么的
    if ([self checkUrlPathValid:urlKey]) {
        return YES;
    }
  
    return NO;
}

-(BOOL)checkUrlPathValid:(NSString *)urlStr
{
    if (urlStr) {
        
        if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
            return YES;
        }
        
        NSString *regx = @"(http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&amp;*+?:_/=<>]*)?";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
        return [predicate evaluateWithObject:urlStr];
        
    }
    return NO;
}




@end
