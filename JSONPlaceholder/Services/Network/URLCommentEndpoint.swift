//
//  URLCommentEndpoint.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import Alamofire

enum URLCommentEndpoint: URLEndpointProtocol {
    case commentList(idRange: ClosedRange<Int>)
    
    var endpoint: String {
        switch self {
            
        case .commentList: return "comments/"
        }
    }
    
    var parameters: Parameters? {
        switch self {
            
        case let .commentList(idRange):
            return [
                "_start" : idRange.lowerBound,
                "_limit" : Limit.Network.PageSize.commentList                
            ]
        }
    }
}
