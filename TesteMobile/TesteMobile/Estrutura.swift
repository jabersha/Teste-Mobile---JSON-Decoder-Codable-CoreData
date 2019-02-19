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
