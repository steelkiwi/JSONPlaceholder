//
//  CommentsNetworkService.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import Foundation

class CommentsNetworkService: BaseNetworkService, CommentsNetworkServiceProtocol {
    
    func commentsGet(idRange: ClosedRange<Int>, completion: @escaping ResponseObjectBlock<Array<Comment>>) -> Request {
        let endpoint = URLCommentEndpoint.commentList(idRange: idRange)
        let networkRequest = request(urlEndpoint: endpoint, method: .get)
        
        networkRequest.responseModelArray { (response: Response<Array<Comment>>) in
            if let _ = response.error {
                completion(nil, BaseNetworkService.parseErrors(response: response))
                return
            }
            
            let comments = response.value?.filter({ $0.id >= idRange.lowerBound && $0.id <= idRange.upperBound })
            
            completion(comments, nil)
        }
        
        return networkRequest
    }
}
