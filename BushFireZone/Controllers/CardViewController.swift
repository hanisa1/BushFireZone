//
//  CardViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 23/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
        setupLayout()
    }
    
    let cellID = "cellID"
    
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        let fireViewFrame = CGRect(x: 0, y: 0, width: handleArea.frame.width, height: 100)
        let collectionFireView = UICollectionView(frame: fireViewFrame, collectionViewLayout: layout)
        view.addSubview(collectionFireView)
        collectionFireView.backgroundColor = .clear
        collectionFireView.anchor(top: handleArea.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        collectionFireView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionFireView.delegate = self
        collectionFireView.dataSource = self
        collectionFireView.showsHorizontalScrollIndicator = false
        //register the cell
        collectionFireView.register(FireIconCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }

    fileprivate func setupHandleAreaTitle() {
        
        handleArea.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: handleArea.leadingAnchor, bottom: nil, trailing: handleArea.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        titleLabel.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FireIconCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 85)
    }
    

}
