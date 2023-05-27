//
//  StorageManager.swift
//  Dastur
//
//  Created by Саят Калназар on 26.05.2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    public typealias GetPictureCompletion = (Result<Data, Error>) -> Void
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data,
                                     filename: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(filename)").putData(data, metadata: nil) { metaData, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(filename)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print(urlString)
                completion(.success(urlString))
            }
        }
    }
    
    public func getProfilePicture(filename: String, completion: @escaping GetPictureCompletion) {
        storage.child("images/\(filename)").getData(maxSize: 5 * 1024 * 1024) { data, error in
            guard let data = data, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(data))
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
