//
//  SZDataStore.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSEntityDescription;


@protocol SZDataStoreAppDelegate <NSObject>

- (NSURL *)applicationDocumentsDirectory;

- (NSString *) dataStoreFileName;
- (NSString *) dataStoreModelName;

@end

// To copy in the AppDelegate
//@property (readonly, strong, nonatomic) NSString *dataStoreFileName;
//@property (readonly, strong, nonatomic) NSString *dataStoreModelName;

@interface SZDataStore : NSObject

@property (readonly, weak, nonatomic) id<SZDataStoreAppDelegate> appDelegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


// Init
- (id)initWithAppDelegate:(id<SZDataStoreAppDelegate>)aAppDelegate;

// Core Data Common

- (NSEntityDescription*) entityDescriptionForName:(NSString *)entityName;
- (NSArray*)entityByDescription:(NSEntityDescription *)entityDescription byPredicate:(NSPredicate*)predicate;
- (void)saveObjectContext;

- (id)insertNewObjectForEntityForName:(NSString *)entityName;

@end
