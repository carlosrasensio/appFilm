//
//  Functions.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import Foundation
import Firebase

class Functions {
    
    // MARK: - Constants
    let defaults = UserDefaults.standard
    
    // MARK: - Navigation
    func goToScreen(storyboard: String, screen: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: screen)
        //present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UserDefaults
    func saveLoggedUser(loggedUser: User) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: loggedUser)
        defaults.set(encodedData, forKey: "loggedUser")
        defaults.synchronize()
        print("\n\nFunción saveLoggedUser:")
        print("Name: \(loggedUser.name)\nLast Name: \(loggedUser.lastName)\nEmail: \(loggedUser.email)\nSigned: \(loggedUser.signedIn)")
    }
    
    func readLoggedUser() -> User {
        let decoded  = self.defaults.data(forKey: "loggedUser")
        let decodedLoggedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! User
        print("\n\nFunción readLoggedUser:")
        print("Name: \(decodedLoggedUser.name)\nLast Name: \(decodedLoggedUser.lastName)\nEmail: \(decodedLoggedUser.email)\nSigned: \(decodedLoggedUser.signedIn)\nID Firebase: \(decodedLoggedUser.idFirebase)")
        
        return decodedLoggedUser
    }
    
    // MARK: - Firebase
    func getUserIdFirebase() -> String {
        var uid = ""
        if let user = Auth.auth().currentUser {
            uid = user.uid
        }
        return uid
    }
    
    func userLogout(loggedUser: User) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            loggedUser.signedIn = false
            saveLoggedUser(loggedUser: loggedUser)
            _ = readLoggedUser()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
            showAlert(title: "ERROR", message: signOutError.localizedDescription)
        }
    }
    
    // MARK: - Alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        //present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TMDB
    func modifyInputTMDB(input : String) -> String {
        
        var inputArray = input.components(separatedBy: " ") // Se crea un array para separar las palabras del input. Cada posición del array contiene una palabra.
        let sizeArray = inputArray.count  // Se obtiene el tamaño del array.
        var output : String = ""   // Se declara el output.
        
        for i in 0...sizeArray - 1 {  // Bucle for para recorrer el array.
            
            if (output == "") { // Si es la primera palabra del input.
                
                output = inputArray[0]
                
            } else {    // Si ya se tiene la primera palabra.
                
                output = "\(output)+\(inputArray[i])"   // Se concatenan con un +, necesario para buscar en la API.
                
            }
        }
        
        return output
        
    }
    
    // MARK: - MeaningCloud
    func modifyInputMC(input : String) -> String {
        
        var inputArray = input.components(separatedBy: " ") // Se crea un array para separar las palabras del input. Cada posición del array contiene una palabra.
        let sizeArray = inputArray.count  // Se obtiene el tamaño del array.
        var output : String = ""   // Se declara el output.
        
        for i in 0...sizeArray - 1 {  // Bucle for para recorrer el array.
            
            if (output == "") { // Si es la primera palabra del input.
                
                output = inputArray[0]
                
            } else {    // Si ya se tiene la primera palabra.
                
                output = "\(output)%20\(inputArray[i])"   // Se concatenan con un %, necesario para buscar en la API.
                
            }
        }
        
        return output
        
    }
    
}
