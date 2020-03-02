//
//  SatEmptyStateView.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 2/3/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class SatEmptyStateView: UIView {

    let messageLabel : UILabel = {
        let ml = UILabel()
        ml.textAlignment = .center
        ml.font = .boldSystemFont(ofSize: 24)
        ml.numberOfLines = 3
        ml.text = "Select city to view the Satellite Imagery 👩🏾‍🚀."
        ml.textColor = .secondaryLabel
        return ml
    }()
    
    var spaceImageView: UIImageView = {
        let siv = UIImageView()
        siv.image = #imageLiteral(resourceName: "misc")
        siv.contentMode = .scaleAspectFit
        return siv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        addSubview(spaceImageView)
        addSubview(messageLabel)
//        let image = spaceImageView.image
//        spaceImageView.image = image!.image(alpha: 0.5)
//
//        spaceImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//
//            spaceImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:  -50),
//            spaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
//            spaceImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
//        ])
        
        messageLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:  -30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
