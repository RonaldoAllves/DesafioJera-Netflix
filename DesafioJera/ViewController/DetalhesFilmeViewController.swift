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
    }
    
    @IBAction func jaAssistido(_ sender: Any) {
        
        
        
    }
    
}
