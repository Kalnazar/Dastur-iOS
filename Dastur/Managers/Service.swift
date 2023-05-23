//
//  Service.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit
import Firebase

class Service {
    
    static let shared = Service()
    
    func signUpUser(email: String, password: String, name: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                onError(error)
                return
            }
            
            self.uploadToDatabase(email: email, name: name, onSuccess: onSuccess)
        }
    }
    
    func uploadToDatabase(email: String, name: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).setValue(["email" : email, "name": name])
        onSuccess()
    }
    
    func getUserInfo(onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        
        ref.child("users").child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let email = dictionary["email"] as! String
                let name = dictionary["name"] as! String
                
                defaults.set(email, forKey: "userEmailKey")
                defaults.set(name, forKey: "userNameKey")
                
                onSuccess()
            }
        } withCancel: { (error) in
            onError(error)
        }

    }
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
    
}
