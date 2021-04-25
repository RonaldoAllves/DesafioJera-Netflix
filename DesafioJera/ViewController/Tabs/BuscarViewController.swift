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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //Mostra a barra de navegação
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var objetoJson : [String:Any]!
        
        if let palavraDigitada = searchBar.text{
            
            let palavraURI = palavraDigitada.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) //corrigir para URI
            
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
                                            
                                        } catch  {
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
        
        celula.textoNomeFilme.text = obterNomeFilme(filme: filme)
        
        if let imagem = obterImagemFilme(filme: filme){
            celula.imagemFotoFilme.image = imagem
        }
        
        return celula
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetalhesFilme"{
            
            if let indexPath = tableViewProcurarFilmes.indexPathForSelectedRow{
                
                let indice = indexPath.row
                
                let filme = resultados[indice] as! [String:Any]
                
                
                print("\n\n")
                //print(filme)
                //print("\n\n")
                
                let viewControllerDestinoDetalhesFilme = segue.destination as! DetalhesFilmeViewController

                viewControllerDestinoDetalhesFilme.nome = obterNomeFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.sinopse = obterSinopseFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.imagem = obterImagemFilme(filme: filme)
            }
            
        }
    }
    
    /*###################################################*/
    /*#################  Funcoes da API #################*/
    /*###################################################*/
    
    
    func resultadosBuscaFilmes(objetoJson : [String:Any]) -> Array<Any>{
        
        if let resultados = objetoJson["results"] as? Array<Any>{
            return resultados
        }
        return []
    }
    
    func obterNomeFilme(filme: [String:Any]) -> String?{
        
        if let nomeFilme = filme["original_title"]{
            if let nome = nomeFilme as? String{
                return nome
            }
        }
        return nil
        
    }
    
    func obterSinopseFilme(filme: [String:Any]) -> String?{
        
        if let sinopse = filme["overview"]{
            if let sinopseString = sinopse as? String{
                return sinopseString
            }
        }
        return nil
        
    }
    
    func obterImagemFilme(filme: [String:Any]) -> UIImage?{
        
        let url_base = "https://image.tmdb.org/t/p/w500"
        var nomeImagem : String!
        var image: UIImage? = nil
        
        if let nome = filme["poster_path"] as? String{
            nomeImagem = nome
        }else{
            if let nome2 = filme["backdrop_path"] as? String{
                nomeImagem = nome2
            }
        }
    
        if nomeImagem != nil{
            let url_s = url_base + nomeImagem
            
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
