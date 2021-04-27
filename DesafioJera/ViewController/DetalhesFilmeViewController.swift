//
//  DetalhesFilmeViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 24/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetalhesFilmeViewController: UIViewController {
    
    let alertas = Alertas()
    
    @IBOutlet weak var imagemFilme: UIImageView!
    @IBOutlet weak var tituloFilme: UILabel!
    @IBOutlet weak var sinopseFilme: UILabel!
    
    var nome : String!
    var sinopse : String!
    var imagem : UIImage!
    var idFilme : Int!
    var generos : Array<Int>!
    
    
    var auth:Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tituloFilme.text = nome
        sinopseFilme.text = sinopse
        imagemFilme.image = imagem
        
        auth = Auth.auth() //objeto que permite realizar a autenticação do usuário utilizando o Firebase
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore
        

    }
    
    @IBAction func assistirMaisTarde(_ sender: Any) {
        
        if let perfilAtual = PerfisViewController.GlobalVariable.perfilAtul{
            
            if let idUsuarioAtual = PerfisViewController.GlobalVariable.idAtual{
            
                let perfil = "Perfil \(String(describing: perfilAtual))"
                
                if let idFilme = self.idFilme{
                
                    self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData([
                                                                                                                                        "FilmesParaAssistir":FieldValue.arrayUnion([idFilme])])
                    
                    for genero in generos{
                        let campo = "GenerosDosFilmes." + String(genero)
                        self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData([campo : FieldValue.increment(Int64(1))])
                    }
                    if let nome = self.nome{
                        let alerta = alertas.alertas(titulo: "Filme Adicionado", erro: "Adicionado o filme: \(nome)")
                        present(alerta, animated: true, completion: nil)
                    }
                    
                }
            }
            
        }
        
    }
    
    
}
