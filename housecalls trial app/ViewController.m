//
//  ViewController.m
//  housecalls trial app
//
//  Created by Daniel Weissbluth on 7/27/14.
//  Copyright (c) 2014 ___Weissbluth Pediatrics___. All rights reserved.
//

#import "ViewController.h"


#define METERS_PER_MILE 1609.344;

@interface ViewController () <MKMapViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKCircle *circle;
@property CLLocation *centerCoord;
@property MKPointAnnotation *wPAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad


{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.896775;
    zoomLocation.longitude= -87.623295;

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 41.896775;
    coordinate.longitude = -87.623295;

    self.wPAnnotation =[[MKPointAnnotation alloc] init];
    self.wPAnnotation.coordinate = coordinate;
    self.wPAnnotation.title =@"Weissbluth Pediatrics";
    self.wPAnnotation.subtitle=@"737 N. Michigan Ave";
    [self.mapView addAnnotation:self.wPAnnotation];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 11800, 11800);

    [self.mapView setRegion:viewRegion animated:YES];

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(41.896775, -87.6232295);
    self.circle =[MKCircle circleWithCenterCoordinate:center radius:5600];
    self.circle.title = @"WP Housecall Range";
    self.centerCoord = [[CLLocation alloc] initWithLatitude:41.896775 longitude:-87.623295];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.mapView addOverlay:self.circle];
}


- (void)viewDidAppear:(BOOL)animated
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Services Not Enabled" message: @"Go to settings and turn location services on" delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];

    }
   if (([self.mapView.userLocation.location distanceFromLocation:self.centerCoord] < self.circle.radius) && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
   {

       UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"You are good to go!" message: @"Housecalls coming Fall 2014" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Call WP", nil];
       [alert show];
   }
    else if (([self.mapView.userLocation.location distanceFromLocation:self.centerCoord] >= self.circle.radius) && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry, You are out of range!" message: @"We are happy to see you in our office though!" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: nil];
        [alert show];
    }

    NSLog(@"view appeared");


}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle: self.circle];
    circleRenderer.fillColor = [UIColor colorWithRed:0.239 green: 0.91 blue: 0.161 alpha:0.6];
    return circleRenderer;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://312-202-0300"]];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{
    NSURL *url = [NSURL URLWithString:@"http://www.weissbluthpediatrics.com"];
    [[UIApplication sharedApplication] openURL:url];
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta =0.00001;
    coordinateSpan.longitudeDelta = 0.00001;
    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span =coordinateSpan;

    [self.mapView setRegion:region animated: YES];
}




@end
