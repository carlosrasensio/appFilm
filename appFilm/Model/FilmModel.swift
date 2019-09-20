//
//  FilmModel.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 14/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import Foundation

class FilmModel {
    
    var name: String?
    var overview: String?
    
    init(name: String, overview: String) {
        self.name = name
        self.overview = overview
    }
    
}
