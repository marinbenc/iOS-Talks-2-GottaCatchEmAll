//
//  Resource.switch
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 03/07/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Alamofire

private struct Config {
    static let baseURL = "http://pokeapi.co/api/v2/"
}

typealias JSON = AnyObject


//MARK: - Result

enum ServiceResult<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
}


//MARK: - Errors

///All errors in which a Resource request can fail
enum ServiceError: ErrorType {
    case CannotParse
    case ValidationFailure(ValidationError)
    case UnknownError(NSError)
}

///HTTP validation errors
enum ValidationError: ErrorType {
    
    case NotFound
    case BadRequest
    case Other(Int)
    
    init(code: Int) {
        switch code {
        case 404: self = .NotFound
        case 400: self = .BadRequest
        default: self = .Other(code)
        }
    }
}


//MARK: - ResourcePath

enum ResourcePath {
    
    case Pokemon(id: String)
    
    var rawValue: String {
        switch self {
        case .Pokemon(id: let id):
            return "pokemon/\(id)"
        }
    }
}


//MARK: - Resources

///Anything that can be fetched as JSON (AnyObject).
struct JSONResource<Value> {
    
    let path: ResourcePath
    let method: Alamofire.Method
    let params: [String: AnyObject]? = nil
    
    ///A method that parses the fetched JSON into any type.
    let parse: (JSON)-> Value?
    
    /**
     Requests the resource for a given path and method, and tries to parse the JSON response
     via the `parse` property. If the result of parse is `nil`, it will return a CannotParse
     ServiceError. Otherwise, it will return success. Other errors while fetching the JSON
     are propagated.
     */
    func get(completion: (ServiceResult<Value, ServiceError>)-> Void) {
        
        Alamofire.request(.GET, Config.baseURL + path.rawValue).responseJSON { (response) in
            switch response.result {
            case .Success(let json):
                //try to parse the value
                if let value = self.parse(json) {
                    completion(.Success(value))
                } else {
                    completion(.Failure(.CannotParse))
                }
                
            case .Failure(let error):
                //try to get a ValidationError
                if let code = response.response?.statusCode {
                    let error = ValidationError(code: code)
                    completion(.Failure(.ValidationFailure(error)))
                } else {
                    completion(.Failure(.UnknownError(error)))
                }
            }
        }
    }
    
}


///Anything that can be fetched as NSData.
struct DataResource {
    
    let url: String
    
    /**
     Requests the resource for a given path and method as NSData. 
     Errors while fetching the data are propagated.
     */
    func get(completion: (ServiceResult<NSData, ServiceError>)-> Void) {
        Alamofire.request(.GET, url).responseData { response in
            switch response.result {
            case .Success(let data):
                completion(.Success(data))
                
            case .Failure(let error):
                //try to get a ValidationError
                if let code = response.response?.statusCode {
                    let error = ValidationError(code: code)
                    completion(.Failure(.ValidationFailure(error)))
                } else {
                    completion(.Failure(.UnknownError(error)))
                }
            }
        }
    }
    
}


