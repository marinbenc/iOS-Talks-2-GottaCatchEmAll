//
//  Future.swift
//  GottaCatchEmAll
//
//  Created by Marin Benčević on 30/06/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//


/**
 A wrapper around an operation. Used for making asyncronous calls written
 in a syncronous way.
*/
class Future<Value, Error: ErrorType> {
    
    typealias CompletionBlock = (ServiceResult<Value, Error>)-> Void
    
    private let operation: (CompletionBlock)-> Void
    
    /**
     An operation represents any asyncronous function, so a function that has a callback.
    */
    init(operation: (CompletionBlock)-> Void) {
        
        self.operation = operation
    }
    
    /**
     Calls the operation with the completion block
    */
    func start(completion: CompletionBlock) {
        
        operation(completion)
    }
    
    /**
     Returns a new Future whose operation will start the current future's operation,
     and transform the successful value. In case of error, it will just propagate
     the error from the first future.
    */
    func map<OtherValue>(transform: (Value)-> OtherValue)-> Future<OtherValue, Error> {
        
        //Operation for the second future
        func nextOperation(completion: ServiceResult<OtherValue, Error> -> Void) {
            
            self.start { (result) in
                switch result {
                case .Success(let value):
                    let transformed = transform(value)
                    completion(.Success(transformed))
                case .Failure(let error):
                    completion(.Failure(error))
                }
            }
        }
        
        return Future<OtherValue, Error>(operation: nextOperation)
    }
    
    /**
     Returns a new Future whose operation will start the current future's operation,
     and on success, create a new future using the nextFuture param. It will then start the next
     future. In case of error, it will just propagate the error from the first future.
    */
    func then<OtherValue>(nextFuture: (Value)-> Future<OtherValue, Error>)-> Future<OtherValue, Error> {
        
        //Operation for the second future
        func nextOperation(completion: ServiceResult<OtherValue, Error> -> Void) {
        
            //start the first future
            self.start { firstResult in
                switch firstResult {
                case .Success(let value):
                    //create next future
                    let nextFuture = nextFuture(value)
                    //start next future
                    nextFuture.start(completion)
                    
                case .Failure(let error):
                    completion(.Failure(error))
                    
                }
            }
            
        }
        
        return Future<OtherValue, Error>(operation: nextOperation)
    }
    
}


