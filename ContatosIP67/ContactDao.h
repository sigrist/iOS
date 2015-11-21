//
//  ContactDao.h
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"
@import UIKit;
@interface ContactDao : NSObject

// Strong reference and without the set method
@property (strong, readonly) NSMutableArray *contacts;

+(ContactDao *) contactDaoInstance;
-(void)addContacts:(Contact *) contact;
-(NSInteger) total;
-(Contact *) get:(NSInteger) index;
-(void) remove:(NSInteger) index;
-(NSInteger) searchContactPosition:(Contact *) contact;
- (Contact *) createNewContact;

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
