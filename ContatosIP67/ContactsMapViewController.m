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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
