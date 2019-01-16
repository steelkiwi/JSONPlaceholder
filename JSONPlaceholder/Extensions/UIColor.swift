//
//  UIColor.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import UIKit

extension UIColor {
    
    struct Components {
        private init() {}
        
        struct PullToRefresh {
            private init() {}
            
            static let tintColor = UIColor.red
        }
        
        struct PlaceholderTF {
            private init() {}
            
            static let placeholderDefault   = UIColor.init(hex: 0xC0C0C0)
            static let textDefault          = UIColor.black
            static let errorDefault         = UIColor.init(hex: 0xFF4564)
            static let underlineDefault     = UIColor.init(hex: 0xE0E6E6)
            static let highlightedDefault   = UIColor.init(hex: 0xA5D7FF)
        }
    }
}
