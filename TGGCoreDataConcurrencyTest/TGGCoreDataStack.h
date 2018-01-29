//
//  TGGCoreDataStack.h
//  TGGCoreDataConcurrencyTest
//
//  Created by Anon on 29/01/2018.
//  Copyright © 2018 Anon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGGCoreDataStack : NSObject
- (NSManagedObjectContext *) managedObjectContext;
- (void)saveContext;
@end
