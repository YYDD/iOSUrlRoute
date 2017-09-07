//
//  SDCUrlRouteCenter+DataReload.m
//  newCampus
//
//  Created by YYDD on 16/3/15.
//  Copyright © 2016年 com.shudong.urlRoute. All rights reserved.
//

#import "SDCUrlRouteCenter+DataReload.h"

#import "SDCJLRouteData.h"
#import "SDCUrlRouteCenter_Protect.h"

@implementation SDCUrlRouteCenter (DataReload)

/**
 *  url跳转   默认是push 操作
 *
 *  @param urlkey   跳转路径（可以是网址、也可以是协议）
 *  @param animated 是否需要动画
 */
- (void)open:(NSString *)urlkey
    animated:(BOOL)animated
WithReloadBlock:(DataReCallBlock)block
{
    [self open:urlkey animated:animated URLRedirectType:kUrlRedirectPush extraParams:nil WithReloadBlock:block];
}

/**
 *  url跳转   默认是push操作
 *
 *  @param urlkey      跳转路径（可以是网址、也可以是协议）
 *  @param animated    是否需要动画
 *  @param extraParams 额外的参数
 */
- (void)open:(NSString *)urlkey
    animated:(BOOL)animated
 extraParams:(NSDictionary *)extraParams
WithReloadBlock:(DataReCallBlock)block
{
    [self open:urlkey animated:animated URLRedirectType:kUrlRedirectPush extraParams:extraParams WithReloadBlock:block];
}


/**
 *  url跳转
 *
 *  @param urlkey   跳转路径（可以是网址、也可以是协议）
 *  @param animated 是否需要动画
 *  @param type     跳转动作
 */
- (void)open:(NSString *)urlkey
    animated:(BOOL)animated
URLRedirectType:(UrlRedirectType)type
WithReloadBlock:(DataReCallBlock)block
{
    [self open:urlkey animated:animated URLRedirectType:type extraParams:nil WithReloadBlock:block];
}

/**
 *  url跳转
 *
 *  @param urlkey      跳转路径（可以是网址、也可以是协议）
 *  @param animated    是否需要动画
 *  @param type        跳转动作
 *  @param extraParams 额外的参数
 */
- (void)open:(NSString *)urlkey
    animated:(BOOL)animated
URLRedirectType:(UrlRedirectType)type
 extraParams:(NSDictionary *)extraParams
WithReloadBlock:(DataReCallBlock)block
{
    if (urlkey.length == 0) {
        return;
    }
    
    [SDCJLRouteData sharedData].routeCallBackBlock = ^(BOOL isWeb, NSString *urlStr, UIViewController *vc) {
        
        if (isWeb) {
            [self goToWeb:urlStr animated:animated URLRedirectType:type];
        }else {
            vc.routeReCallBlock = block;
            [self goToVC:vc animated:animated URLRedirectType:type];
        }
    };
    [[SDCJLRouteData sharedData]goRouteWithUrl:urlkey WithExtraParameters:extraParams];

}




@end
