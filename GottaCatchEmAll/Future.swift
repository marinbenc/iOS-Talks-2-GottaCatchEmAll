//
//  Future.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 30/06/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation


class Future<Value, Error: ErrorType> {
    
    typealias Result = ServiceResult<Value, Error>
    typealias CompletionBlock = (Result)-> Void
    
    private let operation: (CompletionBlock)-> Void
    
    var result: Result?
    
    init(operation: (CompletionBlock)-> Void) {
        self.operation = operation
    }
    
    func start(completion: CompletionBlock) {
        operation { result in
            completion(result)
        }
    }
    
    func map<OtherValue>(transform: (Value)-> OtherValue)-> Future<OtherValue, Error> {
        
        return Future<OtherValue, Error>(operation: { completion in
            self.start { result in
                switch result {
                case .Success(let value):
                    completion(.Success(transform(value)))
                case .Failure(let error):
                    completion(.Failure(error))
                }
            }
        })
    }
    
    func then<OtherValue>(nextOperation: (Value)-> Future<OtherValue, Error>)-> Future<OtherValue, Error> {
        
        return Future<OtherValue, Error>(operation: { completion in
            self.start { firstResult in
                switch firstResult {
                case .Success(let value):
                    nextOperation(value).start(completion)
                case .Failure(let error):
                    completion(.Failure(error))
                }
            }
        })
    }
}