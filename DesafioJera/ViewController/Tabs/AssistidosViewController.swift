//
//  AssistidosViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 25/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class AssistidosViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    let funcoes_firebase = Funcoes_Firebase()
    let funcoes_API = FuncoesAPI_Filmes()
    
    var auth: Auth!
    var storage: Storage!
    var firestore: Firestore!
    
    var totalFilmes:Int!
    var filmesAssistidosID_firebase : Array<Int>!
    
    @IBOutlet weak var tableViewAssistidos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        auth = Auth.auth() //objeto que permite realizar a autenticação do usuário utilizando o Firebase
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore
        
        self.tableViewAssistidos.separatorStyle = .none
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let usuariosRef = self.firestore.collection("usuarios").document(PerfisViewController.GlobalVariable.idAtual)
        let perfisRef = usuariosRef.collection("Perfis")
        let perfil = perfisRef.document("Perfil \(String(PerfisViewController.GlobalVariable.perfilAtul))")
        
        perfil.getDocument { (snapshotPerfil, erro) in
            if let dadosPerfil = snapshotPerfil?.data(){
                
                if let listaFilmesAssistidos = dadosPerfil["FilmesAssistidos"] as? Array<Int>{
                
                    self.filmesAssistidosID_firebase = listaFilmesAssistidos
                    self.totalFilmes = self.filmesAssistidosID_firebase.count
                    
                    self.tableViewAssistidos.reloadData()
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
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaAssistidos", for: indexPath) as! AssistidosTableViewCell
        let indice = indexPath.row
        
        let filme = funcoes_API.buscarFilmePeloID(id: filmesAssistidosID_firebase[indice])
        
        
        let imagem = funcoes_API.obterImagemFilme(filme: filme!)
        let nome = funcoes_API.obterNomeFilme(filme: filme!)
    
        
        celula.nomeFilmeAssistido.text = nome
        celula.imagemFilmeAssistido.image = imagem
        
        return celula
        
    }
    


}
