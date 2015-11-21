//
//  ContactsMapViewController.m
//  ContatosIP67
//
//  Created by ios5778 on 14/11/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import "ContactsMapViewController.h"

@interface ContactsMapViewController ()

@end

@implementation ContactsMapViewController


- (id)init {
    self = [super init];
    
    if (self) {
        // Setup the View Icon
        UIImage *icon = [UIImage imageNamed:@"mapa-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:icon tag:0];
        self.tabBarItem = tabItem;

        // Set the title
        self.navigationItem.title = @"VNT Contacts";

        ContactDao *dao = [ContactDao contactDaoInstance];
        self.contacts = dao.contacts;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKUserTrackingBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.navigationItem.rightBarButtonItem = userTrackingButton;

    self.manager = [CLLocationManager new];
    [self.manager requestWhenInUseAuthorization];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.mapView addAnnotations:self.contacts];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView removeAnnotations:self.contacts];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If is the user location pin, return nil
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // An identifier to reuse the pin
    static NSString *identifier = @"pin";
    
    // Get the reusable pin
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    // IF there is no pin, create
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        pin.annotation = annotation;
    }
    
    // Setup the pin
    Contact *contact = (Contact *)annotation;
    pin.pinTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    pin.canShowCallout = YES;
    
    // IF there is photo, put it
    if (contact.photo) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        image.image = contact.photo;
        pin.leftCalloutAccessoryView = image;
    }
    
    return pin;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
