//
//  ViewController.m
//  SORObjectRelationDemo
//
//  Created by xulinfeng on 2017/1/17.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "ViewController.h"
#import "SORBadgeValueManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIBarButtonItem *rootBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *homeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *messagesBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *randomBarButtonItem;

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    
    self.navigationItem.leftBarButtonItems = @[[self rootBarButtonItem], [self homeBarButtonItem], [self messagesBarButtonItem]];
    self.navigationItem.rightBarButtonItem = [self randomBarButtonItem];
    
    self.tableView.rowHeight = 44;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    SORBadgeValueManager *manager = [SORBadgeValueManager sharedManager];
    NSError *error = nil;
    [self registerObserveSyncRelation:[manager rootObjectRelation] countPicker:^(NSUInteger count) {
        self.rootBarButtonItem.title = @(count).stringValue;
    } error:&error];
    
    [self registerObserveSyncRelation:[manager messageObjectRelation] countPicker:^(NSUInteger count) {
        self.messagesBarButtonItem.title = @(count).stringValue;
    } error:&error];
    
    [self registerObserveSyncRelation:[manager homeObjectRelation] countPicker:^(NSUInteger count) {
        self.homeBarButtonItem.title = @(count).stringValue;
    } error:&error];
}

- (UIBarButtonItem *)rootBarButtonItem{
    if (!_rootBarButtonItem) {
        _rootBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRoot:)];
    }
    return _rootBarButtonItem;
}

- (UIBarButtonItem *)homeBarButtonItem{
    if (!_homeBarButtonItem) {
        _homeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickHome:)];
    }
    return _homeBarButtonItem;
}

- (UIBarButtonItem *)messagesBarButtonItem{
    if (!_messagesBarButtonItem) {
        _messagesBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleDone target:self action:@selector(didClickMessages:)];
    }
    return _messagesBarButtonItem;
}

- (UIBarButtonItem *)randomBarButtonItem{
    if (!_randomBarButtonItem) {
        _randomBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"random" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRandom:)];
    }
    return _randomBarButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    } else {
        [cell clearAllRegisteredSyncRelations];
    }
    NSString *key = @(indexPath.row).stringValue;
    
    cell.textLabel.text = key;
    
    SORSyncCountObjectRelation *relation = [[SORBadgeValueManager sharedManager] normalMessageObjectRelationWithChatID:key];
    NSError *error = nil;
    [cell registerObserveSyncRelation:relation countPicker:^(NSUInteger count) {
        cell.detailTextLabel.text = @(count).stringValue;
    } error:&error];
    
    return cell;
}

#pragma mark - actions

- (IBAction)didClickRoot:(id)sender{
    
    SORBadgeValueManager *manager = [SORBadgeValueManager sharedManager];
    
    [[manager rootObjectRelation] clean];
}

- (IBAction)didClickHome:(id)sender{
    
    SORBadgeValueManager *manager = [SORBadgeValueManager sharedManager];
    
    [[manager homeObjectRelation] clean];
}

- (IBAction)didClickMessages:(id)sender{
    
    SORBadgeValueManager *manager = [SORBadgeValueManager sharedManager];
    
    [[manager messageObjectRelation] clean];
}

- (IBAction)didClickRandom:(id)sender{
    
    SORBadgeValueManager *manager = [SORBadgeValueManager sharedManager];
    
    NSString *key = @(arc4random() % 10).stringValue;
    
    SORSyncCountObjectRelation *relation = [manager normalMessageObjectRelationWithChatID:key];
    
    [relation syncUpCountOffset:1];
    
    SORSyncCountObjectRelation *homeRelation = [manager homeObjectRelation];
    
    [homeRelation syncUpCountOffset:arc4random() % 10];
}

@end
