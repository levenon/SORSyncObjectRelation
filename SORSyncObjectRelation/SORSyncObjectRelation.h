//
//  SORSyncObjectRelation.h
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SORSyncObjectRelationErrorDomain;
extern NSString * const SORSyncObjectRelationObserverDefaultName;

@interface SORSyncObjectRelationObserver : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) void (^picker)(id value);

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id value))picker;

@end

@interface SORSyncObjectRelation : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSArray<SORSyncObjectRelation *> *subRelations;

@property (nonatomic, strong, readonly) NSArray<SORSyncObjectRelationObserver *> *observers;

@property (nonatomic, strong, readonly) id value;

@property (nonatomic, strong, readonly) id base;

@property (nonatomic, strong, readonly) id object;

@property (nonatomic, strong, readonly) NSArray<SORSyncObjectRelation *> *parentObjectRelations;

@property (nonatomic, copy, readonly) id (^valueTransformer)(id value, id base, id offset);

// Synchronization will be forbidden if NO, default is YES. 
@property (nonatomic, assign, getter=isEnable) BOOL enable;

- (id)subRelationNamed:(NSString *)name;
- (id)observerNamed:(NSString *)name;

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer;
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer;

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error;
- (void)removeObserverNamed:(NSString *)name;

- (BOOL)addSubRelation:(SORSyncObjectRelation *)subRelation error:(NSError **)error;
- (void)removeSubRelation:(SORSyncObjectRelation *)subRelation;
- (void)removeSubRelationNamed:(NSString *)subRelationName;
- (void)removeAllSubRelations;

- (void)clean;
- (void)removeFromParentObjectRelation;

- (void)syncUpOffset:(id)offset;

@end
