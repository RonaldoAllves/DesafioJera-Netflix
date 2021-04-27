//
//  Funcoes_Firebase.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 25/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class Funcoes_Firebase {
    
    var auth: Auth!
    var storage: Storage!
    var firestore: Firestore!
    
    func inicializarObjetoAutenticacao(){
        
        auth = Auth.auth() //objeto que permite realizar a autenticação do usuário utilizando o Firebase
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore
        
    }
    
}
