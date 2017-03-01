//
//  SORSyncCountObjectRelation.m
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncCountObjectRelation.h"

@interface SORSyncObjectRelation (Private)

@property (nonatomic, strong) id value;

@end

@implementation SORSyncCountObjectRelation

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer __deprecated;{
    return [super relationWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer __deprecated;{
    return [super initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error __deprecated{
    return [super registerObserverNamed:name picker:picker error:error];
}

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;{
    return [[self alloc] initWithName:name defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;{
    return [super initWithName:name defaultValue:@(defaultCount) valueTransformer:SORSyncObjectRelationDefaultValueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(NSInteger count))countPicker error:(NSError **)error;{
    return [super registerObserverNamed:name picker:^(id value) {
        if (countPicker) {
            countPicker([value integerValue]);
        }
    } error:error];
}

- (void)setValue:(id)value{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSInteger count = MAX([value integerValue], 0);
        if (count != [self count]) {
            [super setValue:@(count)];
        }
    }
}

- (void)setCount:(NSInteger)count{
    [self setValue:@(count)];
}

- (NSInteger)count {
    return [[self value] integerValue];
}

- (void)clean{
    [self syncUpCountOffset:-[self count]];
    [super clean];
}

- (void)syncUpCountOffset:(NSInteger)countOffset;{
    [super syncUpOffset:@(countOffset)];
}

@end
