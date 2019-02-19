//
//  ViewController.swift
//  TesteMobile
//
//  Created by Jaber Shamali on 15/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var updateLb: UILabel!
    @IBOutlet weak var mapsTb: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var mapas: [Mapas] = []
    var infoUpdate: String = ""
    var infoMaps: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsTb.dataSource = self
        self.mapsTb.delegate = self
        loadMaps()
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
                    self.mapas = model[0].maps
                }
                self.infoUpdate = model[0].lastUpdate
                self.infoMaps = String(model[0].mapCount)
            } catch let parsingError{
                print("Error", parsingError)
            }
            self.mapsTb.reloadData()
        }
        task.resume()
    }

}

extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapas.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapsTableViewCell
        cell.nameLb.text = mapas[indexPath.row].name
        cell.descripLb.text = mapas[indexPath.row].description
        cell.url = mapas[indexPath.row].url_pdf
        self.updateLb.text = "Last Update: " + infoUpdate
        self.countLb.text = "Maps: " + infoMaps
        
        
        
        return cell
        
    }
}
