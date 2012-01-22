//
//  SZMasterViewController.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class Event;

@interface SZMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSEntityDescription *entityDescription;

@property (strong, nonatomic) Event *currentEvent;

- (Event *)insertNewObject;
- (void) saveManagedObjectContext;
- (void) performFetch;

@end
