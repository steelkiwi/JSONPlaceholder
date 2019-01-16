//
//  BaseNetworkServiceProtocol.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 10.08.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import Alamofire

protocol BaseNetworkServiceProtocol {
    var headers: HTTPHeaders { get }
    
    func request(urlEndpoint: URLEndpointProtocol, method: HTTPMethod) -> Request
    func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> Request
}
