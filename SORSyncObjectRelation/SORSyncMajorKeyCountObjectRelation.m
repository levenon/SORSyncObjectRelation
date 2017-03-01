//
//  SORSyncMajorKeyCountObjectRelation.m
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncMajorKeyCountObjectRelation.h"

@interface SORSyncMajorKeyCountObjectRelation ()

@property (nonatomic, copy) NSString *objectID;

@end

@implementation SORSyncMajorKeyCountObjectRelation

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated{
    return [super relationWithName:name defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated{
    return [super initWithName:name defaultCount:defaultCount];
}

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;{
    return [[self alloc] initWithObjectID:objectID domain:domain defaultCount:defaultCount];
}

- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;{
    if (self = [super initWithName:[domain stringByAppendingString:objectID] defaultCount:defaultCount]) {
        self.objectID = objectID;
    }
    return self;
}

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    return [domain stringByAppendingString:objectID];
}

@end

@implementation SORSyncMajorKeyCountObjectRelation (Remove)

- (void)removeSubRelationWithObjectID:(NSString *)objectID{
    SORSyncObjectRelation *relation = [[[self subRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"objectID == %@", objectID]] firstObject];
    
    [self removeSubRelation:relation];
}

- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    [self removeSubRelationNamed:[SORSyncMajorKeyCountObjectRelation nameWithObjectID:objectID domain:domain]];
}

@end
