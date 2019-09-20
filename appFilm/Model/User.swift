//
//  User.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String
    var lastName: String
    var email: String
    var signedIn: Bool
    var idFirebase: String
    var idGoogle: String
    var idFacebook: String
    
    init(name: String, lastName: String, email: String, signedIn: Bool, idFirebase: String, idGoogle: String, idFacebook: String) {
        
        self.name = name
        self.lastName = lastName
        self.email = email
        self.signedIn = signedIn
        self.idFirebase = idFirebase
        self.idGoogle = idGoogle
        self.idFacebook = idFacebook
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let signedIn = aDecoder.decodeBool(forKey: "signedIn")
        let idFirebase = aDecoder.decodeObject(forKey: "idFirebase") as! String
        let idGoogle = aDecoder.decodeObject(forKey: "idGoogle") as! String
        let idFacebook = aDecoder.decodeObject(forKey: "idFacebook") as! String
        self.init(name: name, lastName: lastName, email: email, signedIn: signedIn, idFirebase: idFirebase, idGoogle: idGoogle, idFacebook: idFacebook)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(signedIn, forKey: "signedIn")
        aCoder.encode(idFirebase, forKey: "idFirebase")
        aCoder.encode(idGoogle, forKey: "idGoogle")
        aCoder.encode(idFacebook, forKey: "idFacebook")
    }

}
