//
//  BuscarViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 24/04/21.
//

import UIKit

class BuscarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url_base = "https://api.themoviedb.org/3/search/movie?"
        let atributo_busca = "query="
        let palavras_chave = "the"
        let atributo_key = "&api_key="
        let key = "f4157bfa5391f523704b9b2054ea3561"
        
        let url_s = url_base + atributo_busca + palavras_chave + atributo_key + key
        
        print(url_s)
        print("\n")
        
        if let url = URL(string: url_s){
            //Executa a requisicao até receber algum retorno.
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil{
                    
                    if let dadosRetorno = dados{
                        
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                                
                                if let page = objetoJson["page"]{
                                    print(page)
                                }
                                if let resultados = objetoJson["results"]{
                                    print(resultados)
                                }
                                if let total_pages = objetoJson["total_pages"]{
                                    print(total_pages)
                                }
                                if let total_results = objetoJson["total_results"]{
                                    print(total_results)
                                }
                                
                            }
                            
                        } catch  {
                            print("\n\n\tErro na conversao para Json\n\n")
                        }
                        
                    }
                    
                }else{
                    print("\n\n\tErro na requisicao\n\n")
                }
                
            }
            //inicia a requisicao
            tarefa.resume()
        }
        
    }
    



}
