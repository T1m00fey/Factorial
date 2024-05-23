//
//  FactsManager.swift
//  Factorial
//
//  Created by Тимофей Юдин on 22.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Fact: Identifiable, Codable {
    let id: String
    let dateCreated: Date?
    let imageUrl: String?
    let text: String?
    let likesCount: Int?
}

final class FactsManager {
    
    static let shared = FactsManager()
    private init() {}
    
    private let factsCollection = Firestore.firestore().collection("facts")
    
    private func factDocument(factId: String) -> DocumentReference {
        factsCollection.document(factId)
    }
    
    func getFact(factId: String) async throws -> Fact {
        try await factDocument(factId: factId).getDocument(as: Fact.self)
    }
    
    func getAllFacts() async throws -> [Fact] {
        let snapshot = try await factsCollection.getDocuments()
        
        var facts: [Fact] = []
        
        for document in snapshot.documents {
            let fact = try document.data(as: Fact.self)
            facts.append(fact)
        }
        
        return facts
    }
}
