//
//  CadastroViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CadastroViewController: UIViewController {

    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoDataNascimento: UITextField!
    var auth:Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth() //objeto que permite realizar a autenticação do usuário utilizando o Firebase
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore
        
    }
    
    //Utilizado para mostrar a barra de navegacao.
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //Mostra a barra de navegação
    }
    
    
    @IBAction func cadastrar(_ sender: Any) {
        
        //Validação dos campos digitados, caso tudo certo é feito o cadastro do usuário utilizando Firebase
        if let email = campoEmail.text{
            if let senha = campoSenha.text{
                if let nome = campoNome.text{
                    if let nascimento = campoDataNascimento.text{
                        
                        //Cria o usuario
                        auth.createUser(withEmail: email, password: senha) { (dadosResultado, erro) in
                            
                            //Verifica se houve erro ao cadastrar o usuario
                            if erro == nil{
                                
                                if let idUsuario = dadosResultado?.user.uid {
                                    
                                    //Cadastra os dados do usuario pelo uid do usuario
                                    self.firestore.collection("usuarios").document(idUsuario)
                                        .setData([
                                            "nome" : nome,
                                            "email" : email,
                                            "dataDeNascimento" : nascimento
                                        ])
                                    
                                    //Cria o primeiro perfil do usuario, com nome de Principal
                                    self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document("Perfil 1").setData(["dono" : nome])
                                    self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document("Perfil 2").setData(["dono" : "sem dono"])
                                    self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document("Perfil 3").setData(["dono" : "sem dono"])
                                    self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document("Perfil 4").setData(["dono" : "sem dono"])
                                    
                                }
                                
                            }else{
                                //Criar um alerta para apresentar o erro ao cadastrar usuario
                            }
                            
                        }
                        
                    }else{
                        //Criar um alerta para apresentar o erro ao digitar a data de nascimento
                    }
                }else{
                    //Criar um alerta para apresentar o erro ao digitar o nome
                }
                
            }else{
                //Criar um alerta para apresentar o erro ao digitar a senha
            }
        }else{
            //Criar um alerta para apresentar o erro ao digitar o email
        }
        
    }
    
}
