//
//  ViewController.swift
//  appFilm
//
//  Created by Carlos R. Asensio on 5/2/19.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

// Se añaden SIEMPRE los delegados UITableViewDataSource y UITableViewDelegate a la clase.
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var filmTable: UITableView!
    
    var films : [Film] = [] // Variable films que está cogiendo los datos del array Film.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmTable.dataSource = self // La fuente de datos será ella misma.
        filmTable.delegate = self   // El delegado será ella misma.
    }
    
    // Actualización de datos. La tabla se actualiza contínuamente:
    override func viewWillAppear(_ animated: Bool) {
        Data()
        filmTable.reloadData()
    }
    
    // Contador de películas hay almacenadas (función obligatoria):
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    // Añadir celdas (función obligatoria):
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Se configuran las celdas:
        let cell = UITableViewCell()    // Se asigna una celda a cada elemento.
        let film = films[indexPath.row] // A cada película, que será una fila (row), se le va a asignar un indexPath.
        cell.textLabel?.text = film.name! //A esa celda se le asignará un nombre.
        
        return cell
    }
    
    // Trabajar con los datos:
    func Data() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            
            films = try context.fetch(Film.fetchRequest())  // Hay que usarlo SIEMPRE. Significa que se envíe una respuesta de si los datos utilizados en AppDelegate los puede utilizar.
            
        } catch {
            
            print("Error en la función Data")
            
        }
        
    }
    
    // Borrar celdas:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // Cada vez que se mete esta línea de código es para poder trabajar con estos datos.
        
        if editingStyle == .delete {    // Si le damos al botón de borrar.
            
            let film = films[indexPath.row]
            context.delete(film)
            (UIApplication.shared.delegate as! AppDelegate).saveContext() // Se vuelven a guardar los datos.
            
            do{
                
                films = try context.fetch(Film.fetchRequest())  // Hay que usarlo SIEMPRE. Significa que se envíe una respuesta de si los datos utilizados en AppDelegate los puede utilizar. Es como una llamada al AppDelegate.
                
            } catch {
                
                print("Error en la función Borrar celdas")
                
            }
        }
        
        filmTable.reloadData()
    }

}

