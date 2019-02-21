//
//  ViewController.swift
//  TesteMobile
//
//  Created by Jaber Shamali on 15/02/19.
//  Copyright © 2019 Jaber Shamali. All rights reserved.
//

import UIKit
import CoreData
import Network



class ViewController: UIViewController {
    
    
    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var updateLb: UILabel!
    @IBOutlet weak var mapsTb: UITableView!
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    
    var mapas: [Mapas] = []
    var infoUpdate: String = ""
    var infoMaps: String = ""

    var index: Int = 0
    
    var resultados: NSFetchedResultsController <MapData>?
    var resultadosInfo: NSFetchedResultsController <InfoData>?
    
    var contexto: NSManagedObjectContext{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapsTb.dataSource = self
        self.mapsTb.delegate = self
        
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Você está conectado")
                self.loadMaps()
                return
            } else {
                print("Você está offline")
                self.showData()
                
            }
        }
    

        



    }
    
    func loadMaps(){
        
        //Recebe Json
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
            DispatchQueue.main.async {
                self.mapsTb.reloadData()
            }
            
        }
        task.resume()
        //

    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    //Monta tabelas e celulas
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

        guard let listaInfos = resultadosInfo?.fetchedObjects![1]
            else {
                self.updateLb.text = "Last Update: " + infoUpdate
                self.countLb.text = "Maps: " + infoMaps
                return cell
        }
        self.updateLb.text = "Last Update: " + listaInfos.update!
        self.countLb.text = "Maps: " + listaInfos.count!



        return cell
    }
}

extension ViewController{
    
    //CoreData
    func createData(){
        let dados = MapData(context: contexto)
        let information = InfoData(context: contexto)
        
        dados.id = mapas[self.index].id
        dados.name = mapas[self.index].name
        dados.descript = mapas[self.index].description
        dados.url = mapas[self.index].url_pdf
        information.update = infoUpdate
        information.count = infoMaps
        
        do{
            try contexto.save()
            print("Salvo")
        } catch {
            print("Erro")
        }
    }
    
    
    func showData(){

        let pesquisaMap:NSFetchRequest<MapData> = MapData.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "name", ascending: true)
        pesquisaMap.sortDescriptors = [ordenacao]

        let pesquisaInfo:NSFetchRequest<InfoData> = InfoData.fetchRequest()
        let ordenacaoInfo = NSSortDescriptor(key: "count", ascending: true)
        pesquisaInfo.sortDescriptors = [ordenacaoInfo]
        
        resultados = NSFetchedResultsController(fetchRequest: pesquisaMap, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try resultadosInfo?.performFetch()
            try resultados?.performFetch()
        } catch {
            print("Erro ao puxar")
        }

    }
}

extension ViewController{
//para testes
    func preload(){
        _ = self.view
    }

}
