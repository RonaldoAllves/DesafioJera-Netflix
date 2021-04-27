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
    
    let alerta = Alertas()
    
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
                        if let er = erro{
                            let alertas = self.alerta.alertas(titulo: "Erro ao logar usuario", erro: er.localizedDescription)
                            self.present(alertas, animated: true, completion: nil)
                        }
                        
                    }
                }
                
            }else{
                let alertas = self.alerta.alertas(titulo: "Erro de senha", erro: "Senha digitada de forma incorreta")
                self.present(alertas, animated: true, completion: nil)
            }
        }else{
            let alertas = self.alerta.alertas(titulo: "Erro de email", erro: "Email digitado de forma incorreta")
            self.present(alertas, animated: true, completion: nil)
        }
 
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, erro) in
            
            if let erro = erro {
                
                let alertas = self.alerta.alertas(titulo: "Erro ao fazer login com Facebook", erro: erro.localizedDescription)
                self.present(alertas, animated: true, completion: nil)
                
            }else{
                let acessoToken = AccessToken.current
                
                let credencial = FacebookAuthProvider.credential(withAccessToken: acessoToken!.tokenString)
                
                Auth.auth().signIn(with: credencial) { (usuario, erro) in
                    
                    if let erro = erro{
                        //Alerta de erro ao entrar com o Facebook
                        let alertas = self.alerta.alertas(titulo: "Erro ao logar com Facebook", erro: erro.localizedDescription)
                        self.present(alertas, animated: true, completion: nil)
                    }else{
                        
                        if let dadosUsuario = usuario?.user{
                            
                            if let nome = dadosUsuario.displayName{
                            
                                if let email = dadosUsuario.email{
                                    
                                    if let fotoPerfil = dadosUsuario.photoURL?.absoluteString{
                                    
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
                                        for i in 1..<5{
                                            let numeroPerfil = "Perfil \(String(i))"
                                            
                                            
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
            }
            
            
            
        }//
        
    }
    
    

}



