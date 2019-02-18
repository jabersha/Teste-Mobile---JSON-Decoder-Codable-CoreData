//
//  ViewController.swift
//  TesteMobile
//
//  Created by Jaber Shamali on 15/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import UIKit

struct InformacaoMapas: Codable {
    let lastUpdate: String
    let mapCount: Int
    let maps: [Mapas]
    
}

struct Mapas: Codable {
    let id: String
    let name: String
    let description: String
    let url_pdf: String
    

}


class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var mapsTb: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadMaps()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapsTableViewCell
        
        
        
        return cell

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsTb.dataSource = self
        
        
    }
    
    func loadMaps(){
        guard let url = URL(string: "https://us-central1-teste-mobile-atech.cloudfunctions.net/maps") else {return}
        let task = URLSession.shared.dataTask(with: url) { (dados, resposta, error) in
            guard let dataResponse = dados,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let model = try decoder.decode([InformacaoMapas].self, from: dataResponse)
                
                for _ in model{
                    print(model[0].mapCount)

                    for _ in model[0].maps{


                    }
                }
            } catch let parsingError{
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }





}

