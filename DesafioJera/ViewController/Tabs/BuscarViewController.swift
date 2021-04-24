//
//  BuscarViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 24/04/21.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableViewProcurarFilmes: UITableView!
    @IBOutlet weak var searchBarProcurarFilmes: UISearchBar!
    
    
    var resultados : Array<Any>!
    var totalPaginas : Int!
    var totalFilmes : Int!
    var totalFilmesArray : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewProcurarFilmes.separatorStyle = .none
        searchBarProcurarFilmes.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Recupera na variavel "searchText" o que foi digitado, caracter por caracter
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var objetoJson : [String:Any]!
        
        if let palavraDigitada = searchBar.text{
            
            let palavraURI = palavraDigitada.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) //corrigir para URI
            //print(palavraDigitada.encode(to: ))
            
            /*###################################################*/
            /*#################### teste ########################*/
            /*###################################################*/
            
            
            
                                let url_base = "https://api.themoviedb.org/3/search/movie?"
                                let key = "f4157bfa5391f523704b9b2054ea3561"
                                
                                let atributo_busca = "query="
                                let atributo_pagina = "&page="
                                let atributo_key = "&api_key="
                                
                                var url_s : String!
                                
                                url_s = url_base + atributo_busca + palavraURI + atributo_key + key
                                
                                if let url = URL(string: url_s){
                                    
                                    let data = NSData(contentsOf: url)
                                    
                                    if let dadosRetorno = data{
                                        do {
                                            if let objeto = try JSONSerialization.jsonObject(with: dadosRetorno as Data, options: []) as? [String: Any]{
                                                objetoJson = objeto
                                            }
                                            //print(self.totalFilmesBusca())
                                        } catch  {
                                            //self.objetoJson = nil
                                            print("\n\n\tErro na conversao para Json\n\n")
                                        }

                                    }
                                    
                                    
                                }else{
                                    print("Erro estranho")
                                }
            
            
            /*###################################################*/
            /*#################### Fim teste ####################*/
            /*###################################################*/
            
            //procurarFilme(palavras_chave: palavraDigitada)
            if objetoJson == nil{
                print("\n\nErro\n\n")
            }else{
                resultados = resultadosBuscaFilmes(objetoJson: objetoJson)
                totalPaginas = totalPaginasBusca(objetoJson: objetoJson)
                totalFilmes = totalFilmesBusca(objetoJson: objetoJson)
                totalFilmesArray = resultados.count
                
                self.tableViewProcurarFilmes.reloadData()
            }
            
        }
        
        
    }
    
    /*###################################################*/
    /*################# Listagem Tabela #################*/
    /*###################################################*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalFilmesArray == nil{
            totalFilmesArray = 0
        }
        return totalFilmesArray
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaProcurarFilmes", for: indexPath) as! BuscarTableViewCell
        
        let indice = indexPath.row
        
        let filme = resultados[indice] as! [String:Any]
        let tituloFilme = filme["original_title"]
        
        celula.textoNomeFilme.text = tituloFilme as! String
        celula.imagemFotoFilme.image = obterImagemFilme(filme: filme)
        
        return celula
        
    }
    
    
    /*###################################################*/
    /*#################  Funcoes da API #################*/
    /*###################################################*/
    
    
    func resultadosBuscaFilmes(objetoJson : [String:Any]) -> Array<Any>{
        
        if let resultados = objetoJson["results"] as? Array<Any>{
            //print(resultados[0])
            //let resultado1 = resultados[0] as? [String: Any]
            //print(resultado1?["id"])
            return resultados
        }
        return []
    }
    
    func obterImagemFilme(filme: [String:Any]) -> UIImage?{
        
        let url_base = "https://image.tmdb.org/t/p/w500"
        let nomeImagem = filme["poster_path"] as! String
        
        let url_s = url_base + nomeImagem
        
        var image: UIImage? = nil
        
        if let url = URL(string: url_s){
            
            do {
                //3. Get valid data
                let data = try Data(contentsOf: url, options: [])

                //4. Make image
                image = UIImage(data: data)
            }
            catch {
                print(error.localizedDescription)
            }
            
        }else{
            print("Erro estranho")
        }
        
        return image
        
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
