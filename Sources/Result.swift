//
//  Result.swift
//  RxFirebase
//
//  Created by suguru-kishimoto on 2017/10/17.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import RxSwift

public enum ResultError<T>: Error {
    case illegalCombination(T?, Error?)
}

enum Result<T> {
    case success(T)
    case failure(Error)

    init(_ value: T?, _ error: Error?) {
        switch (value, error) {
        case (let value?, nil):
            self = .success(value)
        case (nil, let error?):
            self = .failure(error)
        default:
            self = .failure(ResultError.illegalCombination(value, error))
        }
    }

    init(error: Error?, ifNoError value: @autoclosure () -> T) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success(value())
        }
    }

    init(_ f: () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .failure(error)
        }
    }

    func convertSingleObservable(for observer: (SingleEvent<T>) -> Void) {
        switch self {
        case let .success(value):
            observer(.success(value))
        case let .failure(error):
            observer(.error(error))
        }
    }
}

extension Result where T == Void {
    func convertCompletableObservable(for observer: (CompletableEvent) -> Void) {
        switch self {
        case .success:
            observer(.completed)
        case let .failure(error):
            observer(.error(error))
        }
    }
}
