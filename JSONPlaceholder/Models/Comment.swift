//
//  Comment.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import Foundation

struct Comment: CodableExpanded {
    
    let postId  : Int
    let id      : Int
    
    let name    : String
    let email   : String
    let body    : String
}

extension Comment: Equatable {
    
    static func == (_ lhs: Comment, _ rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}
