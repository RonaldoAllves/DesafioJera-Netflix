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
            
            let idUsuarioAtual = PerfisViewController.GlobalVariable.idAtual as! String
            
            let perfil = "Perfil \(String(describing: perfilAtual))"
            self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData([
                                                                                                                                    "FilmesParaAssistir":FieldValue.arrayUnion([self.idFilme])])
            
            for genero in generos{
                let campo = "GenerosDosFilmes." + String(genero)
                self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData([campo : FieldValue.increment(Int64(1))])
            }
            
            //criar aletar infomando que o filme foi adicionado
            
        }
        
    }
    
    @IBAction func jaAssistido(_ sender: Any) {
        
        if let perfilAtual = PerfisViewController.GlobalVariable.perfilAtul{
            
            let idUsuarioAtual = PerfisViewController.GlobalVariable.idAtual as! String
            
            let perfil = "Perfil \(String(describing: perfilAtual))"
            
            self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData(["FilmesAssistidos":FieldValue.arrayUnion([idFilme])])

            
            for genero in generos{
                let campo = "GenerosDosFilmes." + String(genero)
                self.firestore.collection("usuarios").document(idUsuarioAtual).collection("Perfis").document(perfil).updateData([campo : FieldValue.increment(Int64(1))])
            }
            //Criar alerta informando que o filme foi adicionado
            
        }
        
    }
    
}
