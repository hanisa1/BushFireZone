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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpLayout()
        setupCard()
        addAnnotations()
    }

    // Set up annotations for each Bush Fire Zone
    
    let northCoastAnnotation = MKPointAnnotation()
    let midNorthCoastAnnotation = MKPointAnnotation()
    let hunterAnnotation = MKPointAnnotation()
    
    fileprivate func addAnnotations() {
        let sydneyAnnotation = MKPointAnnotation()
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
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecogniser)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecogniser)
    }
    
    fileprivate func setUpLayout() {
        let mapView = MKMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.88, longitude: 151.20), span: .init(latitudeDelta: 10, longitudeDelta: 10))
        mapView.fillSuperview()
        
//        sydneyAnnotation.coordinate = CLLocationCoordinate2D(latitude: -33.88, longitude: 151.20)\
    }
    
    // gesture recognisers for the cardViewController
    @objc fileprivate func handleTap(recogniser: UITapGestureRecognizer) {
        
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
    
}

