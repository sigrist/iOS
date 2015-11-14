//
//  ContactsListViewController.m
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import "ContactsListViewController.h"

@interface ContactsListViewController ()
@property ContactDao *dao;
@property Contact *selectedContact;
@end

@implementation ContactsListViewController

static NSString *CONTAC_CELL = @"contactCell";

-(id) init {
    self = [super init];
    if (self) {
        // Setup the View Icon
        UIImage *icon = [UIImage imageNamed:@"lista-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:icon tag:0];
        self.tabBarItem = tabItem;
        
        // Create the addButton, calling self the method showFormContacView
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(showFormContactView)];

        // Set the title
        self.navigationItem.title = @"VNT Contacts";
        // Add the button
        self.navigationItem.rightBarButtonItem = addButton;
        // The view already have the 'edit' button ready, just add it to the view
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        // Get the dao
        self.dao = [ContactDao contactDaoInstance];
        self.highlightRow = -1;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMoreActions:)];
    
    [self.tableView addGestureRecognizer:longPress];
}

-(void) showMoreActions:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:point];
        
        if (index) {
            self.selectedContact = [self.dao get:index.row];
            _actionManager = [[ActionManager alloc] initWithContact:self.selectedContact];
            [self.actionManager controllerActions:self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Opens the form contact view
- (void) showFormContactView {
    
    /* Create the form */
    
    // Doing this manualy, the screen will not appear. We need to create using with the story board
    // FormContactViewController *form = [FormContactViewController new];
    
    // Creating with the story board
    // Get the storyBoard instance
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FormContactViewController *form = [storyBoard instantiateViewControllerWithIdentifier:@"formContact"];
    
    if (self.selectedContact) {
        form.contact = self.selectedContact;
    }
    
    form.delegate = self;
    
    // Now send the message to navigation Controller to show the form
    [self.navigationController pushViewController:form animated: YES];
    
}

/* Methods to set the table values */
// Default to have 1 section
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Returns the number of contacts
- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [self.dao total];
}

// Return the component
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [self.dao get: indexPath.row];
    
    // Try to re-use a cell that is not visible to avoid memory usage
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONTAC_CELL];
    
    // If the cell does not exist, we need to create it
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONTAC_CELL];
    }
    
    cell.textLabel.text = contact.name;
    
    return cell;
}

/* Method to remove the row */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dao remove:indexPath.row];
        // [tableView reloadData];
        // Instead of reload the full table, only remove the selected row
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* Method to edit the row */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the selected contat
    self.selectedContact = [self.dao get:indexPath.row];
    // Call the show form contact view
    [self showFormContactView];
    self.selectedContact = nil;
}

// Reload the table view contents just before the view appear
-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.highlightRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.highlightRow inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        self.highlightRow = -1;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) contactUpdated:(Contact *)contact {
    NSLog(@"contact updated: %@", contact.name);
    self.highlightRow = [self.dao searchContactPosition:contact];
}

- (void) contactAdded:(Contact *)contact {
    NSLog(@"contact added: %@", contact.name);
    self.highlightRow = [self.dao searchContactPosition:contact];
}

@end
