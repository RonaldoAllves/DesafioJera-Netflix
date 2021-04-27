//
//  LoginViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let FuncaoCadastroFacebook = Funcao_Cadastro()
    
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var loginFacebookBotaoTexto: UIButton!
    
    var auth: Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore

        //Verifica se o usuario esta logado
        auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
                self.loginFacebookBotaoTexto.setTitle("Logado com Facebook", for: .normal)
                //Se exister o usuario é porque está logado, entao vai para a tela principal
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }else{
                self.loginFacebookBotaoTexto.setTitle("Entrar com Facebook", for: .normal)
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
    
    @IBAction func loginFacebook(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, erro) in
            
            let acessoToken = AccessToken.current
            
            let credencial = FacebookAuthProvider.credential(withAccessToken: acessoToken!.tokenString)
            
            Auth.auth().signIn(with: credencial) { (usuario, erro) in
                
                if let erro = erro{
                    print("\n\nLogin Erro: \(erro.localizedDescription)")
                }else{
                    
                    if let dadosUsuario = usuario?.user{
                        
                        let nome = dadosUsuario.displayName
                        let email = dadosUsuario.email
                        let fotoPerfil = dadosUsuario.photoURL?.absoluteString
                        
                        print("\n\n\(fotoPerfil)")
                        
                        let idUsuario = dadosUsuario.uid
                        
                            
                            //Cadastra os dados do usuario pelo uid do usuario
                        self.firestore.collection("usuarios").document(idUsuario)
                            .setData([
                                "nome" : nome,
                                "email" : email,
                                "dataDeNascimento" : "",
                                "urlImagemLogin" : fotoPerfil
                            ])
                        
                        //Cria o primeiro perfil do usuario, com nome de Principal
                        for var i in 1..<5{
                            var numeroPerfil = "Perfil \(String(i))"
                            
                            
                            self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["FilmesAssistidos" : Array<Any>()], merge: true)
                            
                            self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["GenerosDosFilmes" : [Int:Int]()], merge: true)
                            
                            self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["FilmesParaAssistir" : Array<Any>()], merge: true)
                    
                            self.firestore.collection("usuarios").document(idUsuario).collection("Perfis").document(numeroPerfil).setData(["dono" : "sem dono"], merge: true)

                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    

}



