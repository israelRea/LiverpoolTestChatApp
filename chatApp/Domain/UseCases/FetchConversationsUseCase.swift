//
//  FetchConversationsUseCase.swift
//  chatApp
//
//  Created by Praxis on 14/10/24.
//

import Foundation

protocol FetchConversationsUseCaseProtocol {
    func execute(userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void)
}

class FetchConversationsUseCase: FetchConversationsUseCaseProtocol {
    private let conversationRepository: ConversationRepositoryProtocol

    init(conversationRepository: ConversationRepositoryProtocol) {
        self.conversationRepository = conversationRepository
    }

    func execute(userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        conversationRepository.fetchConversations(for: userId, completion: completion)
    }
}
