//
//  SZDataSource.m
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZDataSource.h"
#import "SZDataStore.h"
#import "Event.h"

@implementation SZDataSource

@synthesize dataStore = __dataStore;
@synthesize entityDescription = __entityDescription;
@synthesize fetchedResultsController = __fetchedResultsController;

@synthesize currentEvent = __currentEvent;

@synthesize fetchedResultsControllerDelegate;

#pragma mark - Init

- (id) initWithDelegate:(id<NSFetchedResultsControllerDelegate>) aFetchedResultsControllerDelegate andDataStore:(SZDataStore *) aDataStore
{
    self = [super init];
    if (self) {
        self.dataStore = aDataStore;
        self.fetchedResultsControllerDelegate = aFetchedResultsControllerDelegate;
    }
    return self;    
}

#pragma mark - Entity

- (NSEntityDescription *) entityDescription
{
    if (__entityDescription != nil) {
        return __entityDescription;
    }
    __entityDescription = [self.dataStore entityDescriptionForName:@"Event"];
    
    return __entityDescription;
}



#pragma mark - Fetched results controller

- (void) performFetch
{
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
}


- (NSPredicate *) fetchPredicate
{
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"self in %@",currentEvent.subItems]];
    return [NSPredicate predicateWithFormat:@"self in %@.subItems",self.currentEvent];
}

- (NSArray *) sortDescriptors
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"num" ascending:NO];
    
    return [NSArray arrayWithObjects:sortDescriptor, nil];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    [fetchRequest setEntity:self.entityDescription];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Fetch Predicate
    [fetchRequest setPredicate:[self fetchPredicate]];
    
    // Sort
    [fetchRequest setSortDescriptors:[self sortDescriptors]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSManagedObjectContext *context = self.dataStore.managedObjectContext;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
    self.fetchedResultsController = aFetchedResultsController;
    
    [self performFetch];

    // log ordered relationship
    NSUInteger index = 0;
    for (Event *element in self.currentEvent.subItems) {
        NSLog(@"Event %u: %@",index, element.timeStamp.description);
        index++;
    }
    
    return __fetchedResultsController;
} 

#pragma mark Interface Data Source

- (NSInteger)numberOfSections
{
    return [[self.fetchedResultsController sections] count];    
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.fetchedResultsController objectAtIndexPath:indexPath]; 
}

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    NSMutableOrderedSet* orderedSet = [self.currentEvent mutableOrderedSetValueForKey:@"subItems"];
    
    NSInteger fromIndex = fromIndexPath.row;
    NSInteger toIndex = toIndexPath.row;

    // see  http://www.wannabegeek.com/?p=74
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:fromIndex];
    
    if (fromIndex > toIndex) {
		// we're moving up
		[orderedSet moveObjectsAtIndexes:indexes toIndex:toIndex];
	} else {
		// we're moving down
		[orderedSet moveObjectsAtIndexes:indexes toIndex:toIndex-[indexes count]];
	}
    
    [self.dataStore saveObjectContext];
}



- (void) deleteObjectAtIndexPath:(NSIndexPath*)indexPath
{
    //[event removeSubItemsObject:[self objectAtIndexPath:indexPath]];
    [self.dataStore.managedObjectContext deleteObject:[self objectAtIndexPath:indexPath]];
}

#pragma mark Insert

- (Event *)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    Event *newManagedObject = [self.dataStore insertNewObjectForEntityForName:[self.entityDescription name]];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setName:@"a"];
    
    [self.dataStore saveObjectContext];
    
    
    if (self.currentEvent) {
        
        // BUG: see http://stackoverflow.com/questions/7385439/problems-with-nsorderedset
        
        NSMutableOrderedSet* tempSet = [self.currentEvent mutableOrderedSetValueForKey:@"subItems"];
        [tempSet addObject:newManagedObject];
    }
    
    [self.dataStore saveObjectContext];
    
    return newManagedObject;
}

-  (Event*)rootEvent 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent == NULL"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity =  self.entityDescription;
    fetchRequest.predicate = predicate;
    
    // TODO: better Error handling :)
    NSArray *fetchResult = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (fetchResult.count > 0)
        return [fetchResult lastObject];
    else
        return NULL;
}

@end
