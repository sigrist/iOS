//
//  ViewController.h
//  ContatosIP67
//
//  Created by ios5778 on 24/10/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactDao.h"

@protocol FormContactViewControllerDelegate <NSObject>

- (void) contactUpdated:(Contact *) contact;
- (void) contactAdded:(Contact *) contact;

@end

@interface FormContactViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSite;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property Contact *contact;
@property (weak) id<FormContactViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *gpsBtn;

- (IBAction)selectPhoto;

@end

