//
//  SORBadgeValueManager.m
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/1/11.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "SORBadgeValueManager.h"

NSString * const SORObjectRelationRootName = @"com.SORSyncObjectRelation.object.relation.root";
NSString * const SORObjectRelationNormalMessageDomainName = @"root.message.normal.messages";

@interface SORBadgeValueManager ()

@property (nonatomic, strong) SORSyncCountObjectRelation *rootObjectRelation;

/**
 *  root.home
 */
@property (nonatomic, strong) SORSyncCountObjectRelation *homeObjectRelation;

/**
 *  root.message
 */
@property (nonatomic, strong) SORSyncCountObjectRelation *messageObjectRelation;

@end

@implementation SORBadgeValueManager

+ (void)load{
    [super load];
    
    [[self sharedManager] initialize];
}

+ (instancetype)sharedManager; {
    static SORBadgeValueManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    return sharedManager;
}

- (void)initialize{
}

#pragma mark - accessor

- (SORSyncCountObjectRelation *)rootObjectRelation{
    if (!_rootObjectRelation) {
        _rootObjectRelation = [SORSyncCountObjectRelation relationWithName:SORObjectRelationRootName defaultCount:0];
    }
    return _rootObjectRelation;
}

- (SORSyncCountObjectRelation *)homeObjectRelation{
    if (!_homeObjectRelation) {
        _homeObjectRelation = [SORSyncCountObjectRelation relationWithName:@"root.home" defaultCount:0];
        
        [[self rootObjectRelation] addSubRelation:_homeObjectRelation error:nil];
    }
    return _homeObjectRelation;
}

- (SORSyncCountObjectRelation *)messageObjectRelation{
    if (!_messageObjectRelation) {
        _messageObjectRelation = [SORSyncCountObjectRelation relationWithName:@"root.message" defaultCount:0];
        [[self rootObjectRelation] addSubRelation:_messageObjectRelation error:nil];
    }
    return _messageObjectRelation;
}

- (SORSyncMajorKeyCountObjectRelation *)normalMessageObjectRelationWithChatID:(NSString *)chatID;{
    NSParameterAssert(chatID);
    NSString *name = [SORSyncMajorKeyCountObjectRelation nameWithObjectID:chatID domain:SORObjectRelationNormalMessageDomainName];
    SORSyncMajorKeyCountObjectRelation *relation = [[self messageObjectRelation] subRelationNamed:name];
    if (!relation) {
        relation = [SORSyncMajorKeyCountObjectRelation relationWithObjectID:chatID domain:SORObjectRelationNormalMessageDomainName defaultCount:0];
        NSError *error = nil;
        [[self messageObjectRelation] addSubRelation:relation error:&error];
    }
    return relation;
}

@end

@implementation NSObject (BadgeValueObjectRelation)

- (SORSyncCountObjectRelation *)badgeValueObjectRelation{
    return nil;
}

@end
