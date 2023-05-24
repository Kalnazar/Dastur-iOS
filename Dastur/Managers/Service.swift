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
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
    
}
