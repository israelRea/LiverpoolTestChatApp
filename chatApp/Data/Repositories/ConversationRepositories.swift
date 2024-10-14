//
//  ConversationRepositories.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import FirebaseFirestore
import Foundation

protocol ConversationRepositoryProtocol {
    func fetchConversations(for userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void)
}

class ConversationRepository: ConversationRepositoryProtocol {
    private let firestore: Firestore

    init() {
        self.firestore = Firestore.firestore()
    }

    func fetchConversations(for userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        firestore.collection("conversations")
            .whereField("participants", arrayContains: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                var conversations: [Conversation] = []
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? "Sin Nombre"
                    conversations.append(Conversation(name: name,messagePreview: ""))
                }
                completion(.success(conversations))
            }
    }
}

