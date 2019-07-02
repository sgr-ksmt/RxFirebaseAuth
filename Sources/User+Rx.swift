//
//  User+Rx.swift
//  RxFirebase
//
//  Created by suguru-kishimoto on 2017/10/17.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift


// MARK: - Reload / re-authenticate
extension Reactive where Base: User {
    public func reload() -> Completable {
        return .create { [weak user = base] in
            user?.reload(completion: completableEventHandler($0))
            return Disposables.create()
        }
    }

    @available(*, deprecated, renamed: "reauthenticateAndRetrieveData(with:)")
    public func reauthenticateAndRetrieveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return reauthenticate(with: credential)
    }

    public func reauthenticate(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { [weak user = base] in
            user?.reauthenticate(with: credential, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }
}

// MARK: - link/unlink
extension Reactive where Base: User {
    @available(*, deprecated, renamed: "link(with:)")
    public func linkAndRetrieveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return link(with: credential)
    }

    public func link(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { [weak user = base] in
            user?.link(with: credential, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }

    public func unlink(with provider: String) -> Single<User> {
        return .create { [weak user = base] observer in
            user?.unlink(fromProvider: provider, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }
}

// MARK: - Update e-mail, password
extension Reactive where Base: User {
    public func updateEmail(to email: String) -> Single<Void> {
        return .create { [weak user = base] observer in
            user?.updateEmail(to: email, completion: singleEventErrorHandler(observer))
            return Disposables.create()
        }
    }

    public func updatePassword(to password: String) -> Completable {
        return .create { [weak user = base] in
            user?.updatePassword(to: password, completion: completableEventHandler($0))
            return Disposables.create()
        }
    }
}

// MARK: - Send e-mail verification
extension Reactive where Base: User {
    public func sendEmailVerification() -> Completable {
        return .create { [weak user = base] in
            user?.sendEmailVerification(completion: completableEventHandler($0))
            return Disposables.create()
        }
    }

    public func sendEmailVerification(with actionCodeSettings: ActionCodeSettings) -> Completable {
        return .create { [weak user = base] in
            user?.sendEmailVerification(with: actionCodeSettings, completion: completableEventHandler($0))
            return Disposables.create()
        }
    }
}

// MARK: - Get ID token
extension Reactive where Base: User {
    public func getIDToken() -> Single<String> {
        return .create { [weak user = base] observer in
            user?.getIDToken(completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func getIDTokenResult() -> Single<AuthTokenResult> {
        return .create { [weak user = base] observer in
            user?.getIDTokenResult(completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func getIDTokenForcingRefresh(_ forceRefresh: Bool) -> Single<String> {
        return .create { [weak user = base] observer in
            user?.getIDTokenForcingRefresh(forceRefresh, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func getIDTokenResult(forcingRefresh: Bool) -> Single<AuthTokenResult> {
        return .create { [weak user = base] observer in
            user?.getIDTokenResult(forcingRefresh: forcingRefresh, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }
}

// MARK: - Delete user
extension Reactive where Base: User {
    public func delete() -> Completable {
        return .create { [weak user = base] in
            user?.delete(completion: completableEventHandler($0))
            return Disposables.create()
        }
    }
}
