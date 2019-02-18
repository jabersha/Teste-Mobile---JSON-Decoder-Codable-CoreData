////
////  Estrutura.swift
////  TesteMobile
////
////  Created by Jaber Shamali on 17/02/19.
////  Copyright © 2019 Jaber Shamali. All rights reserved.
////
//
//import UIKit
//
//class Estrutura: Codable {
//    
//    let teste: [Informacao]
//    
//    init(teste: [Informacao]) {
//        self.teste = teste
//    }
//}
//
//
//class Informacao: Codable {
//    let lastUpdate: String
//    let mapCount: Int
//    let maps: [Mapas]
//
//
//    init(lastUpdate: String, mapCount: Int, maps: Array<Any>) {
//        self.lastUpdate = lastUpdate
//        self.mapCount = mapCount
//        self.maps = maps as Array as! [Mapas]
//    }
//    
//
//}
//
//class Mapas: Codable {
//    let id: String
//    let name: String
//    let description: String
//    let url_pdf: String
//    
//    init(id: String, name: String, description: String, url_pdf: String) {
//        self.id = id
//        self.name = name
//        self.description = description
//        self.url_pdf = url_pdf
//    }
//}
