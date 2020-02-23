//
//  ViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 22/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setUpLayout()
    }

    // Set up annotations for each Bush Fire Zone
    let sydneyAnnotation = MKPointAnnotation()
    let northCoastAnnotation = MKPointAnnotation()
    let midNorthCoastAnnotation = MKPointAnnotation()
    let hunterAnnotation = MKPointAnnotation()
    
    fileprivate func setUpLayout() {
        let mapView = MKMapView()
        view.addSubview(mapView)
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.88, longitude: 151.20), span: .init(latitudeDelta: 10, longitudeDelta: 10))
        mapView.fillSuperview()
        
        sydneyAnnotation.coordinate = CLLocationCoordinate2D(latitude: -33.88, longitude: 151.20)
        sydneyAnnotation.title = "Sydney Fire"
        sydneyAnnotation.subtitle = "Sydney, NSW"
//        sydneyAnnotation
        mapView.addAnnotation(sydneyAnnotation)
    }
    
}

