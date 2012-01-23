//
//  SZDataSource.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface SZDataSource : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSEntityDescription *entityDescription;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) id<NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;

@property (strong, nonatomic) Event *currentEvent;

- (id) initWithDelegate:(id<NSFetchedResultsControllerDelegate>) aFetchedResultsControllerDelegate andManagedObjectContext:(NSManagedObjectContext *) aManagedObjectContext;

- (void) saveManagedObjectContext;

- (Event*)rootEvent;
- (Event*)insertNewObject;

- (void) performFetch;


@end
