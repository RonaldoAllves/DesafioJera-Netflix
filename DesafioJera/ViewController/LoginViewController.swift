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
    var auth: Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Firestore.firestore() //objeto que permite salvar dados no firestore

        //Verifica se o usuario esta logado
        auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
                //Se exister o usuario é porque está logado, entao vai para a tela principal
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }else{
                
            }
        }
        
        if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil,
                                                     httpMethod: .get)

            request.start { (connection, result, erro) in
                print("\nresultado 1:")
                print("\(result)")
                
                var dicionario : [String: Any]!
                
                dicionario = result as! [String: Any]
                
                print("\nresultado 2:")
                print(dicionario["id"])
                
                
                
                
            }

        }else{
            // colar botao aqui
        }
        //Botao do facebook
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
    }
    /*
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //let token = result?.token?.tokenString
        
        
        print("\n\nteste 1\n")
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        print("\n\nteste 2\n")
        
        print(credential)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
          
              return
          }else{
            
            let usuario = Auth.auth().currentUser
            
            if let user = usuario{
                
                print("\n\nteste fantastico")
                print(user.email)
                
            }
            
          }
        }
        
        
        
        
    }
 */
    /*
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        /* Usar quando tiver cadastrado usuario do Facebook */
        /*
        do {
            try auth.signOut() //Desloga o usuario
        } catch  {
            print("Erro ao deslogar usuário!")
        }
       */
    }
 */
    
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
            
            
            //print(result)
            
            let acessoToken = AccessToken.current
            
            let credencial = FacebookAuthProvider.credential(withAccessToken: acessoToken!.tokenString)
            
            Auth.auth().signIn(with: credencial) { (usuario, erro) in
                
                if let erro = erro{
                    print("\n\nLogin Erro: \(erro.localizedDescription)")
                }else{
                    
                    if let dadosUsuario = usuario?.user{
                        
                        let nome = dadosUsuario.displayName
                        let email = dadosUsuario.email
                    
                        let idUsuario = dadosUsuario.uid
                            
                            //Cadastra os dados do usuario pelo uid do usuario
                        self.firestore.collection("usuarios").document(idUsuario)
                            .setData([
                                "nome" : nome,
                                "email" : email,
                                "dataDeNascimento" : ""
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



