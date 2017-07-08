//
//  ModalUtils.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 07/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import Alertift

func showError(title: String, message: String, callback: (()->())? = nil) {
    
    Alertift.alert(title: title, message: message)
    .action(.default("OK")) { _ in
        callback?()
    }
    .show()
}
