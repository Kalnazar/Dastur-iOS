//
//  DatabaseManager.swift
//  Dastur
//
//  Created by Саят Калназар on 25.05.2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Inserts new user to database
    /// - Parameter user: (username, email, image)
    public func insertUser(with user: User) {
        database.child(user.email).setValue([
            "username": user.username
        ])
    }
}
