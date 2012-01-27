//
//  SZAppDelegate.h
//  NSFetchedResultsControllerSample
//
//  Created by Stephan Zehrer on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDataStore.h"

@interface SZAppDelegate : UIResponder <UIApplicationDelegate, SZDataStoreAppDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) SZDataStore *dataStore;

@property (readonly, strong, nonatomic) NSString *dataStoreFileName;
@property (readonly, strong, nonatomic) NSString *dataStoreModelName;

- (NSURL *)applicationDocumentsDirectory;

@end
