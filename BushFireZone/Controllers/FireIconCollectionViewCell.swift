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
        fiv.layer.cornerRadius = 42.5
        return fiv
    }()
    
    var fireViewName : String = "UnKnown"
    
    lazy var fireZoneName : UILabel = {
        let fzn = UILabel()
        fzn.font = .boldSystemFont(ofSize: 16)
        fzn.text = "unknown"
        fzn.textColor = UIColor.label
        fzn.numberOfLines = 0
        fzn.lineBreakMode = .byWordWrapping
        fzn.textAlignment = .center
        return fzn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    
    
    fileprivate func setupLayout() {
        addSubview(fireImageView)
        fireImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 85, height: 85))
        fireImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(fireZoneName)
        fireZoneName.anchor(top: fireImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
