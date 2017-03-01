//
//  SORSyncObjectRelation.m
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncObjectRelation.h"

NSString * const SORSyncObjectRelationErrorDomain = @"com.objectRelation.domain";
NSString * const SORSyncObjectRelationObserverDefaultName = @"com.objectRelation.handle.default";

@interface SORSyncObjectRelationObserver ()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) void (^picker)(id value);

@end

@implementation SORSyncObjectRelationObserver

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id value))picker;{
    if (self = [super init]) {
        self.name = name;
        self.picker = picker;
    }
    return self;
}

@end

@interface SORSyncObjectRelation (){
    id _value;
}

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<SORSyncObjectRelation *> *mutableSubRelations;

@property (nonatomic, strong) NSMutableArray<SORSyncObjectRelationObserver *> *mutableObservers;

@property (nonatomic, strong) id value;

@property (nonatomic, strong) id base;

@property (nonatomic, strong) id detail;

@property (nonatomic, copy) id (^valueTransformer)(id value, id base, id offset);

@property (nonatomic, strong) NSMutableArray<SORSyncObjectRelation *> *mutableParentObjectRelations;

@end

@implementation SORSyncObjectRelation

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer;{
    return [[self alloc] initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(id value, id base, id offset))valueTransformer;{
    if (self = [self init]) {
        self.name = name;
        self.base = defaultValue;
        self.value = defaultValue;
        self.valueTransformer = valueTransformer;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.enable = YES;
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"value"];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error; {
    SORSyncObjectRelationObserver *existObserver = [self observerNamed:name];
    if (!existObserver) {
        [self _appendObserverNamed:name picker:picker];
    } else if (error){
        *error = [NSError errorWithDomain:SORSyncObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist observer named: %@.", name]}];
    }
    picker([self value]);
    return existObserver == nil;
}

- (void)removeObserverNamed:(NSString *)name; {
    SORSyncObjectRelationObserver *existObserver = [self observerNamed:name];
    if (existObserver) {
        [self _removeObserver:existObserver];
    }
}

- (BOOL)addSubRelation:(SORSyncObjectRelation *)subRelation error:(NSError **)error; {
    BOOL exist = [[self mutableSubRelations] containsObject:subRelation];
    if (!exist) {
        [self _appendSubRelation:subRelation error:error];
    } else if (error){
        *error = [NSError errorWithDomain:SORSyncObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist relation named: %@.", [subRelation name]]}];
    }
    return !exist;
}

- (void)removeSubRelation:(SORSyncObjectRelation *)subRelation; {
    [self _removeSubRelation:subRelation];
}

- (void)removeSubRelationNamed:(NSString *)subRelationName;{
    [self _removeSubRelation:[self subRelationNamed:subRelationName]];
}

- (void)removeAllSubRelations;{
    [self _removeAllSubRelations];
}

- (void)clean;{
    for (SORSyncObjectRelation *relation in [self mutableSubRelations]) {
        [relation clean];
    }
    self.value = nil;
}

- (void)removeFromParentObjectRelation;{
    [self clean];
    
    for (SORSyncObjectRelation *parentObjectRelation in [self mutableParentObjectRelations]) {
        [parentObjectRelation removeSubRelation:self];
    }
    [[self mutableParentObjectRelations] removeAllObjects];
}

- (void)syncUpOffset:(id)offset;{
    if ([self isEnable]) {
        [self _syncOffset:offset];
        
        for (SORSyncObjectRelation *parentObjectRelation in [self mutableParentObjectRelations]) {
            [parentObjectRelation syncUpOffset:offset];
        }
    }
}

- (void)_syncOffset:(id)offset;{
    id value = [self value];
    if ([self valueTransformer]) {
        value = self.valueTransformer([self value], [self base], offset);
    }
    self.value = value;
}

#pragma mark - protected

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context != (__bridge void *)(self)) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    } else if ([keyPath isEqualToString:@"value"]){
        id value = change[NSKeyValueChangeNewKey];
        if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        }
        [self _performObserverWithValue:value];
    }
}

#pragma mark - private

- (void)_appendObserverNamed:(NSString *)name picker:(void (^)(id value))picker {
    SORSyncObjectRelationObserver *observer = [[SORSyncObjectRelationObserver alloc] initWithName:name picker:picker];
    
    [[self mutableObservers] addObject:observer];
}

- (void)_removeObserver:(SORSyncObjectRelationObserver *)observer {
    [[self mutableObservers] removeObject:observer];
}

- (void)_appendSubRelation:(SORSyncObjectRelation *)subRelation error:(NSError **)error; {
    [[subRelation mutableParentObjectRelations] addObject:self];
    
    [[self mutableSubRelations] addObject:subRelation];
    [self _performObserver];
}

- (void)_removeSubRelation:(SORSyncObjectRelation *)subRelation{
    [[self mutableSubRelations] removeObject:subRelation];
    [self _performObserver];
}

- (void)_removeAllSubRelations{
    [[self mutableSubRelations] removeAllObjects];
    [self _performObserver];
}

- (void)_performObserver{
    [self _performObserverWithValue:[self value]];
}

- (void)_performObserverWithValue:(id)value{
    for (SORSyncObjectRelationObserver *observer in [self mutableObservers]) {
        if ([observer picker]) {
            observer.picker(value);
        }
    }
}

#pragma mark - accessor

- (id)subRelationNamed:(NSString *)name;{
    return [[[self mutableSubRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}

- (id)observerNamed:(NSString *)name{
    return [[[self mutableObservers] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}

- (NSMutableArray<SORSyncObjectRelation *> *)mutableSubRelations{
    if (!_mutableSubRelations) {
        _mutableSubRelations = [NSMutableArray array];
    }
    return _mutableSubRelations;
}

- (NSMutableArray<SORSyncObjectRelation *> *)mutableParentObjectRelations{
    if (!_mutableParentObjectRelations) {
        _mutableParentObjectRelations = [NSMutableArray array];
    }
    return _mutableParentObjectRelations;
}

- (NSArray<SORSyncObjectRelation *> *)parentObjectRelations{
    return [[self mutableParentObjectRelations] copy];
}

- (NSMutableArray<SORSyncObjectRelationObserver *> *)mutableObservers{
    if (!_mutableObservers) {
        _mutableObservers = [NSMutableArray array];
    }
    return _mutableObservers;
}

- (NSArray<SORSyncObjectRelation *> *)subRelations{
    return [[self mutableSubRelations] copy];
}

- (NSArray<SORSyncObjectRelationObserver *> *)observers{
    return [[self mutableObservers] copy];
}

- (void)setValue:(id)value{
    if (![_value isEqual:value]) {
        _value = value;
    }
}

@end
