//
//  STBaseMgr.m
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STBaseMgr.h"

static NSManagedObjectContext *_context = nil;

@interface STBaseMgr ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation STBaseMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"PunchCardModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *sqliteUrl = [[self documentDirectoryURL] URLByAppendingPathComponent:@"PunchCardModel.sqlite"];
        STLog(@"%@", sqliteUrl);
        NSError *error = nil;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteUrl options:nil error:&error];
        if (error) {
            STLog(@"falied to create persistentStoreCoordinator : %@", error.localizedDescription);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

- (NSURL *)documentDirectoryURL
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}


@end
