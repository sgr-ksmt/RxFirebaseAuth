//
//  Helper.swift
//  RxFirebaseAuth
//
//  Created by suguru-kishimoto on 2018/04/26.
//  Copyright © 2018年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import RxSwift

func singleEventHandler<T>(_ observer: @escaping (SingleEvent<T>) -> Void) -> (T?, Error?) -> Void {
    return { Result($0, $1).convertSingleObservable(for: observer) }
}

func singleEventErrorHandler(_ observer: @escaping (SingleEvent<Void>) -> Void) -> (Error?) -> Void {
    return { Result(error: $0, ifNoError: ()).convertSingleObservable(for: observer) }
}
