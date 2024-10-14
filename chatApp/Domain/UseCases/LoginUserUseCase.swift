//
//  LoginUserUseCase.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import Foundation

protocol LoginUserUseCaseProtocol {
    func execute(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void)
}

class LoginUserUseCase: LoginUserUseCaseProtocol {
    func execute(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void) {
        authRepository.login(email: email, password: password) { result in
                    completion(result) // Pasa el resultado directamente
                }
    }
    
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

}
