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
@class SZDataSource;

@interface SZMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) SZDataSource *dataSource;




@end
