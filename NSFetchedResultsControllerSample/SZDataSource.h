//
//  SZDataSource.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class SZDataStore;

@interface SZDataSource : NSObject

@property (weak, nonatomic) SZDataStore *dataStore;
@property (readonly, strong, nonatomic) NSEntityDescription *entityDescription;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) id<NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;

@property (strong, nonatomic) Event *currentEvent;

- (id) initWithDelegate:(id<NSFetchedResultsControllerDelegate>) aFetchedResultsControllerDelegate andDataStore:(SZDataStore *) aManagedObjectContext;

- (Event*)rootEvent;


- (Event*)insertNewObject;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void) deleteObjectAtIndexPath:(NSIndexPath*)indexPath;

- (void) performFetch;




@end
