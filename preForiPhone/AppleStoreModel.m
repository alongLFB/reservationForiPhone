//
//  AppleStoreModel.m
//  preForiPhone
//
//  Created by 李阿龙 on 2020/10/26.
//

#import "AppleStoreModel.h"
#import <YYModel/YYModel.h>

@implementation AppleStoreModel

#pragma mark - 序列化和反序列化
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

#pragma mark - 实现copy方法（实现深拷贝）
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

#pragma mark -重写hash、isEqual:和description方法
- (NSUInteger)hash {
    return [self yy_modelHash];
}

@end
