//
//  Funcao_Cadastro.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 26/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Funcao_Cadastro {
    
    func cadastroFacebook(auth: Auth, firestore: Firestore, email : String, senha: String, nome: String){
                        //Cria o usuario
                        
        auth.createUser(withEmail: email, password: senha) { (dadosResultado, erro) in
                            
            //Verifica se houve erro ao cadastrar o usuario
            if erro == nil{
                
                if let idUsuario = dadosResultado?.user.uid {
                    
                    //Cadastra os dados do usuario pelo uid do usuario
                    firestore.collection("usuarios").document(idUsuario)
                        .setData([
                            "nome" : nome,
                            "email" : email,
                            "dataDeNascimento" : ""
                        ])
                    
                    //Cria o primeiro perfil do usuario, com nome de Principal
                    for var i in 1..<5{
                        var numeroPerfil = "Perfil \(String(i))"
                        
                        
                        firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["FilmesAssistidos" : Array<Any>()], merge: true)
                        
                        firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["GenerosDosFilmes" : [Int:Int]()], merge: true)
                        
                        firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["FilmesParaAssistir" : Array<Any>()], merge: true)
                
                        firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["dono" : "sem dono"], merge: true)
                        
                    }
                    
                    
                }
                
            }else{
                //Criar um alerta para apresentar o erro ao cadastrar usuario
            }
            
        }

    }
    
}
