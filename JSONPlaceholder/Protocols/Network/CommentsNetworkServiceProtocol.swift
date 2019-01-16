//
//  CommentsNetworkServiceProtocol.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 14.08.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import Foundation

protocol CommentsNetworkServiceProtocol: BaseNetworkServiceProtocol {
    
    /// Get list of comments from server
    ///
    /// - Parameters:
    ///   - idRange: comment id, where to start and end
    @discardableResult
    func commentsGet(idRange: ClosedRange<Int>, completion: @escaping ResponseObjectBlock<Array<Comment>>) -> Request
}
