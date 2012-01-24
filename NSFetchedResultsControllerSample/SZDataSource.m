//
//  SZDataSource.m
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZDataSource.h"
#import "Event.h"

@implementation SZDataSource

@synthesize managedObjectContext = __managedObjectContext;
@synthesize entityDescription = __entityDescription;
@synthesize fetchedResultsController = __fetchedResultsController;

@synthesize currentEvent = __currentEvent;

@synthesize fetchedResultsControllerDelegate;

#pragma mark - Init

- (id) initWithDelegate:(id<NSFetchedResultsControllerDelegate>) aFetchedResultsControllerDelegate andManagedObjectContext:(NSManagedObjectContext *) aManagedObjectContext
{
    self = [super init];
    if (self) {
        self.managedObjectContext = aManagedObjectContext;
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
    __entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    
    return __entityDescription;
}


#pragma mark Save

- (void) saveManagedObjectContext
{
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    
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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
    self.fetchedResultsController = aFetchedResultsController;
    
    [self performFetch];
    
    NSLog(@"Num: %i",self.currentEvent.subItems.count);
    NSLog(@"ID: %@",self.currentEvent.objectID);
    
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

- (void) deleteObjectAtIndexPath:(NSIndexPath*)indexPath
{
    Event *event = self.currentEvent;
    
    //[event removeSubItemsObject:[self objectAtIndexPath:indexPath]];
    [self.managedObjectContext deleteObject:[self objectAtIndexPath:indexPath]];
    
    NSLog(@"Num: %i",event.subItems.count);
    NSLog(@"ID: %@",self.currentEvent.objectID);
    
}

#pragma mark Insert

- (Event *)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    Event *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[self.entityDescription name] inManagedObjectContext:self.managedObjectContext];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    [self saveManagedObjectContext];
    
    if (self.currentEvent) {
        [self.currentEvent addSubItemsObject:newManagedObject]; 
    }
    
    [self saveManagedObjectContext];
    
    return newManagedObject;
}

-  (Event*)rootEvent 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent == NULL"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity =  self.entityDescription;
    fetchRequest.predicate = predicate;
    
    // TODO: better Error handling :)
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (fetchResult.count > 0)
        return [fetchResult lastObject];
    else
        return NULL;
}

@end
