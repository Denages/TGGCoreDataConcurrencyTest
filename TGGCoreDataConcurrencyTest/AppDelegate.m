//
//  AppDelegate.m
//  TGGCoreDataConcurrencyTest
//
//  Created by Anon on 29/01/2018.
//  Copyright © 2018 Anon. All rights reserved.
//

#import "AppDelegate.h"
#import "HumanMO+CoreDataProperties.h"
#import "TGGCoreDataStack.h"
@interface AppDelegate ()
@property (strong, nonatomic, nonnull) TGGCoreDataStack *coreDataStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.coreDataStack = [[TGGCoreDataStack alloc] init];
    
    //Populating datebase
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.coreDataStack.managedObjectContext;
    NSLog(@"Calling thread(should be main): %@", [NSThread currentThread]);
    
    [backgroundContext performBlockAndWait:^{
        NSLog(@"Executing thread(sync): %@", [NSThread currentThread]);
        HumanMO *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:backgroundContext];
        human.fullName = @"Anon(sync)";
        human.weigth = 90;
        human.birthDate = [NSDate date];
        NSError *error = nil;
        if ([backgroundContext hasChanges] && ![backgroundContext save:&error]) {
            NSLog(@"Error while creating human: %@", error);
        }
        [self.coreDataStack saveContext];
    }];
    
    [backgroundContext performBlock:^{
        NSLog(@"Executing thread(async, should be background): %@", [NSThread currentThread]);
        HumanMO *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:backgroundContext];
        human.fullName = @"Anon(async)";
        human.weigth = 90;
        human.birthDate = [NSDate date];
        NSError *error = nil;
        if ([backgroundContext hasChanges] && ![backgroundContext save:&error]) {
            NSLog(@"Error while creating human: %@", error);
        }
        [self.coreDataStack saveContext];
    }];
    return YES;
}

@end
