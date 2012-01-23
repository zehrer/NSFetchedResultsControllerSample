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

#pragma mark Insert

- (Event *)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    Event *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[self.entityDescription name] inManagedObjectContext:self.managedObjectContext];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    if (self.currentEvent) {
        [self.currentEvent addSubItemsObject:newManagedObject]; 
    }
    
    [self saveManagedObjectContext];
    
    return newManagedObject;
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void) deleteObjectAtIndexPath:(NSIndexPath*)indexPath
{
    [self.managedObjectContext deleteObject:[self objectAtIndexPath:indexPath]];
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
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"self in %@",currentEvent.subItems]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"self in %@.subItems",self.currentEvent]];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
    self.fetchedResultsController = aFetchedResultsController;
    
    [self performFetch];
    
    return __fetchedResultsController;
} 

@end
