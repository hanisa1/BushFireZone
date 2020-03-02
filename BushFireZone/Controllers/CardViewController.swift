//
//  CardViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 23/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit
import Foundation


class CardViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
        setupLayout()
        setUpArlulaAPICall()
    }
    
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
    
    lazy var titleLabel : UILabel = {
        let tl = UILabel()
        tl.text = "NSW Bush Fire Zones"
        tl.textColor = .label
        tl.textAlignment = .left
        tl.font = .boldSystemFont(ofSize: 25)
        return tl
    }()
    
    //create array of thumbnails for each City
    var sydneyThumbnailArray = [String]()
    
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
        collectionFireView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionFireView.delegate = self
        collectionFireView.dataSource = self
        collectionFireView.showsHorizontalScrollIndicator = false
        //register the cell
        collectionFireView.register(FireIconCollectionViewCell.self, forCellWithReuseIdentifier: topCellID)
        if let layoutA = collectionFireView.collectionViewLayout as? UICollectionViewFlowLayout {
            layoutA.scrollDirection = .horizontal
            layoutA.minimumLineSpacing = 8
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
        sContainer.anchor(top: collectionFireView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 16, bottom: 0, right: 16))
    }

    fileprivate func setupHandleAreaTitle() {
        
        handleArea.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: handleArea.leadingAnchor, bottom: nil, trailing: handleArea.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        titleLabel.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionFireView {
            return 10
        }

        return sydneyThumbnailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionFireView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: topCellID, for: indexPath) as! FireIconCollectionViewCell
            
            return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: bottomCellID, for: indexPath) as! SatelliteCell
            
            cellB.satImageView.image = UIImage(named: sydneyThumbnailArray[indexPath.item])
            
            
            return cellB
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionFireView {
           
            return CGSize(width: 85, height: 85)
        } else {
            
            return CGSize(width: sContainer.frame.width, height: sContainer.frame.height)
        }
        
    }
    

    fileprivate func setUpArlulaAPICall() {
        
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://api.arlula.com/api/search?start=2019-12-05&end=2020-01-10&res=vhigh&lat=-33.8523&long=151.2108")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic VTU3TmdvSVZQekxheEZkTGNjUWwwUEVHYVRNeFk4bDYzZG9keHlEc0xCVFZQQ3piSHZKOFFrOXV1UEdrOmFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6MTIzNA==", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            //Success!
//            print(String(data: data, encoding: .utf8)!)
            
//            data.forEach { (image) in
                
                do {
                    let sydneySatImages = try
                        JSONDecoder().decode(Array<City>.self, from: data)

                    for object in sydneySatImages {
//                        print(object.thumbnail)
                        //Append each thumbnail image to the sydney array
                        self.sydneyThumbnailArray.append(object.thumbnail)
                        
                    }
                } catch {
                    print("Error thrown", error)
                }
//            }
            
            
          semaphore.signal()
        }
        
        
        

        task.resume()
        semaphore.wait()
        
    }
    
    
    
    
}
