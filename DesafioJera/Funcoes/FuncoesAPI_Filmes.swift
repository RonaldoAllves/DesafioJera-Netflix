//
//  FuncoesAPI_Filmes.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 25/04/21.
//

import UIKit

class FuncoesAPI_Filmes {
    
    func resultadosBuscaFilmes(objetoJson : [String:Any]) -> Array<Any>{
        
        if let resultados = objetoJson["results"] as? Array<Any>{
            return resultados
        }
        return []
    }
    
    func obterIDFilme(filme: [String:Any]) -> Int?{
        
        if let idFilme = filme["id"]{
            if let id = idFilme as? Int{
                return id
            }
        }
        return nil
        
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
