//
//  Country.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 11/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

struct Country {
    var code: String?
    var name: String?
    var phoneCode: String?
    var flag: UIImage? {
        guard let code = self.code else { return nil }
        return UIImage(named: "\(code.uppercased())", in: Bundle.main, compatibleWith: nil)
    }
    
    init(code: String?, name: String?, phoneCode: String?) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
    }
}
