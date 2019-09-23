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
    let apiKeyTMDB = "5d8bb741e4498fd5448bc0738a12eb52" // Clave API TMDB
    let apiKeyMC = "be81de187602117dd8739297ab21d8a0"   // Clave API meaningcloud (MC)
    let functions = Functions()
    
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
        if (inputTextField.text?.isEmpty)! {
            let message = "Para poder ayudarte tienes que introducir una película en el recomendador"
            showAlert(message: message)
        } else {
            getRecommendedFilm(filmInput: input!)    // Se llama a la función que recomienda la película.
        }
    }
    
    // MARK: - Add button action
    @IBAction func addButton(_ sender: UIButton) {
        // Se utiliza persistentContainer como vista de contexto. Lo lleva todo al AppDelegate (obligatorio en CoreData):
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Creamos la película:
        let film = Film(context: context)
        film.name = titleLabel.text // El atributo name lo sacamos del titleLabel.
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
    func getRecommendedFilm(filmInput : String) {
        let film = functions.modifyInputTMDB(input: filmInput)
        var parrafoMC = ""
        // ******************************** INICIO TMDB **************************************
        let idApiURL = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKeyTMDB)&language=en-US&query=\(film)"
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
            print("\nID: " + idString ?? 0)    // El '?? 0' es para que no aparezca como Optional.
            
            // ******** Una vez se tenga el ID se acceden a los datos de la película *********
            let recomApiURL = "https://api.themoviedb.org/3/movie/\(idString!)/similar?api_key=\(apiKeyTMDB)&language=en&page=1"
            guard let recomURL = URL(string: recomApiURL) else { return }   // guard es una especie de if, pero reduce el código al mínimo.
            guard let recomData = try? Data(contentsOf: recomURL) // Se descargan los datos del archivo JSON. Primero se pasan esos datos a datos legibles.
                else {
                    print("Error en la segunda descarga de datos del archivo JSON (Recomendación)")
                    return
            }
            do {
                let recomJSON = try JSONSerialization.jsonObject(with: recomData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                let recomResultsArray: NSArray = (recomJSON!["results"] as? NSArray)!
                // Se obtiene una recomendación cada vez que se pulsa el botón:
                let recomFilmInfo: NSDictionary = recomResultsArray[index] as! NSDictionary
                // Se cogen los datos deseados del arreglo.
                let title = recomFilmInfo["title"] as? String
                print("\nTitulo recomendado: " + title!)
                self.titleLabel.text = "\(title!)"
                index += 1  // Se incrementa el valor de i para que se obtengan más películas al pulsar el botón recomendación.
                let overview = recomFilmInfo["overview"] as? String // Se coge el dato deseado del arreglo.
                print("Resumen: " + overview! + "\n")
                self.overviewTextView.text = "\(overview!)"
                parrafoMC = overview!   // Texto que se va a pasar a MC
            } catch {
                print("Error en la obtención de las películas recomendadas")
            }
        } catch {
            print("Error en la obtención del ID de la película")
        }
        // ******************************** FIN TMDB **************************************
        
        // ***************************** INICIO MEANINGCLOUD ***********************************
        let parrafoModifyMC = functions.modifyInputMC(input: parrafoMC)
        var topics:[String] = ["", "", "", "", ""]
        let recomResultsArray: NSArray
        let recomApiUrlMC = "https://api.meaningcloud.com/topics-2.0?key=\(apiKeyMC)&of=json&lang=en&ilang=en&txt=\(parrafoModifyMC)&tt=e&uw=y" // tt=e --> Entities; tt=c --> Concepts
        guard let recomUrlMC = URL(string: recomApiUrlMC) else { return }
        guard let recomDataMC = try? Data(contentsOf: recomUrlMC)
        else {
            print("Error en la descarga de datos del archivo JSON (MC)")
            return
        }
        do {
            let recomJSON = try JSONSerialization.jsonObject(with: recomDataMC, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            recomResultsArray = (recomJSON!["entity_list"] as? NSArray)!
            print("\nTópicos encontrados: " + String(recomResultsArray.count))
            // Se obtienen tópicos de cada película recomendada
            var i:Int = 0
            while(recomResultsArray.count != 0 && i<recomResultsArray.count && i<5) {
                let recomFilmInfo: NSDictionary = recomResultsArray[i] as! NSDictionary
                topics[i] = (recomFilmInfo["form"] as? String)!
                let relevance = recomFilmInfo["relevance"] as? String
                print("Form: " + topics[i] + " [Relevance: " + relevance! + "]")
                i = i + 1
            }
        } catch {
            print("Error en la obtención de los tópicos")
        }
        // ******************************** FIN MEANINGCLOUD **************************************
        
        // ******************************** INICIO KEYWORD **************************************
        for i in 0...(topics.count - 1) {
            print("\n[INFO] Entra al bucle de KW\n")
            let topicModified = functions.modifyInputMC(input: topics[i])
            let recomApiUrlKW = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKeyTMDB)&language=en-US&query=\(topicModified)&page=1&include_adult=false"
            print("\nTópico: " + topics[i])
            guard let recomUrlKW = URL(string: recomApiUrlKW) else { return }
            guard let recomData = try? Data(contentsOf: recomUrlKW)
            else {
                print("Error en la segunda descarga de datos del archivo JSON (Keyword)")
                return
            }
            do {
                let recomJSON = try JSONSerialization.jsonObject(with: recomData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                let totalResults = recomJSON!["total_results"] as? Int
                print("\ntotalResults: " + String(totalResults!))
                if totalResults == 0 {
                    print("\nNo hay resultados utilizando el tópico siguiente: " + topics[i])
                } else {
                    let recomResultsArray: NSArray = (recomJSON!["results"] as? NSArray)!
                    let recomFilmInfo: NSDictionary = recomResultsArray[0] as! NSDictionary
                    let title = recomFilmInfo["title"] as? String
                    print("\nTitulo KW: " + title!)
                    let overview = recomFilmInfo["overview"] as? String
                    print("Overview KW: " + overview!)
                }
            } catch {
                print("Error en la obtención de las películas recomendadas por keyword")
            }
        }
        print("\nFin. No hay más tópicos")
        // ******************************** FIN KEYWORD **************************************
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
