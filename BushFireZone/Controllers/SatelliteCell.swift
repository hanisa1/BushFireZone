//
//  SatelliteCell.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 1/3/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class SatelliteCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    lazy var satImageView : UIImageView = {
        let siv = UIImageView()
        siv.contentMode = .scaleAspectFill
        siv.clipsToBounds = true
        siv.layer.masksToBounds = true
        siv.layer.cornerRadius = 10
        return siv
    }()
    
    fileprivate func setupLayout() {
        
        addSubview(satImageView)
        satImageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
