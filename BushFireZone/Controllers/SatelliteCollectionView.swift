//
//  SatelliteCollectionView.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 1/3/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class SatelliteCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
