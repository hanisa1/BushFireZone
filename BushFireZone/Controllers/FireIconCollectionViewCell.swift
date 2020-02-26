//
//  FireIconCollectionViewCell.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 26/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class FireIconCollectionViewCell: UICollectionViewCell {
    
    lazy var fireImageView : UIImageView = {
        let fiv = UIImageView()
        fiv.contentMode = .scaleAspectFill
        fiv.clipsToBounds = true
        fiv.layer.masksToBounds = true
        fiv.image = #imageLiteral(resourceName: "Mark")
        fiv.layer.cornerRadius = 44
        return fiv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
            
        
    }
    
    fileprivate func setupLayout() {
        addSubview(fireImageView)
        fireImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
