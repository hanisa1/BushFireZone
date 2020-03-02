//
//  CardViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 23/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage


protocol MapViewZoomDelegate {
    func didSelectCityZoomIn(lat: Double, long: Double)
}

class CardViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
        setupLayout()
        
        
        fireIconModels = [sydneyIcon, northCoastIcon, midNorthCoastIcon, hunterIcon, blueMountainsIcon, southernHighlandsIcon, southCoastIcon, riverinaIcon, snowyMountainsIcon]
        
        //empty State View
        let emptyStateView = SatEmptyStateView()
        emptyStateView.frame = sContainer.bounds
        sContainer.backgroundView = emptyStateView
    }
    
    var zoomDelegate: MapViewZoomDelegate?
    
    let topCellID = "cellID"
    let bottomCellID = "cellID2"
    
    var responseData : Data?
    
    lazy var handle : UIView = {
        let handle = UIView()
        handle.backgroundColor = .systemGray3
        handle.frame = CGRect(x: 0, y: 0, width: 50, height: 8)
        handle.layer.cornerRadius = 4
        handle.clipsToBounds = true
        return handle
    }()
    
    lazy var handleArea : UIView = {
        let ha = UIView()
//        ha.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.6)
        return ha
    }()
    
    
    
    let sydneyIcon = FireIcon(name: "Sydney", imageName: "syd", lat: -33.872760, long: 151.205340)
    let northCoastIcon = FireIcon(name: "North Coast", imageName: "norc", lat: -28.791719, long: 153.062866)
    let midNorthCoastIcon = FireIcon(name: "Mid North Coast", imageName: "midnor", lat: -29.064530, long: 153.349430)
    let hunterIcon = FireIcon(name: "Hunter", imageName: "hun", lat: -34.071730, long: 150.637460)
    let blueMountainsIcon = FireIcon(name: "Blue Mountains", imageName: "blu", lat: -33.714364, long: 150.311535)
    let southernHighlandsIcon = FireIcon(name: "Southern Highlands", imageName: "souh", lat: -35.162214, long: 138.937631)
    let southCoastIcon = FireIcon(name: "South Coast", imageName: "souc", lat: -34.892588, long: 150.582679)
    let riverinaIcon = FireIcon(name: "Riverina", imageName: "riv", lat: -34.640830, long: 145.549860)
    let snowyMountainsIcon = FireIcon(name: "Snowy Mountains", imageName: "sno", lat: -36.163541, long: 148.683154)
    
    var fireIconModels = [FireIcon]()
    
    lazy var titleLabel : UILabel = {
        let tl = UILabel()
        tl.text = "NSW Bush Fire Zones"
        tl.textColor = UIColor.label
        tl.textAlignment = .left
        tl.font = .boldSystemFont(ofSize: 25)
        return tl
    }()
    
    //create array of thumbnails for each City
    var thumbnailArray = [String]()
    
    // satellite container view
    let collectionFireView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    let sContainer = SatelliteCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate func setupLayout() {
        
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        //handle
        handleArea.addSubview(handle)
        handleArea.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 65)
        view.addSubview(handleArea)
        handle.anchor(top: handleArea.topAnchor, leading: handleArea.leadingAnchor, bottom: nil, trailing: handleArea.trailingAnchor, padding: .init(top: 8, left: view.frame.width/2 - 37, bottom: 0, right: view.frame.width/2 - 37))
        handle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handle.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        handleArea.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        handleArea.heightAnchor.constraint(equalToConstant: 65).isActive = true
        setupHandleAreaTitle()
        //setup collectionView
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 8
        
        view.addSubview(collectionFireView)
        collectionFireView.backgroundColor = .clear
        collectionFireView.anchor(top: handleArea.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        collectionFireView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        collectionFireView.delegate = self
        collectionFireView.dataSource = self
        collectionFireView.showsHorizontalScrollIndicator = false
        //register the cell
        collectionFireView.register(FireIconCollectionViewCell.self, forCellWithReuseIdentifier: topCellID)
        if let layoutA = collectionFireView.collectionViewLayout as? UICollectionViewFlowLayout {
            layoutA.scrollDirection = .horizontal
            layoutA.minimumLineSpacing = 13
        }
        //setup satellite imagery contaner
        sContainer.register(SatelliteCell.self, forCellWithReuseIdentifier: bottomCellID)
        if let layoutB = sContainer.collectionViewLayout as? UICollectionViewFlowLayout {
            layoutB.scrollDirection = .vertical
            layoutB.minimumLineSpacing = 16
        }
        sContainer.delegate = self
        sContainer.dataSource = self
        view.addSubview(sContainer)
        sContainer.anchor(top: collectionFireView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 16, bottom: 0, right: 16))
    }

    fileprivate func setupHandleAreaTitle() {
        
        handleArea.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: handleArea.leadingAnchor, bottom: nil, trailing: handleArea.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        titleLabel.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionFireView {
            return fireIconModels.count
        }

        return thumbnailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionFireView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: topCellID, for: indexPath) as! FireIconCollectionViewCell
            
            cellA.fireViewName = fireIconModels[indexPath.item].name
            cellA.fireImageView.image = UIImage(named: fireIconModels[indexPath.item].imageName)
            cellA.fireZoneName.text = fireIconModels[indexPath.item].name
            return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: bottomCellID, for: indexPath) as! SatelliteCell
            
