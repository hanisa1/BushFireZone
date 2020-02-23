//
//  CardViewController.swift
//  BushFireZone
//
//  Created by Hanisa Mohamed on 23/2/20.
//  Copyright © 2020 Hanisa Mohamed. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
        setupLayout()
    }
    
    
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
    }

    

}
