//
//  ViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 22/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //Setting up dynamic CardView
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController : CardViewController!
    var visualEffectView : UIVisualEffectView!
    
    let cardHeight : CGFloat = 600
    let cardHandleAreaHeight : CGFloat = 65
    
    var cardVisible = false
    var nextState : CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterupted : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpLayout()
        setupCard()
    }

    // Set up annotations for each Bush Fire Zone
    let sydneyAnnotation = MKPointAnnotation()
    let northCoastAnnotation = MKPointAnnotation()
    let midNorthCoastAnnotation = MKPointAnnotation()
    let hunterAnnotation = MKPointAnnotation()
    
    fileprivate func setupCard() {
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
    }
    
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
    
    // gesture recognisers for the cardViewController
//    @objc fileprivate func handleTap(recogniser: UITapGestureRecogniser) {
//        
//    }
//    
//    @objc fileprivate func handlePan(recogniser: UIPanGestureRecogniser) {
//        
//    }
    
}

