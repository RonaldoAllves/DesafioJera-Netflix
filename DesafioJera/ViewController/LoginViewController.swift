//
//  LoginViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Botao do facebook
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        //
        
        auth = Auth.auth()
        
        //Verifica se o usuario esta logado
        auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
                //Se exister o usuario é porque está logado, entao vai para a tela principal
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }else{
                
            }
        }

    }
    
    //Utilizado para esconder a barra de navegacao.
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) //Esconde a barra de navegação
    }
    
    //usado para voltar para a tela de login de forma rápida
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
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
                        print("Erro ao logar usuario!") //Criar alerta
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


//##########


