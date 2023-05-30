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
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Inserts new user to database
    /// - Parameter user: (username, email)
    public func insertUser(with user: User, completion: @escaping (Bool) -> Void) {
        self.database.child("users").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            if var usersCollection = snapshot.value as? [[String: String]] {
                // append to user dictionary
                let newElement = [
                    "username": user.username,
                    "email": user.safeEmail
                ]
                usersCollection.append(newElement)
                strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            } else {
                // create that array
                let newCollection: [[String: String]] = [
                    [
                        "username": user.username,
                        "email": user.safeEmail
                    ]
                ]
                strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            }
        })
    }
    
    public func getAllData(from collection: String, completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child(collection).observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(collection))
        })
    }
    
    public func getDataOfType(id: String, completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("traditions").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            var traditions = [[String: String]]()
            for tradition in collection {
                if tradition["typeId"] == id {
                    traditions.append(tradition)
                }
            }
            completion(.success(traditions))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
}
