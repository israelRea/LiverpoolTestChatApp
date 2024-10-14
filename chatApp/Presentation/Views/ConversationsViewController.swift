//
//  ConversationsViewController.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//
import UIKit

struct TestConversation {
    let name: String
    let messagePreview: String
}


class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let conversations: [TestConversation] = [
        TestConversation(name: "Juan Pérez", messagePreview: "Hola, ¿cómo estás?"),
        TestConversation(name: "María García", messagePreview: "¿Nos vemos mañana?"),
        TestConversation(name: "Carlos Hernández", messagePreview: "Ya llegué al lugar."),
        TestConversation(name: "Ana López", messagePreview: "¿Qué tal tu día?"),
        TestConversation(name: "Luis Rodríguez", messagePreview: "Te mandé el archivo."),
    ]
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(profileButton)
        
        profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            profileButton.widthAnchor.constraint(equalToConstant: 60),
            profileButton.heightAnchor.constraint(equalToConstant: 60),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let conversation = conversations[indexPath.row]
        cell.textLabel?.text = "\(conversation.name): \(conversation.messagePreview)"
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConversation = conversations[indexPath.row]
        print("Selected conversation with \(selectedConversation.name)")

        let chatViewController = ChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

