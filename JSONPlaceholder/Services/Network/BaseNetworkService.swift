//
//  BaseNetworkService.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 19.06.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import UIKit
import Alamofire

private extension HTTPMethod {
    
    var encoding: ParameterEncoding {
        switch self {
        case .get: return URLEncoding.queryString
        default:   return JSONEncoding.default
        }
    }
}

class BaseNetworkService: BaseNetworkServiceProtocol {
    
    var headers: HTTPHeaders {
        let headers: HTTPHeaders = [:] // Default headers here
                
        return headers
    }
    
    func request(urlEndpoint: URLEndpointProtocol, method: HTTPMethod) -> DataRequest {
        return self.request(url: kUrlBase + urlEndpoint.endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!,
                            method: method, parameters: urlEndpoint.parameters)
    }
    
    func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil) -> DataRequest {
        return Alamofire.request(url, method: method, parameters: parameters, encoding: method.encoding, headers: self.headers)
    }
    
    // MARK: - Error
    
    class func getError(from response: DefaultDataResponse) -> ErrorsDict {
        
        if let data = response.data {
            if let errorJSON = data.json {
                return BaseNetworkService.parseErrors(json: errorJSON)
            }
        
            if let errorString = String.init(data: data, encoding: .utf8) {
                return ErrorsDict.init(errorMessage: errorString)
            }
        }
        if let error = response.error {
            return ErrorsDict.init(error: error)
        }
        
        return ErrorsDict.init(error: NetworkError.serverError)
    }
    
    class func parseErrors<T : Any>(response: Response<T>) -> ErrorsDict? {
        guard let json = response.data?.json else {
            return ErrorsDict.init(error: NetworkError.parsingError)
        }
        
        return parseErrors(json: json)
    }
    
    class func parseErrors(json: JSON) -> ErrorsDict {
        var errors: ErrorsDict = [:]
        
        for (key, value) in json {
            
            if let stringValue = value as? String {
                errors[key] = AppError.custom(text: stringValue)
                break
            }
            
            if let stringArrayValue = value as? Array<String> {
                errors[key] = AppError.custom(text: stringArrayValue.first(where: { $0.isBlank == false }) ?? .empty)
                break
            }
            
            if let jsonValue = value as? JSON {
                errors.append(contentsOf: parseErrors(json: jsonValue))
                break
            }
            
            if let jsonArrayValue = value as? Array<JSON> {
                jsonArrayValue.forEach({ errors.append(contentsOf: parseErrors(json: $0)) })
                break
            }
        }
        
        return errors
    }
}
