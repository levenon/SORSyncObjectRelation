//
//  SORSyncObjectRelation+ObjectRelationObserver.m
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncObjectRelation+ObjectRelationObserver.h"
#import <objc/runtime.h>

NSString * SORSyncObjectRelationObserverName(id observer){
    return [NSString stringWithFormat:@"%@%d", NSStringFromClass([observer class]), (int)observer];
}

@interface SORSyncObjectRelationObserverSetter : NSObject

@property (nonatomic, assign) id observer;

@property (nonatomic, strong) NSMutableArray<SORSyncObjectRelation *> *observedObjectRelations;

@end

@implementation SORSyncObjectRelationObserverSetter

- (NSMutableArray<SORSyncObjectRelation *> *)observedObjectRelations{
    if (!_observedObjectRelations) {
        _observedObjectRelations = [NSMutableArray array];
    }
    return _observedObjectRelations;
}

- (void)dealloc{
    [self clear];
}

- (void)clear{
    for (SORSyncObjectRelation *relation in [self observedObjectRelations]) {
        [relation removeObserverNamed:SORSyncObjectRelationObserverName([self observer])];
    }
}

@end

@interface NSObject (SORSyncObjectRelationObserverSetter)

@property (nonatomic, strong, readonly) SORSyncObjectRelationObserverSetter *syncObjectRelationObserverSetter;

@end

@implementation NSObject (SORSyncObjectRelationObserverSetter)

- (SORSyncObjectRelationObserverSetter *)syncObjectRelationObserverSetter{
    SORSyncObjectRelationObserverSetter *setter = objc_getAssociatedObject(self, @selector(syncObjectRelationObserverSetter));
    if (!setter) {
        setter = [SORSyncObjectRelationObserverSetter new];
        objc_setAssociatedObject(self, @selector(syncObjectRelationObserverSetter), setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return setter;
}

@end

@implementation NSObject (SyncObjectRelationObserver)

- (BOOL)registerObserveSyncRelation:(SORSyncObjectRelation *)relation picker:(void (^)(id value))picker error:(NSError **)error;{
    NSString *observerName = SORSyncObjectRelationObserverName(self);
    BOOL success = [relation registerObserverNamed:observerName picker:picker error:error];
    if (success) {
        self.syncObjectRelationObserverSetter.observer = self;
        [[[self syncObjectRelationObserverSetter] observedObjectRelations] addObject:relation];
    }
    return success;
}

- (void)clearAllRegisteredSyncRelations;{
    [[self syncObjectRelationObserverSetter] clear];
}

@end

@implementation NSObject (SORSyncCountObjectRelation)

- (BOOL)registerObserveSyncRelation:(SORSyncCountObjectRelation *)relation countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error; {
    return [self registerObserveSyncRelation:relation picker:^(id value) {
        countPicker([value integerValue]);
    } error:error];
}

@end
