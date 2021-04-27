//
//  BuscarViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 24/04/21.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let funcoesAPI = FuncoesAPI_Filmes()
    
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
            
            objetoJson = self.funcoesAPI.receberObjetoJsonBuscaPorPalavraChaveFilme(palavraDigitada: palavraDigitada)
            
            //procurarFilme(palavras_chave: palavraDigitada)
            if objetoJson == nil{
                print("\n\nErro\n\n")
            }else{
                resultados = self.funcoesAPI.resultadosBuscaFilmes(objetoJson: objetoJson)
                totalPaginas = self.funcoesAPI.totalPaginasBusca(objetoJson: objetoJson)
                totalFilmes = self.funcoesAPI.totalFilmesBusca(objetoJson: objetoJson)
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
        
        celula.textoNomeFilme.text = self.funcoesAPI.obterNomeFilme(filme: filme)
        if let imagem = self.funcoesAPI.obterImagemFilme(filme: filme){
            celula.imagemFotoFilme.image = imagem
        }
        
        return celula
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetalhesFilme"{
            
            if let indexPath = tableViewProcurarFilmes.indexPathForSelectedRow{
                
                let indice = indexPath.row
                
                let filme = resultados[indice] as! [String:Any]
                
                let viewControllerDestinoDetalhesFilme = segue.destination as! DetalhesFilmeViewController

                viewControllerDestinoDetalhesFilme.idFilme = self.funcoesAPI.obterIDFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.nome = self.funcoesAPI.obterNomeFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.sinopse = self.funcoesAPI.obterSinopseFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.imagem = self.funcoesAPI.obterImagemFilme(filme: filme)
                viewControllerDestinoDetalhesFilme.generos = self.funcoesAPI.obterGeneroFilme(filme: filme)
            }
            
        }
    }
    

}
