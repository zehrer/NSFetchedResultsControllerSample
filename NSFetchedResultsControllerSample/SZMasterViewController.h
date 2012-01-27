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
@class SZDataStore;
@class SZDataSource;

@interface SZMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) SZDataStore *dataStore;
@property (readonly, strong, nonatomic) SZDataSource *dataSource;


- (void) configureControllerWithDataStore:(SZDataStore *)dataStore;

@end
