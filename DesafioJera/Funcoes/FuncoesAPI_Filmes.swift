//
//  FuncoesAPI_Filmes.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 25/04/21.
//

import UIKit

class FuncoesAPI_Filmes {
    
    let key = "f4157bfa5391f523704b9b2054ea3561"
    
    func receberObjetoJsonBuscaPorPalavraChaveFilme(palavraDigitada:String) -> [String:Any]?{
        
        var objetoJson : [String:Any]!

        let url_base = "https://api.themoviedb.org/3/search/movie?"
        
        let atributo_busca = "query="
        //let atributo_pagina = "&page="
        let atributo_key = "&api_key="
        
        var url_s : String!
        
        let palavraURI = palavraDigitada.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) //corrigir para URI
        
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
    
        return objetoJson
    }
    
    func buscarFilmesPeloGenero(genero : Int) -> [String:Any]?{
        var filme:[String:Any]!
        
        let url_base = "https://api.themoviedb.org/3/discover/movie?"
        
        let genero_s = "with_genres=" + String(genero)
        
        let atributoPopularidade = "&sort_by=popularity.desc"
        
        let url_s = url_base + genero_s + atributoPopularidade + "&api_key=" + key
        
        if let url = URL(string: url_s){
            
            let data = NSData(contentsOf: url)
            
            if let dadosRetorno = data{
                do {
                    if let objeto = try JSONSerialization.jsonObject(with: dadosRetorno as Data, options: []) as? [String: Any]{
                        filme = objeto
                    }
                    
                } catch  {
                    print("\n\n\tErro na conversao para Json\n\n")
                }

            }

        }else{
            print("Erro estranho")
        }
        
        return filme
    }
    
    func buscarFilmePeloID(id:Int) -> [String:Any]?{
        var filme:[String:Any]!
        
        let url_base = "https://api.themoviedb.org/3/movie/"
        
        let id_s = String(id)
        
        let url_s = url_base + id_s + "?api_key=" + key
        
        //print(url_s)
        
        if let url = URL(string: url_s){
            
            let data = NSData(contentsOf: url)
            
            if let dadosRetorno = data{
                do {
                    if let objeto = try JSONSerialization.jsonObject(with: dadosRetorno as Data, options: []) as? [String: Any]{
                        filme = objeto
                    }
                    
                } catch  {
                    print("\n\n\tErro na conversao para Json\n\n")
                }

            }

        }else{
            print("Erro estranho")
        }
        
        return filme
    }
    
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
    
    func obterGeneroFilme(filme: [String:Any]) -> Array<Int>?{
        
        if let genero = filme["genre_ids"]{
            if let generoArray = genero as? Array<Int>{
                return generoArray
            }
        }
        return nil
        
    }
    
    func obterGeneroFilmeDoId(filme: [String:Any]) -> Array<Int>?{
        
        if let generos = filme["genres"]{
            
            print(generos)
            
            if let generoArrayAny = generos as? Array<Any>{
                
                var generoArrayInt : Array<Int> = []
                
                for i in 0..<generoArrayAny.count{
                    let g = generoArrayAny[i] as! [String:Any]
                    print("genero: \(g)")
                    if let gInt = g["id"] as? Int{
                        print(gInt)
                        generoArrayInt.append(gInt)
                    }
                    
                }
                
                return generoArrayInt
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
