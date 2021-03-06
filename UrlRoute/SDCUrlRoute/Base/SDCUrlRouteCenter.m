//
//  SDCUrlRouteCenter.m
//  newCampus
//
//  Created by YYDD on 16/3/10.
//  Copyright © 2016年 com.shudong.urlRoute. All rights reserved.
//

#import "SDCUrlRouteCenter.h"
#import "SDCJLRouteData.h"

#import "UIApplication+SDCUrlRoute.h"
#import "UIViewController+SDCUrlRoute.h"

#import "SDCWebManager.h"
#import "SDCUrlRouteCenter_Config.h"
#import "SDCUrlRouteCenter_Protect.h"

NSString* localRouteUrl(NSString *routekey) {

    return routekey;

};


@implementation SDCUrlRouteCenter

+(SDCUrlRouteCenter *)sharedCenter
{
    static SDCUrlRouteCenter *urlRouteCenter = nil;
    if (urlRouteCenter == nil)
    {
        urlRouteCenter = [[self alloc]init];
    }
    return urlRouteCenter;
}

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}


-(void)open:(NSString *)urlkey animated:(BOOL)animated
{
    [self open:urlkey animated:animated URLRedirectType:kUrlRedirectPush];
}

-(void)open:(NSString *)urlkey animated:(BOOL)animated URLRedirectType:(UrlRedirectType)type
{
    [self open:urlkey animated:animated URLRedirectType:type extraParams:nil];
}

-(void)open:(NSString *)urlkey animated:(BOOL)animated extraParams:(NSDictionary *)extraParams
{
    [self open:urlkey animated:animated URLRedirectType:kUrlRedirectPush extraParams:extraParams];
}

-(void)open:(NSString *)urlkey animated:(BOOL)animated URLRedirectType:(UrlRedirectType)type extraParams:(NSDictionary *)extraParams
{
    if ([urlkey isKindOfClass:[NSURL class]]) {
       urlkey = [((NSURL *)urlkey) absoluteString];
    }
    
    [SDCJLRouteData sharedData].routeCallBackBlock = ^(BOOL isWeb, NSString *urlStr, UIViewController *vc) {

        [self goToVC:vc animated:animated URLRedirectType:type];
    };
    [[SDCJLRouteData sharedData]goRouteWithUrl:urlkey WithExtraParameters:extraParams];
}



-(void)closeWithAnimated:(BOOL)animated
{
    [self close:nil animated:animated];
}

-(void)close:(NSString *)url animated:(BOOL)animated
{
    
    if (!url) {
        
        if ([UIApplication sharedApplication].currentViewController.navigationController && [UIApplication sharedApplication].currentViewController.navigationController.childViewControllers.count > 1) {
            
            [self popToVC:nil animated:animated];
            
        }else {
            [self dismissToVC:nil animated:animated];
        }
        
        return;
    }
    
    [SDCJLRouteData sharedData].routeCallBackBlock = ^(BOOL isWeb, NSString *urlStr, UIViewController *vc) {

        if (vc) {
            if ([UIApplication sharedApplication].currentViewController.navigationController && [UIApplication sharedApplication].currentViewController.navigationController.childViewControllers.count > 1) {

                [self goToVC:vc animated:animated URLRedirectType:kUrlRedirectPop];

            }else {
                
                [self goToVC:vc animated:animated URLRedirectType:kUrlRedirectDismiss];
            }
        }
    };
    [[SDCJLRouteData sharedData]goRouteWithUrl:url WithExtraParameters:nil];


}


#pragma mark Method

- (void)goToWeb:(NSString *)urlStr animated:(BOOL)animated URLRedirectType:(UrlRedirectType)type {

    UIViewController *vc = [SDCWebManager createWebVCWithUrl:urlStr WithTitle:nil];
    [self goToVC:vc animated:animated URLRedirectType:type];
}

- (void)goToVC:(UIViewController *)vc animated:(BOOL)animated URLRedirectType:(UrlRedirectType)type {

    switch (type) {
        case kUrlRedirectPop:
            [self popToVC:vc animated:animated];
            break;
        case kUrlRedirectPush:
            [self pushToVC:vc animated:animated];
            break;
        case kUrlRedirectPresent:
            [self presentToVC:vc animated:animated];
            break;
        case kUrlRedirectDismiss:
            [self dismissToVC:vc animated:animated];
            break;
        default:
            [self goToErrorVC];
            break;
    }
}


-(void)popToVC:(UIViewController *)vc animated:(BOOL)animated
{
    if (!vc) {
        SDCRoutePopVC(animated);
    }else
    {
        SDCRoutePopToVC(vc, animated);
    }
}

-(void)pushToVC:(UIViewController *)vc animated:(BOOL)animated
{
    if (vc) {
        SDCRoutePushToVC(vc, animated);
    }else
    {
        [self goToErrorVC];
    }
}

-(void)presentToVC:(UIViewController *)vc animated:(BOOL)animated
{
    if (vc) {
        SDCRoutePresentToVC(vc, animated);
    }else
    {
        [self goToErrorVC];
    }

}
   
-(void)dismissToVC:(UIViewController *)vc animated:(BOOL)animated
{
    SDCRouteDismissToVC(animated);
}


-(void)goToErrorVC
{
    NSLog(@"goToErrorVC");
}


+ (BOOL)registerRoutesWithFile:(NSString *)filePath {
    
   return [SDCJLRouteData registerRoutesWithFile:filePath];
}


         
@end
