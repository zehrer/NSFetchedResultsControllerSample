//
//  Event.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet *subItems;
@property (nonatomic, retain) Event *parent;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addSubItemsObject:(Event *)value;
- (void)removeSubItemsObject:(Event *)value;
- (void)addSubItems:(NSSet *)values;
- (void)removeSubItems:(NSSet *)values;

@end
