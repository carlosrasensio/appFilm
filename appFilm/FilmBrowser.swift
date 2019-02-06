//
//  FilmBrowser.swift
//  appFilm
//
//  Created by Carlos R. Asensio on 5/2/19.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class FilmBrowser: UIViewController {
    
    @IBOutlet var inputTextField: UITextField!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var overviewTextView: UITextView!
    
    @IBAction func recommendButton(_ sender: UIButton) {
    }
    
    
    @IBAction func addButton(_ sender: UIButton) {
       /*
        // Línea a continuación SIEMPRE en CoreData:
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // Se utiliza persistentContainer como vista de contexto y lo lleve todo al AppDelegate.
        // Creamos la película:
        let  film = Film(context: context)  // Se crea una película de tipo Película (entidad creada en iOSApp.xcdatamodeld).
        film.name = inputTextField.text    // Al atributo name se le asigna el título de la película que se muestra en el inputtextField.
        film.seen = false  // Al atributo seen se le asigna el valor por defecto false, es decir, que el usuario no ha visto la película.
        // Se guardan los datos:
        (UIApplication.shared.delegate as! AppDelegate).saveContext()   // Función saveContext() está en el AppDelegate.
        // Se envían esos datos a la otra pantalla:
        navigationController?.popViewController(animated: true) // Se asigna a qué vista se envía el dato.
        */
        // Se utiliza persistentContainer como vista de contexto. Lo lleva todo al AppDelegate:
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Creamos la película:
        let film = Film(context: context)
        film.name = inputTextField.text // El atributo name lo sacamos del inputTextField.
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
