//
//  AuthRepository.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import FirebaseAuth
import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}


class AuthRepository: AuthRepositoryProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                let loggedInUser = User(uid: user.uid)
                completion(.success(loggedInUser))
            } else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login failed"])))
            }
        }
    }
}
