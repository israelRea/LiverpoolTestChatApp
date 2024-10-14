//
//  LoginViewModel.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import Foundation

class LoginViewModel {
    private let loginUserUseCase: LoginUserUseCaseProtocol
    var onLoginSuccess: ((String) -> Void)?
    var onLoginError: ((Error) -> Void)?
    
    init(loginUserUseCase: LoginUserUseCaseProtocol) {
        self.loginUserUseCase = loginUserUseCase
    }
    
    func login(email: String, password: String) {
        loginUserUseCase.execute(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.onLoginSuccess?(user.uid)
            case .failure(let error):
                self?.onLoginError?(error)
            }
        }
    }
}

