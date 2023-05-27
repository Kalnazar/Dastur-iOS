//
//  Core.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import Foundation

class Core {
    
    static let shared = Core()
    private let defaults = UserDefaults.standard
    
    func isNewUser() -> Bool {
        return !defaults.bool(forKey: "isNewUser")
    }

    func setIsNotNewUser() {
        defaults.set(true, forKey: "isNewUser")
    }
    
    func DoesUserHaveProfilePicture() -> Bool {
        return defaults.bool(forKey: "doesUserHaveProfilePicture")
    }
    
    func setDoesUserHaveProfilePicture() {
        defaults.set(true, forKey: "doesUserHaveProfilePicture")
    }
}
