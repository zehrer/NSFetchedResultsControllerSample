//
//  Event.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) Event *parent;
@property (nonatomic, retain) NSOrderedSet *subItems;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)insertObject:(Event *)value inSubItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubItemsAtIndex:(NSUInteger)idx;
- (void)insertSubItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubItemsAtIndex:(NSUInteger)idx withObject:(Event *)value;
- (void)replaceSubItemsAtIndexes:(NSIndexSet *)indexes withSubItems:(NSArray *)values;
- (void)addSubItemsObject:(Event *)value;
- (void)removeSubItemsObject:(Event *)value;
- (void)addSubItems:(NSOrderedSet *)values;
- (void)removeSubItems:(NSOrderedSet *)values;
@end
