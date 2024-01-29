//
//  Publisher+SinkAwait.swift
//  PokedexIOSTests
//
//  Created by Alberto Guerrero Martin on 24/1/24.
//

import XCTest
import Foundation
import Combine

public extension Combine.Publisher {
    
    func sinkAwait(timeout: TimeInterval = 1, file: StaticString = #file, line: UInt = #line,
                   beforeWait: (() -> Void)? = nil) throws -> Output {
        return try sinkAwaitResult(timeout: timeout, file: file, line: line, beforeWait: beforeWait).get()
    }
    
    func sinkAwaitError(timeout: TimeInterval = 1, file: StaticString = #file, line: UInt = #line, beforeWait: (() -> Void)? = nil) throws -> Failure {
        let result = try sinkAwaitResult(timeout: timeout, file: file, line: line, beforeWait: beforeWait)
        switch result {
        case .failure(let error):
            return error
        case .success:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The publishers succeed"])
        }
    }
}

private extension Combine.Publisher {
    
    func sinkAwaitResult(timeout: TimeInterval, file: StaticString, line: UInt, beforeWait: (() -> Void)? = nil) throws -> Result<Output, Failure> {
        var result: Result<Output, Failure>?
        let expectation = XCTestExpectation(description: "Await for publisher to complete")
        let cancellable = self.first()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    result = .failure(error)
                }
                expectation.fulfill()
            }, receiveValue: { value in
                result = .success(value)
            }
        )
        beforeWait?()
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        let unwrappedResult = try XCTUnwrap(result, "Awaited publisher did not produce any output",
                                            file: file,
                                            line: line)
        return unwrappedResult
    }
}
