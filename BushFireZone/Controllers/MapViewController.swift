//
//  ViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 22/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    //Setting up dynamic CardView
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController : CardViewController!
    var visualEffectView : UIVisualEffectView!
    
    let cardHeight : CGFloat = 600
    let cardHandleAreaHeight : CGFloat = 165
    
    var cardVisible = false
    var nextState : CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterupted : CGFloat = 0
    
//    let bushFireZoneImages : UIImage = [#imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>), #imageLiteral(resourceName: <#T##String#>)]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpLayout()
        addAnnotations()
        setupCard()
    }

    // Set up annotations for each Bush Fire Zone
    
    
    fileprivate func addAnnotations() {
        
        let mapView = MKMapView()
                mapView.delegate = self
                view.addSubview(mapView)
                mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.872760, longitude: 151.205340), span: .init(latitudeDelta: 10, longitudeDelta: 10 ))
                mapView.fillSuperview()
                
                
        
        let sydneyAnnotation = MKPointAnnotation()
        sydneyAnnotation.title = "Sydney"
        sydneyAnnotation.coordinate = CLLocationCoordinate2D(latitude: -33.872760, longitude: 151.205340)
        
        let northCoastAnnotation = MKPointAnnotation()
        northCoastAnnotation.title = "North Coast"
        northCoastAnnotation.coordinate = CLLocationCoordinate2D(latitude: -28.791719, longitude: 153.062866)
        
        let midNorthCoastAnnotation = MKPointAnnotation()
        midNorthCoastAnnotation.title = "Mid North Coast"
        midNorthCoastAnnotation.coordinate = CLLocationCoordinate2D(latitude: -29.064530, longitude: 153.349430)
        
        let hunterAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "Hunter"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -34.071730, longitude: 150.637460)
        
        let blueMountainsAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "Blue Mountains"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -33.714364, longitude: 150.311535)
        
        let southernHighlandsAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "Southern Highlands"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -35.162214, longitude: 138.937631)
        
        let southCoastAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "South Coast"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -34.892588, longitude: 150.582679)
        
        let riverinaAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "Riverina"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -34.640830, longitude: 145.549860)
        
        let snowyMountainsAnnotation = MKPointAnnotation()
        hunterAnnotation.title = "Snowy Mountains"
        hunterAnnotation.coordinate = CLLocationCoordinate2D(latitude: -36.163541, longitude: 148.683154)
        
        let annotationList = [sydneyAnnotation, northCoastAnnotation, midNorthCoastAnnotation, hunterAnnotation, blueMountainsAnnotation, southernHighlandsAnnotation, southCoastAnnotation, riverinaAnnotation, snowyMountainsAnnotation]
        annotationList.forEach { (ann) in
            mapView.addAnnotation(ann)
        }
    }
    
    fileprivate func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    fileprivate func setupCard() {
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        view.addSubview(cardViewController.view)
        view.bringSubviewToFront(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecogniser)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecogniser)
    }
    
    fileprivate func setUpLayout() {
        
    }
    
    // gesture recognisers for the cardViewController
    @objc fileprivate func handleTap(recogniser: UITapGestureRecognizer) {
        
        switch recogniser.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
        
    }
    
    @objc fileprivate func handlePan(recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .began:
            //start transition
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            //update transition
            let translation = recogniser.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            //continue transition
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    fileprivate func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            //run animations
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterupted = animator.fractionComplete
        }
        
    }
    
    fileprivate func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterupted
        }
    }
    
    fileprivate func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.image = #imageLiteral(resourceName: "flame")
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(view)")
    }
    

}

