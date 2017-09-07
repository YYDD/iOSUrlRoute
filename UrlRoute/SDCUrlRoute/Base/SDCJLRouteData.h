//
//  SDCJLRouteData.h
//  UrlRouteSample
//
//  Created by YYDD on 2017/9/6.
//  Copyright © 2017年 com.shudong.urlRoute. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RouteCallBack)(BOOL isWeb,NSString *urlStr,UIViewController *vc);

@interface SDCJLRouteData : NSObject

+ (SDCJLRouteData *)sharedData;

+ (BOOL)registerRoutesWithFile:(NSString *)filePath;

@property(nonatomic,copy)RouteCallBack routeCallBackBlock;

- (void)goRouteWithUrl:(NSString *)urlStr WithExtraParameters:(NSDictionary *)param;


@end
