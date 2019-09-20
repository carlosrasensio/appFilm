//
//  FilmBrowser.swift
//  appFilm
//
//  Created by Carlos R. Asensio on 5/2/19.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class FilmBrowser: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    
    // MARK: - Constants
    let apiKey = "5d8bb741e4498fd5448bc0738a12eb52" // Clave de la API para cada usuario.
    
    // MARK: - Global variables
    var index = 0   // Se declara esta variable fuera para que el valor de i se vaya incrementando.
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Recommend button action
    @IBAction func recommendButton(_ sender: UIButton) {
        
        let input = inputTextField.text // Se asigna aquí lo que escribimos en el inputTextField.
        print(input!)   // Se muestra por consola el input.
        if (inputTextField.text?.isEmpty)! {
            
            let message = "Para poder ayudarte tienes que introducir una película en el recomendador."
            showAlert(message: message)
            
        } else {
            
            getRecommendedFilm(filmInput: input!, apiKey: apiKey)    // Se llama a la función que recomienda la película.
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func microphoneInput(_ sender: Any) {
        
        
        
    }
    
    
    // MARK: - Add button action
    @IBAction func addButton(_ sender: UIButton) {

        // Se utiliza persistentContainer como vista de contexto. Lo lleva todo al AppDelegate (obligatorio en CoreData):
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Creamos la película:
        let film = Film(context: context)
        film.name = titleLabel.text // El atributo name lo sacamos del titleLabel.
        
        // Utilizar STRUCT para los datos de la peli ¿¿??
        
        // Se comprueba si se ha escrito algo en el inputTextField para que no se rellene la tabla con celdas vacias:
        if (inputTextField.text?.isEmpty)! {
            
            let message = "Para añadir a la lista hay que introducir una película en el recomendador primero"
            showAlert(message: message)
    
        } else {
            
           (UIApplication.shared.delegate as! AppDelegate).saveContext()    // Se guardan los datos. La función saveContext() está en el AppDelegate.
            
        }
        
        navigationController?.popViewController(animated: true) // Se asigna a qué vista se envía el dato.
        
    }
    
    // MARK: - Get recommended film
    // Función que devuelve una película recomendada a la película pasada como input:
    func getRecommendedFilm(filmInput : String, apiKey : String) -> Void {
        
        let film = modifyInputTMDB(input: filmInput)
        
        let idApiURL = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=es&query=\(film)" // URL de la API. Web donde entra la app para coger el archivo JSON.
        
        guard let idURL = URL(string: idApiURL) else { return } // guard es una especie de if, pero reduce el código al mínimo.
        
        guard let idData = try? Data(contentsOf: idURL) // Se descargan los datos del archivo JSON. Primero se pasan esos datos a datos legibles.
            else {
                print("Error en la primera descarga de datos del archivo JSON (ID)")
                return
        }
        
        do {
            
            let idJSON = try JSONSerialization.jsonObject(with: idData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary   // Este código se usa SIEMPRE para JSON. Se convierte el archivo JSON en datos. Se usa NSDictionary porque se sabe que son datos de ese tipo. Hay que saber el tipo de dato que es.
            
            // Se accede a los arreglos (datos de dentro que nos interesan) del archivo JSON:
            let idResultsArray: NSArray = (idJSON!["results"] as? NSArray)! // Se accede al arreglo.
            
            // SOLUCIONAR: cuando al pulsar el botón Recomendación (por 21ª vez) se llegue al final de la página 1, pasar a la página 2.
            
            let idFilmInfo: NSDictionary = idResultsArray[0] as! NSDictionary    // Se ha entrado al arreglo.
            let id = idFilmInfo["id"] as? Int // Se coge el dato deseado del arreglo.
            let idString : String!
            idString = "\(String(describing: id ?? 0))"  // Se pasa id de Int a String (se pone ?? 0 para que no aparezca el Optional).
            print(idString ?? 0)    // El '?? 0' es para que no aparezca como Optional.
            
            // Una vez se tenga el ID se acceden a los datos de la película:
            let recomApiURL = "https://api.themoviedb.org/3/movie/\(idString!)/similar?api_key=\(apiKey)&language=es&page=1"
            
            guard let recomURL = URL(string: recomApiURL) else { return }   // guard es una especie de if, pero reduce el código al mínimo.
            
            guard let recomData = try? Data(contentsOf: recomURL) // Se descargan los datos del archivo JSON. Primero se pasan esos datos a datos legibles.
                else {
                    print("Error en la segunda descarga de datos del archivo JSON (Recomendación)")
                    return
            }
            
            do {
                
                let recomJSON = try JSONSerialization.jsonObject(with: recomData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary   // Este código se usa SIEMPRE que se use JSON. Se convierte el archivo JSON en datos. Se usa NSDictionary porque se sabe que son datos de ese tipo. Hay que saber el tipo de dato que es.
                
                // Se accede a los arreglos (datos de dentro que nos interesan) del archivo JSON:
                let recomResultsArray: NSArray = (recomJSON!["results"] as? NSArray)! // Se accede al arreglo.
                
                // Se obtiene una recomendación cada vez que se pulsa el botón:
                let recomFilmInfo: NSDictionary = recomResultsArray[index] as! NSDictionary    // Se accede al arreglo.
                let title = recomFilmInfo["title"] as? String // Se coge el dato deseado del arreglo.
                print(title!)
                self.titleLabel.text = "\(title!)"    // Se muestra el titulo por el titleLabel.
                index += 1  // Se incrementa el valor de i para que se obtengan más películas.
                
                let overview = recomFilmInfo["overview"] as? String // Se coge el dato deseado del arreglo.
                print(overview!)
                self.overviewTextView.text = "\(overview!)"    // Se muestra el resumen por el resumenTextView.
            
            } catch {
                print("Error en la obtención de las películas recomendadas")
            }
            
            
        } catch {
            print("Error en la obtención del ID de la película")
        }
        
    }
    
    // Función que modifica el input para que se adapte a las necesidades de la API:
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
        
        print("\nModified film: " + output)
        return output
        
    }
    
    func modifyInputMC(input : String) -> String {
        
        var inputArray = input.components(separatedBy: " ") // Se crea un array para separar las palabras del input. Cada posición del array contiene una palabra.
        let sizeArray = inputArray.count  // Se obtiene el tamaño del array.
        var output : String = ""   // Se declara el output.
        
        for i in 0...sizeArray - 1 {  // Bucle for para recorrer el array.
            
            if (output == "") { // Si es la primera palabra del input.
                
                output = inputArray[0]
                
            } else {    // Si ya se tiene la primera palabra.
                
                output = "\(output)%\(inputArray[i])"   // Se concatenan con un %, necesario para buscar en la API.
                
            }
        }
        
        return output
        
    }
    
    // MARK: - Alert function
    func showAlert(message : String) -> Void { // Función para sacar un mensaje en una alerta.
        
        let alert = UIAlertController(title: "¡Acción incorrecta!", message: message, preferredStyle: .alert)   // Se crea la propia alerta con un mensaje que se introduce posteriormente.
        
        let actionOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in    // Se crea el la opción de cerrar la alerta una vez entendido el mensaje pulsando un botón.
            
            alert.dismiss(animated: true, completion: nil) // Una vez se pulsa el accionOK, se elimina la alerta.
            
        }
        
        alert.addAction(actionOK)  // Se añade la actionOK a la alerta.
        self.present(alert, animated: true, completion: nil)   // Presentación de la alerta.
        
    }

}
