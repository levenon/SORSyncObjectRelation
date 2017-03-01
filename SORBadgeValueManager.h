//
//  SORBadgeValueManager.h
//  SORSyncObjectRelation
//
//  Created by xulinfeng on 2017/1/11.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SORObjectRelation/SORObjectRelationUmbrella.h>

extern NSString * const SORObjectRelationRootName;
extern NSString * const SORObjectRelationNormalMessageDomainName;

@interface SORBadgeValueManager : NSObject

/**
 *  name: com.SORSyncObjectRelation.object.relation.root
 */
@property (nonatomic, strong, readonly) SORSyncCountObjectRelation *rootObjectRelation;

/**
 *  root.home
 */
@property (nonatomic, strong, readonly) SORSyncCountObjectRelation *homeObjectRelation;

/**
 *  root.message
 *  
 *  普通聊天消息 归属于 root.message
 *  domain：root.message.normal.messages SORObjectRelationNormalMessageDomainName
 *  name construct: root.message.normal.messages##chatID    SORMajorKeyCountObjectRelation
 */
@property (nonatomic, strong, readonly) SORSyncCountObjectRelation *messageObjectRelation;

- (SORSyncMajorKeyCountObjectRelation *)normalMessageObjectRelationWithChatID:(NSString *)chatID;

+ (instancetype)sharedManager;

@end

@interface NSObject (BadgeValueObjectRelation)

@property (nonatomic, strong, readonly) SORSyncCountObjectRelation *badgeValueObjectRelation;

@end
