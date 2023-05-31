//
//  DatabaseManager.swift
//  Dastur
//
//  Created by Саят Калназар on 25.05.2023.
//

import Foundation
import Firebase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
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
}

// MARK: - Favourites management

extension DatabaseManager {
    public func addToFavourites(id: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.child("favourites").child(uid).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if var favourites = snapshot.value as? [String] {
                if favourites.contains(id) {
                    print("Tradition already in favourites")
                    return
                }
                favourites.append(id)
                strongSelf.database.child("favourites").child(uid).setValue(favourites)
            } else {
                let favourites = [id]
                strongSelf.database.child("favourites").child(uid).setValue(favourites)
            }
        })
    }
    
    public func removeFromFavourites(id: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        database.child("favourites").child(uid).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else { return }
            
            if var favourites = snapshot.value as? [String] {
                if let index = favourites.firstIndex(of: id) {
                    favourites.remove(at: index)
                    strongSelf.database.child("favourites").child(uid).setValue(favourites)
                } else {
                    print("Tradition not found in favourites")
                }
            } else {
                print("No favourites found")
            }
        }
    }
    
    public func getTraditionsForFavorites(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Fetch the user's favorites
        database.child("favourites").child(uid).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else { return }
            
            guard let favorites = snapshot.value as? [String] else {
                completion(.success([]))
                return
            }
            
            var traditions = [[String: String]]()
            let dispatchGroup = DispatchGroup()
            
            for traditionId in favorites {
                dispatchGroup.enter()
                strongSelf.database.child("traditions").observeSingleEvent(of: .value) { snapshot in
                    guard let traditionsCollection = snapshot.value as? [[String: String]] else { return }
                    for tradition in traditionsCollection {
                        if tradition["name"] == traditionId {
                            traditions.append(tradition)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(.success(traditions))
            }
        }
    }

}

// MARK: - Tradition management

extension DatabaseManager {
    public func uploadTradition(with tradition: TraditionModel) {
        self.database.child("traditions").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            if var traditionsCollection = snapshot.value as? [[String: String]] {
                // Append to tradition dictionary
                let newTradition = [
                    "name": tradition.name,
                    "description": tradition.description,
                    "image_name": tradition.imageName,
                    "rating": tradition.rating,
                    "typeId": tradition.typeID
                ]
                traditionsCollection.append(newTradition)
                strongSelf.database.child("traditions").setValue(traditionsCollection)
            } else {
                // Create a new collection
                let newTradition: [[String: String]] = [
                    [
                        "name": tradition.name,
                        "description": tradition.description,
                        "image_name": tradition.imageName,
                        "rating": tradition.rating,
                        "typeId": tradition.typeID
                    ]
                ]
                strongSelf.database.child("traditions").setValue(newTradition)
            }
        }
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
}
