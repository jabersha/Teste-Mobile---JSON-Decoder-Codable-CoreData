//
//  ViewController.swift
//  TesteMobile
//
//  Created by Jaber Shamali on 15/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var updateLb: UILabel!
    @IBOutlet weak var mapsTb: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var mapas: [Mapas] = []
    var infoUpdate: String = ""
    var infoMaps: String = ""
    
    var index: Int = 0
    
    var resultados: NSFetchedResultsController <MapData>?
    
    var contexto: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsTb.dataSource = self
        self.mapsTb.delegate = self
        loadMaps()
        showData()
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
        
        guard let lista = resultados?.fetchedObjects?.count else {
            return mapas.count
            
        }
        return lista
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapsTableViewCell
        
        guard let listaDados = resultados?.fetchedObjects![indexPath.row]
            else {
                
                cell.nameLb.text = mapas[indexPath.row].name
                cell.descripLb.text = mapas[indexPath.row].description
                cell.url = mapas[indexPath.row].url_pdf
                self.updateLb.text = "Last Update: " + infoUpdate
                self.countLb.text = "Maps: " + infoMaps
                
                self.index = indexPath.row
                
                createData()
                return cell
            
        }
        
        cell.nameLb.text = listaDados.name
        cell.descripLb.text = listaDados.descript
        cell.url = listaDados.url
        
        

        return cell
    }
}

extension ViewController{
    //CoreData
    func createData(){
         let dados = MapData(context: contexto)
        
        dados.id = mapas[self.index].id
        print(dados.id!)
        dados.name = mapas[self.index].name
        dados.descript = mapas[self.index].description
        dados.url = mapas[self.index].url_pdf
        
        do{
            try contexto.save()
            print(dados.id!)
            print("Salvo")
        } catch {
            print("Erro")
        }
        
    }
    
    func showData(){
        
        if resultados?.fetchedObjects?.count == 0 {
            loadMaps()
        }
        let pesquisaMap:NSFetchRequest<MapData> = MapData.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "name", ascending: true)
        pesquisaMap.sortDescriptors = [ordenacao]
        
        resultados = NSFetchedResultsController(fetchRequest: pesquisaMap, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try resultados?.performFetch()
        } catch {
            print("Erro ao puxar")
        }
        
    }
    
   
    
}
