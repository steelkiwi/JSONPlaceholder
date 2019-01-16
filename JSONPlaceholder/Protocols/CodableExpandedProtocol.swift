//
//  CodableExpandedProtocol.swift
//  
//
//  Created by Viktor Olesenko on 06.12.17.
//

import Foundation

// MARK: - CodableExpanded

typealias CodableExpanded = EncodableExpanded & DecodableExpanded

// MARK: - EncodableExpanded

protocol EncodableExpanded: Encodable {
    static var encoder: JSONEncoder { get }
    
    func encode() throws -> Data
}

extension EncodableExpanded {
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder.init()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
    
    func encode() throws -> Data {
        return try Self.encoder.encode(self)
    }
}

// MARK: - DecodableExpanded

protocol DecodableExpanded: Decodable {
    static var decoder: JSONDecoder { get }
    
    static func decode<T: DecodableExpanded>(from json: JSON) throws -> T
    static func decode<T: DecodableExpanded>(from jsonArray: Array<JSON>) throws -> T
    static func decode<T: DecodableExpanded>(from data: Data) throws -> T
}

extension DecodableExpanded {
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    static func decode<T: DecodableExpanded>(from json: JSON) throws -> T {
        return try T.decoder.decode(T.self, from: json)
    }
    
    static func decode<T: DecodableExpanded>(from jsonArray: Array<JSON>) throws -> T {
        return try T.decoder.decode(T.self, from: jsonArray)
    }
    
    static func decode<T: DecodableExpanded>(from data: Data) throws -> T {
        return try T.decoder.decode(T.self, from: data)
    }
}
