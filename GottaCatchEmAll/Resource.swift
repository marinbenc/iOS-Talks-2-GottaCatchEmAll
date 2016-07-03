//
//  Resource.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 03/07/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Alamofire

enum ServiceResult<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
}

enum ResourceError: ErrorType {
    case CannotParse
    case CannotValidate(ValidationError)
    case AlamofireError(NSError)
}

enum ValidationError: Int, ErrorType {
    case NotFound = 404
    case BadRequest = 503
    case InternalError = 501
    case Other
    
    init(code: Int) {
        if let error = ValidationError(rawValue: code) {
            self = error
        } else {
            self = .Other
        }
    }
}

enum ResourcePath {
    
    private struct Constants {
        static let baseURL = "http://pokeapi.co/api/v2/"
    }
    
    case Pokemon(id: String)
    //case ...
    
    var rawValue: String {
        switch self {
        case .Pokemon(let id):
            return Constants.baseURL + "pokemon/\(id)"
        }
    }
}

struct Resource<Value> {
    
    typealias JSON = AnyObject
    
    let method: Alamofire.Method
    let path: ResourcePath
    let parse: (JSON)-> Value?
    let params: [String: AnyObject]? = nil
    
    func get(completion: ServiceResult<Value, ResourceError> -> Void) {
        
        Alamofire.request(method, path.rawValue, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    
                    if let value = self.parse(json) {
                        completion(.Success(value))
                    } else {
                        completion(.Failure(.CannotParse))
                    }
                    
                case .Failure(let error):
                    
                    if let statusCode = response.response?.statusCode {
                        let error = ValidationError(code: statusCode)
                        completion(.Failure(.CannotValidate(error)))
                    } else {
                        completion(.Failure(.AlamofireError(error)))
                    }
                }
        }
    }
}


struct DataResource {
    
    let url: String
    
    func get(completion: ServiceResult<NSData, ResourceError> -> Void) {
        Alamofire.request(.GET, url).responseData { response in
            switch response.result {
            case .Success(let data): completion(.Success(data))
            case .Failure(let error): completion(.Failure(.AlamofireError(error)))
            }
        }
    }
}