//
//  SugeridosViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 25/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class SugeridosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let funcoes_firebase = Funcoes_Firebase()
    let funcoes_API = FuncoesAPI_Filmes()
    
    var auth: Auth!
    var storage: Storage!
    var firestore: Firestore!
    
    var resultadosBuscaFilmes : Array<Any>!
    var totalFilmes : Int!

    @IBOutlet weak var tableViewSugeridos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth() //objeto que permite realizar a autenticação do usuário utilizando o Firebase
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore
        
        self.tableViewSugeridos.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let usuariosRef = self.firestore.collection("usuarios").document(PerfisViewController.GlobalVariable.idAtual)
        let perfisRef = usuariosRef.collection("Perfis")
        let perfil = perfisRef.document("Perfil \(String(PerfisViewController.GlobalVariable.perfilAtul))")
        
        perfil.getDocument { (snapshotPerfil, erro) in
            if let dadosPerfil = snapshotPerfil?.data(){
                
                let generosSalvos = dadosPerfil["GenerosDosFilmes"] as! [String:Int]
                print(generosSalvos)
                
                
                var generoPrincipal : Int = 0

                if let maximo = generosSalvos.max(by: { a, b in a.value < b.value }){
                    generoPrincipal = Int(maximo.key)!
                }
                
                
                if let objetoJson = self.funcoes_API.buscarFilmesPeloGenero(genero: generoPrincipal){
                    self.resultadosBuscaFilmes = self.funcoes_API.resultadosBuscaFilmes(objetoJson: objetoJson)
                    self.totalFilmes = self.resultadosBuscaFilmes.count
                    
                    self.tableViewSugeridos.reloadData()
                }
            
            }
        }
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalFilmes == nil{
            totalFilmes = 0
        }
        return totalFilmes
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaSugeridos", for: indexPath) as! SugeridosTableViewCell
        let indice = indexPath.row
        
        let filme = resultadosBuscaFilmes[indice] as! [String:Any]
        
        celula.nomeFilmeSugerido.text = self.funcoes_API.obterNomeFilme(filme: filme)
        
        if let imagem = self.funcoes_API.obterImagemFilme(filme: filme){
            celula.imagemFilmeSugerido.image = imagem
        }
        
        return celula
        
    }

}
