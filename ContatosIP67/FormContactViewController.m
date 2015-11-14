//
//  ViewController.m
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import "FormContactViewController.h"

@interface FormContactViewController ()
@property ContactDao *dao;
@end


@implementation FormContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = nil;
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.contact) {
        self.textFieldName.text = self.contact.name;
        self.textFieldEmail.text = self.contact.email;
        self.textFieldSite.text = self.contact.site;
        self.textFieldAddress.text = self.contact.address;
        self.textFieldPhone.text = self.contact.phone;
        self.textFieldLatitude.text = [self.contact.latitude stringValue];
        self.textFieldLongitude.text = [self.contact.longitude stringValue];
        
        if (self.contact.photo) {
            [self.photoBtn setBackgroundImage:self.contact.photo forState:UIControlStateNormal];
            [self.photoBtn setTitle:nil forState:UIControlStateNormal];
        }

        // Create the addButton, calling self the method showFormContacView
        saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateContact)];
    } else {
        saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveContact)];

    }
    
    // Add the button
    self.navigationItem.rightBarButtonItem = saveButton;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Story board call this method instead of init
-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Set the title (shortcut to self.navigationItem.title)
        self.title = @"New contact";
        self.dao = [ContactDao contactDaoInstance];
        

        
    }
    
    return self;
}

// Save new Contacts
-(void) saveContact {
    // Create the property contact
    self.contact = [Contact new];
    // get the form data and save it
    [self getFormData];
    // add the contact
    [self.dao addContacts:self.contact];

    // pop this form
    [self.navigationController popToRootViewControllerAnimated:YES];
    // There are other popTo* methods to go to other screens in the stack
    
    if (self.delegate) {
        [self.delegate contactAdded:self.contact];
    }
}

-(void) updateContact {
    // get the form data and save it
    [self getFormData];
    // pop this form
    [self.navigationController popToRootViewControllerAnimated:YES];
    // There are other popTo* methods to go to other screens in the stack
    
    if (self.delegate) {
        [self.delegate contactUpdated:self.contact];
    }

}
/*!
 Get the values of the form fields, create a Contact and add to the contacts array
 */
- (void) getFormData {
    // Get the values from the text fields
    NSString *name = self.textFieldName.text;
    NSString *email = self.textFieldEmail.text;
    NSString *site = self.textFieldSite.text;
    NSString *address = self.textFieldAddress.text;
    NSString *phone = self.textFieldPhone.text;
    UIImage *image = [self.photoBtn backgroundImageForState:UIControlStateNormal];
    
    // Create the contact object and set the values
    self.contact.name = name;
    self.contact.email = email;
    self.contact.site = site;
    self.contact.address =address;
    self.contact.phone = phone;
    self.contact.latitude = [NSNumber numberWithFloat:[self.textFieldLatitude.text floatValue]];
    self.contact.longitude = [NSNumber numberWithFloat:[self.textFieldLongitude.text floatValue]];
    
    if (image) {
        self.contact.photo = image;
    }
}

-(IBAction)searchCoordinates:(id)sender {

    
}
- (IBAction)selectPhoto {
    /// Check if there is access to the camera before call
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take picture", @"From library", nil];
        
        [sheet showInView:self.view];
    } else {
        UIImagePickerController *picker = [UIImagePickerController new];
        // Get the photos from photo library
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // Allow editing
        picker.allowsEditing = YES;
        // What to do with the photo?
        picker.delegate = self; 
        
        
        // Show
        [self presentViewController: picker animated:YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image from the dictionary and set in the photoBtn in the state normal
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.photoBtn setTitle:nil forState:UIControlStateNormal];
    
    // Remove the picker controller from screen
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [UIImagePickerController new];
    // Allow editing
    picker.allowsEditing = YES;
    // What to do with the photo?
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0: {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }; break;
        case 1: {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }; break;
        default: return;
    }
    // Show
    [self presentViewController: picker animated:YES completion: nil];
    
}
@end
