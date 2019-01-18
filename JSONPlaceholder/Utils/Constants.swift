//
//  Constants.swift
//
//
//  Created by Viktor Olesenko on 16.11.17.
//

import Foundation
import Alamofire

// MARK: - Network

let kUrlBase = "https://jsonplaceholder.typicode.com/"

// MARK: - Typealias

typealias JSON          = Dictionary<String, Any>
typealias ErrorsDict    = Dictionary<String, Error> // For errors from server response

typealias Block = () -> Void

typealias ResponseObjectBlock<T: Any> = (_ value: T?, _ error: ErrorsDict?) -> Void

// MARK: - Wrappers

// Wrappers for Alamofire types - helps to avoid import in every file
typealias Request  = DataRequest
typealias Response = DataResponse

// MARK: - Limits

struct Limit {
    private init() {}
    
    struct Network {
        private init() {}
        
        struct PageSize {
            private init() {}
            
            static let commentList = 10
        }
    }
}
