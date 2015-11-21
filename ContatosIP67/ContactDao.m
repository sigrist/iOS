//
//  ContactDao.m
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import "ContactDao.h"

@implementation ContactDao
// Static reference to the ContactDao
static ContactDao *defaultDao = nil;

+(ContactDao *)contactDaoInstance {
    if (!defaultDao) {
        defaultDao = [ContactDao new];
        // Create the default contacts
        [defaultDao createDefaultContacts];
        [defaultDao loadContacts];
    }
    
    return defaultDao;
}
- (Contact *) createNewContact {
    Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    
    return contact;
}


- (void) createDefaultContacts {
    Contact *contact;
    NSString *defaultKey = @"default_key";
    NSUserDefaults *configs = [NSUserDefaults standardUserDefaults];
    
    if (![configs boolForKey:defaultKey]) {
    
        // Create contacts
        contact = [self createNewContact];
        
        contact.name = @"Default 1";
        contact.email = @"default1@defaul.com";
        contact.address = @"Default Street, 1";
        contact.site = @"http://www.default.com/1";
        contact.phone = @"+55 19 987458669";
        contact.latitude = [NSNumber numberWithDouble:-23.5883034];
        contact.longitude = [NSNumber numberWithDouble:-46.632369];
        
        [self saveContext];
        // Save the defaultKey to yes to tell the contacts is already there
        [configs setBool:YES forKey:defaultKey];
        // Save to file system
        [configs synchronize];
    }
    
}

-(ContactDao *) init {
    self = [super init];
    
    if (self) {
        _contacts = [NSMutableArray new];
    }
    return self;
}


-(void) addContacts:(Contact *)contact {
    [self.contacts addObject:contact];
}

-(NSInteger) total {
    return self.contacts.count;
}

-(Contact *)get:(NSInteger)index {
    return self.contacts[index];
}

- (void)remove:(NSInteger)index {
    [self.contacts removeObjectAtIndex:index];
}

-(NSInteger) searchContactPosition:(Contact *)contact {
    return [self.contacts indexOfObject:contact];
}

- (void) loadContacts {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    request.sortDescriptors = @[sort];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    _contacts = [results mutableCopy];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "br.org.venturus.ContatosIP67" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ContatosIP67" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ContatosIP67.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
