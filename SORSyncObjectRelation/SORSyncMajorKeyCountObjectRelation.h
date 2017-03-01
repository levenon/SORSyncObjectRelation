//
//  SORSyncMajorKeyCountObjectRelation.h
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncCountObjectRelation.h"

@interface SORSyncMajorKeyCountObjectRelation : SORSyncCountObjectRelation

@property (nonatomic, copy, readonly) NSString *objectID;

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated;
- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated;

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;
- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end

@interface SORSyncMajorKeyCountObjectRelation (Remove)

- (void)removeSubRelationWithObjectID:(NSString *)objectID;

- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end
