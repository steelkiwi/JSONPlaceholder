//
//  JSONDecoder.swift
//  
//
//  Created by Viktor Olesenko on 22.11.17.
//

import Foundation

extension JSONDecoder {
    
    convenience init(dateFormat: String) {
        self.init(dateFormatter: DateFormatter.init(dateFormat: dateFormat))
    }
    
    convenience init(dateFormatter: DateFormatter, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func decode<T>(_ type: T.Type, from json: JSON) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        return try self.decode(type, from: data)
    }
    
    func decode<T>(_ type: T.Type, from jsonString: String) throws -> T where T : Decodable {
        let data = jsonString.data(using: .utf8)!
        return try self.decode(type, from: data)
    }
    
    func decode<T>(_ type: T.Type, from jsonArray: Array<JSON>) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        return try self.decode(type, from: data)
    }
}
