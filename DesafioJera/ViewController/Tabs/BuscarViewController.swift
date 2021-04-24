//
//  BuscarViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 24/04/21.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewProcurarFilmes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewProcurarFilmes.separatorStyle = .none
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaProcurarFilmes", for: indexPath) as! BuscarTableViewCell
        
        let indice = indexPath.row
        
        celula.textoNomeFilme.text = "nome teste \(indice)"
        celula.imagemFotoFilme.image = UIImage(named: "imagem-perfil")
        
        return celula
        
    }
    
    
    
    
    /*###################################################*/
    /*#################  Funcoes da API #################*/
    /*###################################################*/
    
    
    func procurarFilme(palavras_chave:String, pagina:String? = nil) -> [String: Any]{
        
        let url_base = "https://api.themoviedb.org/3/search/movie?"
        let key = "f4157bfa5391f523704b9b2054ea3561"
        
        let atributo_busca = "query="
        let atributo_pagina = "&page="
        let atributo_key = "&api_key="
        
        let url_s : String!
        var objetoJson : [String:Any]!
        
        if let page = pagina {
            url_s = url_base + atributo_busca + palavras_chave + atributo_pagina + page + atributo_key + key
        }else{
            url_s = url_base + atributo_busca + palavras_chave + atributo_key + key
        }

        if let url = URL(string: url_s){
            //Executa a requisicao até receber algum retorno.
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil{
                    
                    if let dadosRetorno = dados{
                        do {
                            objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]
                        } catch  {
                            objetoJson = [:]
                            print("\n\n\tErro na conversao para Json\n\n")
                        }

                    }
                }else{
                    objetoJson = [:]
                    print("\n\n\tErro na requisicao\n\n")
                }
            }
            //inicia a requisicao
            tarefa.resume()
        }
        return objetoJson
    }
    
    func resultadosBuscaFilmes(objetoJson : [String:Any]) -> Array<Any>{
        
        if let resultados = objetoJson["results"] as? Array<Any>{
            //print(resultados[0])
            //let resultado1 = resultados[0] as? [String: Any]
            //print(resultado1?["id"])
            return resultados
        }
        return []
    }
    
    func totalFilmesBusca(objetoJson : [String:Any]) -> Int{
        if let total_results = objetoJson["total_results"]{
            return total_results as! Int
        }
        return -1
    }
    func totalPaginasBusca(objetoJson : [String:Any]) -> Int{
        if let total_pages = objetoJson["total_pages"]{
            return total_pages as! Int
            //print(total_pages)
        }
        return -1
    }
    func numeroPaginaAtualBusca(objetoJson : [String:Any]) -> Int{
        if let page = objetoJson["page"]{
            return page as! Int
        }
        return -1
    }
    

}
