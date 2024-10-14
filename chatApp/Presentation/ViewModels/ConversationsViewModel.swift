//
//  ConversationsViewModel.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import Foundation


import FirebaseFirestore

class ConversationsViewModel {
    private let fetchConversationsUseCase: FetchConversationsUseCaseProtocol
    var conversations: [Conversation] = []
    var onConversationsFetched: (() -> Void)?
    
    init(fetchConversationsUseCase: FetchConversationsUseCaseProtocol) {
        self.fetchConversationsUseCase = fetchConversationsUseCase
    }
    
    func fetchConversations(for userId: String) {
        fetchConversationsUseCase.execute(userId: userId) { [weak self] result in
            switch result {
            case .success(let conversations):
                self?.conversations = conversations
                self?.onConversationsFetched?()
            case .failure(let error):
                print("Error fetching conversations: \(error.localizedDescription)")
            }
        }
    }
}

