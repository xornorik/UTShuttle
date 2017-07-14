//
//  RoundedImageView.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 14/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

}
