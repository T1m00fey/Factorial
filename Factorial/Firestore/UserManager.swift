//
//  UserManager.swift
//  Factorial
//
//  Created by Тимофей Юдин on 20.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let name: String?
    let email: String?
    let dateCreated: Date?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.name = auth.name
        self.email = auth.email
        self.dateCreated = Date()
    }
    
    init(
        userId: String,
        name: String? = nil,
        email: String? = nil,
        dateCreated: Date? = nil
    ) {
        self.userId = userId
        self.name = name
        self.email = email
        self.dateCreated = dateCreated
    }
    
//    func togglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//
//        let updatedUser = DBUser(
//            userId: userId,
//            email: email,
//            photoUrl: photoUrl,
//            dateCreated: dateCreated,
//            isPremium: !currentValue
//        )
//    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case name = "name"
        case email = "email"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func deleteUser(user: DBUser) async throws {
        try await userDocument(userId: user.userId).delete()
    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String: Any] = [
//            "user_id": auth.uid,
//            "date_created": Timestamp()
//        ]
//
//        if let email = auth.email {
//            userData["email"] = email
//        }
//
//        if let photoUrl = auth.photoUrl {
//            userData["photoUrl"] = photoUrl
//        }
//
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
//    func getUser(userId: String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userId).getDocument()
//
//        guard let data = snapshot.data() else {
//            throw URLError(.badServerResponse)
//        }
//
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let date_created = data["date_created"] as? Date
//
//        return DBUser(userId: userId, email: email, photoUrl: photoUrl, date_created: date_created)
//    }
    
//    func updatePremiumStatus(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
}
