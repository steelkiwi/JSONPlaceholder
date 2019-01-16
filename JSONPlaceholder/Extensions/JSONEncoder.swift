//
//  JSONEncoder.swift
//  
//
//  Created by Viktor Olesenko on 11.12.17.
//

import Foundation

extension JSONEncoder {
    
    convenience init(dateFormat: String) {
        let dateFormatter = DateFormatter.init(dateFormat: dateFormat)
        
        self.init(dateFormatter: dateFormatter)
    }
    
    convenience init(dateFormatter: DateFormatter) {
        self.init()
        self.dateEncodingStrategy = .formatted(dateFormatter)
    }
}
