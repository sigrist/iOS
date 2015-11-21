//
//  ContactsMapViewController.h
//  ContatosIP67
//
//  Created by ios5778 on 14/11/15.
//  Copyright © 2015 Venturus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ContactDao.h"

@interface ContactsMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSMutableArray *contacts;
@property (strong)CLLocationManager *manager;
@end
