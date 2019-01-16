//
//  URLEndpointProtocol.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 19.06.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import Foundation
import Alamofire

protocol URLEndpointProtocol {
    var endpoint: String { get }
    var parameters: Parameters? { get }
}
