//
//  SORSyncCountObjectRelation.h
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncObjectRelation.h"

#define SORSyncObjectRelationDefaultValueTransformer     ^(id value, id base, id offset){                        \
                                                            NSMutableArray *values = [NSMutableArray array];    \
                                                            if (value) [values addObject:value];                \
                                                            if (base) [values addObject:base];                  \
                                                            if (offset) [values addObject:offset];              \
                                                            return [values valueForKeyPath:@"@sum.floatValue"]; \
                                                        }

@interface SORSyncCountObjectRelation : SORSyncObjectRelation

@property (nonatomic, assign) NSInteger count;

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer __deprecated;
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer __deprecated;
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error __deprecated;

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;
- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;

- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(NSInteger count))countPicker error:(NSError **)error;

- (void)syncUpCountOffset:(NSInteger)countOffset;

@end
