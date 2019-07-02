//
//  Auth+Rx.swift
//  RxFirebase
//
//  Created by suguru-kishimoto on 2017/10/17.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

public enum AuthError: Error {
    case userNotFound
}

// MARK: - Listener
extension Reactive where Base: Auth {
    public func addStateDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { [weak auth = base] observer in
            let handle = auth?.addStateDidChangeListener { observer.onNext(($0, $1)) }
            return Disposables.create {
                if let handle = handle {
                    auth?.removeStateDidChangeListener(handle)
                }
            }
        }
    }

    public func addIDTokenDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { [weak auth = base] observer in
            let handle = auth?.addIDTokenDidChangeListener { observer.onNext(($0, $1)) }
            return Disposables.create {
                if let handle = handle {
                    auth?.removeStateDidChangeListener(handle)
                }
            }
        }
    }
}

// MARK: - Create user
extension Reactive where Base: Auth {
    public func createUser(withEmail email: String, password: String) -> Single<AuthDataResult> {
        return .create { [weak auth = base] in
            auth?.createUser(withEmail: email, password: password, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }
}


// MARK: - Sign in
extension Reactive where Base: Auth {
    public func signInAnonymously() -> Single<AuthDataResult> {
        return .create { [weak auth = base] in
            auth?.signInAnonymously(completion: singleEventHandler($0))
            return Disposables.create()
        }
    }
    
    public func signIn(withEmail email: String, password: String) -> Single<AuthDataResult> {
        return .create { [weak auth = base] in
            auth?.signIn(withEmail: email, password: password, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }
    
    public func signInWith(customToken: String) -> Single<AuthDataResult> {
        return .create { [weak auth = base] in
            auth?.signIn(withCustomToken: customToken, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }

    public func signInWithGoogle(withIDToken idToken: String, accessToken: String) -> Single<AuthDataResult> {
        return signIn(with: GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken))
    }

    public func signInWithFacebook(withAccessToken accessToken: String) -> Single<AuthDataResult> {
        return signIn(with: FacebookAuthProvider.credential(withAccessToken: accessToken))
    }

    public func signInWithTwitter(withToken token: String, secret: String) -> Single<AuthDataResult> {
        return signIn(with: TwitterAuthProvider.credential(withToken: token, secret: secret))
    }

    public func signInWithPhoneAuth(withVerificationID verificationID: String, verificationCode code: String) -> Single<AuthDataResult> {
        return signIn(with: PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code))
    }

    public func signInWithGitHub(withToken token: String) -> Single<AuthDataResult> {
        return signIn(with: GitHubAuthProvider.credential(withToken: token))
    }

    public func signInWithGameCenter() -> Single<AuthDataResult> {
        return Single<AuthCredential>.create { observer in
            GameCenterAuthProvider.getCredential { credential, error in
                switch Result(credential, error) {
                case let .success(credential):
                    observer(.success(credential))
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
            .flatMap(signIn)
    }

    @available(*, deprecated, renamed: "signIn(with:)")
    public func signInAndRetriveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return signIn(with: credential)
    }

    public func signIn(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { [weak auth = base] in
            auth?.signIn(with: credential, completion: singleEventHandler($0))
            return Disposables.create()
        }
    }
}

// MARK: - Link
extension Reactive where Base: Auth {
    public func linkWithFacebook(withAccessToken accessToken: String) -> Single<AuthDataResult> {
        return link(with: FacebookAuthProvider.credential(withAccessToken: accessToken))
    }

    public func linkWithTwitter(withToken token: String, secret: String) -> Single<AuthDataResult> {
        return link(with: TwitterAuthProvider.credential(withToken: token, secret: secret))
    }

    public func linkWithPhoneAuth(withVerificationID verificationID: String, verificationCode code: String) -> Single<AuthDataResult> {
        return link(with: PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code))
    }

    public func linkWithGitHub(withToken token: String) -> Single<AuthDataResult> {
        return link(with: GitHubAuthProvider.credential(withToken: token))
    }

    func linkWithEmailAuth(email: String, password: String) -> Single<AuthDataResult> {
        return link(with: EmailAuthProvider.credential(withEmail: email, password: password))
    }

    public func link(with credential: AuthCredential) -> Single<AuthDataResult> {
        return base.currentUser.map { $0.rx.link(with: credential) } ?? .error(AuthError.userNotFound)
    }

    public func unlink(with provider: String) -> Single<User> {
        return base.currentUser.map { $0.rx.unlink(with: provider) } ?? .error(AuthError.userNotFound)
    }
}

// MARK: - Reload user
extension Reactive where Base: Auth {
    public func reloadUser() -> Completable {
        guard let currentUser = base.currentUser else {
            return .empty()
        }
        return currentUser.rx.reload()
    }
    public func reloadUser() -> Single<User> {
        return reloadUser()
            .andThen(Auth.auth().currentUser.map(Single.just) ?? .error(AuthError.userNotFound))
    }
}

// MARK: - Sign out
extension Reactive where Base: Auth {
    public func signOut() -> Completable {
        return .create { [weak auth = base] in
            completableEventHandler({ try auth?.signOut() }, $0)
            return Disposables.create()
        }
    }
}


// MARK: - Send password reset
extension Reactive where Base: Auth {
    public func sendPasswordReset(withEmail email: String) -> Completable {
        return .create { [weak auth = base] in
            auth?.sendPasswordReset(withEmail: email, completion: completableEventHandler($0))
            return Disposables.create()
        }
    }

    public func sendPasswordReset(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> Completable {
        return .create { [weak auth = base] in
            auth?.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings, completion: completableEventHandler($0))
            return Disposables.create()
        }
    }
}
