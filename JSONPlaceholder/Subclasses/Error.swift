//
//  Error.swift
//
//
//  Created by Viktor Olesenko on 22.11.17.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case requestError
    case serverError
    case parsingError
    
    var errorDescription: String? {
        switch self {
            
        case .requestError:     return "Error.WrongRequest".localized()
        case .serverError:      return "Error.FailedGetServerResponse".localized()
        case .parsingError:     return "Error.ParsingError".localized()
        }
    }
}

enum AppError: Error, LocalizedError {
    case invalidValue
    case custom(text: String)
    
    var errorDescription: String? {
        switch self {
            
        case .invalidValue:     return "Error.Field.WrongValue".localized()
        case .custom(let text): return text
        }
    }
}    

// MARK: - ErrorsDict

extension Dictionary where Key == String, Value == Error {
    
    init(error: Error) {
        self.init()
        
        self["Error".localized()] = error
    }
    
    init(errorMessage: String) {
        self.init(error: AppError.custom(text: errorMessage))
    }
}
