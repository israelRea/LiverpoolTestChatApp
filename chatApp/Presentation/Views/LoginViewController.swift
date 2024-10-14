//
//  LoginViewController.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailLabel: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "Correo electrónico:"
          return label
      }()
    
    let passwordLabel: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "Contraseña:"
          return label
      }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 20
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 20
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitle("Inicar Sesión", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.backgroundColor = .white
        
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        
        setupConstraints()
        setupButtonActions()
        bindViewModel()
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupButtonActions(){
        loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
          
    }
    
    private func bindViewModel() {
        
        viewModel.onLoginSuccess = { [weak self] uid in
            DispatchQueue.main.async {
                let conversationsViewController = ConversationsViewController()
                
                let navigationController = UINavigationController(rootViewController: conversationsViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true, completion: nil)
            }
        }

         
         viewModel.onLoginError = { error in
             DispatchQueue.main.async {
                 let alert = UIAlertController(title: "Error al iniciar sesión", message: error.localizedDescription, preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default))
                 self.present(alert, animated: true, completion: nil)
             }
         }
     }
    
    @objc func buttonTapped() {
        print("Button was tapped!")
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
        }
        viewModel.login(email: email, password: password)
      }
    
}

