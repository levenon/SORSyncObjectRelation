//
//  SORSyncObjectRelation+ObjectRelationObserver.h
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/2/14.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORSyncObjectRelation.h"
#import "SORSyncCountObjectRelation.h"
#import "SORSyncMajorKeyCountObjectRelation.h"

@interface NSObject (SyncObjectRelationObserver)

- (BOOL)registerObserveSyncRelation:(SORSyncObjectRelation *)relation picker:(void (^)(id value))picker error:(NSError **)error;

- (void)clearAllRegisteredSyncRelations;

@end

@interface NSObject (SORSyncCountObjectRelation)

- (BOOL)registerObserveSyncRelation:(SORSyncCountObjectRelation *)relation countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error;

@end
