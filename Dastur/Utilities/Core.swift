//
//  Core.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import Foundation

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }

    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    func isUserSignedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserSignedIn")
    }
    
    func setIsUserSignedIn(isSigned: Bool) {
        UserDefaults.standard.set(isSigned, forKey: "isUserSignedIn")
    }
}
