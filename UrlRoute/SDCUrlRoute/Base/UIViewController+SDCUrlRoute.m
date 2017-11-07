//
//  UIViewController+SDCUrlRoute.m
//  UrlRouteSample
//
//  Created by YYDD on 16/7/4.
//  Copyright © 2016年 com.shudong.urlRoute. All rights reserved.
//

#import "UIViewController+SDCUrlRoute.h"
#import "UIApplication+SDCUrlRoute.h"
#import <objc/runtime.h>

static char routeReCallBlockKey;
static char routeUrlStrKey;

@implementation UIViewController (SDCUrlRoute)

@dynamic routeReCallBlock;
@dynamic routeUrlStr;

+(instancetype)createdRouteVCWithParams:(NSDictionary *)params
{
    return [[self alloc]init];
}


+(void)load
{
    //swizzle方法调换
    [UIViewController swizzleViewWillDisappear];
    [UIViewController swizzleViewDidLoad];
}


+(void)swizzleViewDidLoad
{
    SEL originalSelector = @selector(viewDidLoad);
    SEL swizzleSelector = @selector(trick_viewDidLoad);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSelector);
    
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

+(void)swizzleViewWillDisappear
{
    SEL originalSelector = @selector(viewWillDisappear:);
    SEL swizzleSelector = @selector(trick_viewWillDisappear:);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSelector);
    
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

-(void)trick_viewWillDisappear:(BOOL)animated
{
    
    [self trick_viewWillDisappear:animated];
    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
    if (mainB == [NSBundle mainBundle]) {
        [UIApplication sharedApplication].currentViewController = nil;
    }
}

-(void)trick_viewDidLoad
{
    [self trick_viewDidLoad];
    
    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
    if (mainB == [NSBundle mainBundle]) {
        [UIApplication sharedApplication].currentViewController = self;
    }
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


#pragma mark routeReCallBlock set&get

-(void)setRouteReCallBlock:(DataReCallBlock)routeReCallBlock
{
    objc_setAssociatedObject(self, &routeReCallBlockKey, routeReCallBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(DataReCallBlock)routeReCallBlock
{
    return objc_getAssociatedObject(self, &routeReCallBlockKey);
}


#pragma mark routeUrlStr set&get

- (void)setRouteUrlStr:(NSString *)routeUrlStr {

    objc_setAssociatedObject(self, &routeUrlStrKey, routeUrlStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)routeUrlStr {

    return objc_getAssociatedObject(self, &routeUrlStrKey);
}


@end