//            cellB.satImageView.image = UIImage(named: sydneyThumbnailArray[indexPath.item])
            let urlB = NSURL(string: thumbnailArray[indexPath.item])
            cellB.satImageView.sd_setImage(with: urlB as URL?)
            
            if let image = cellB.satImageView.image {
                let compressedThumbnail = image.jpeg(.lowest)
                cellB.satImageView.image = UIImage(data: compressedThumbnail ?? Data())

            }
            
            
            
            return cellB
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionFireView {
           
            return CGSize(width: 85, height: 130)
        } else {
            
            return CGSize(width: sContainer.frame.width, height: sContainer.frame.height - 10)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sContainer.backgroundView = UIView()
        if collectionView == self.collectionFireView {
            print("Fire icon selected")
            // zoom into map
            zoomDelegate?.didSelectCityZoomIn(lat: fireIconModels[indexPath.item].lat, long: fireIconModels[indexPath.item].long)
            //animate scroll to top
            self.sContainer.setContentOffset(CGPoint(x:0,y:0), animated: true)
            setUpArlulaAPICall(cityName: fireIconModels[indexPath.item].name, lat: fireIconModels[indexPath.item].lat, long: fireIconModels[indexPath.item].long, res: "vhigh")
            self.sContainer.reloadData()
            
        }
        
    }

    fileprivate func setUpArlulaAPICall(cityName: String, lat: Double, long: Double, res: String) {
        // if statement 
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://api.arlula.com/api/search?start=2019-12-05&end=2020-01-10&res=\(res)&lat=\(lat)&long=\(long)")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic VTU3TmdvSVZQekxheEZkTGNjUWwwUEVHYVRNeFk4bDYzZG9keHlEc0xCVFZQQ3piSHZKOFFrOXV1UEdrOmFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6MTIzNA==", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            //Success!
            
                //if city blah blah
                do {
                    let satImages = try
                    
                    JSONDecoder().decode(Array<City>.self, from: data)
                    
                    self.thumbnailArray.removeAll()

                    
                    for object in satImages {
//                        print(object.thumbnail)
                        //Append each thumbnail image to the sydney array
                        
                        self.thumbnailArray.append(object.thumbnail)
                        
                    }
                    
                    
                } catch {
                    print("Error thrown", error)
                }
//            }
            
            
          semaphore.signal()
        }
        
        
        

        task.resume()
        semaphore.wait()
        if self.thumbnailArray.isEmpty {
            print("No images in \(cityName), fetching lower resolution.")
            self.setUpArlulaAPICall(cityName: cityName, lat: lat, long: long, res: "low")
        }
    }
    
    
    
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
