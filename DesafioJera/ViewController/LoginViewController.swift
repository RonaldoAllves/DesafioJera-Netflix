//
//  LoginViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()

    }
    
    //Utilizado para esconder a barra de navegacao.
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) //Esconde a barra de navegação
    }
    
    @IBAction func logar(_ sender: Any) {
        
        //Verificar se os campos foram preenchidos
        if let email = campoEmail.text{
            if let senha = campoSenha.text{
                
                auth.signIn(withEmail: email, password: senha) { (usuario, erro) in
                    if erro == nil{
                        if let usuarioLogado = usuario{
                            print("Sucesso ao logar usuario:  \(String(describing: usuarioLogado.user.email))")
                        }
                    }else{
                        print("Erro ao logar usuario!")
                    }
                }
                
            }else{
                //Criar alerta para campo senha errado
            }
        }else{
            //Criar alerta para campo email errado
        }
        
    }
    

}
