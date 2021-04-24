//
//  PerfisViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class PerfisViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var auth: Auth!
    var storage: Storage!
    var firestore: Firestore!
    var imagePicher = UIImagePickerController()
    var imagemRecuperada: UIImage!
    var tipoImagemModificada: Int!
    var idUsuario:String!
    
    @IBOutlet weak var campoNomeLogin: UILabel!
    @IBOutlet weak var campoEmailLogin: UILabel!
    @IBOutlet weak var imagemBotaoLogin: UIButton!
    
    
    
    @IBOutlet weak var nomePerfil1: UITextView!
    @IBOutlet weak var nomePerfil2: UITextView!
    @IBOutlet weak var nomePerfil3: UITextView!
    @IBOutlet weak var nomePerfil4: UITextView!
    

    
    
    @IBOutlet weak var imagemBotaoPerfil1: UIButton!
    @IBOutlet weak var imagemBotaoPerfil2: UIButton!
    @IBOutlet weak var imagemBotaoPerfil3: UIButton!
    @IBOutlet weak var imagemBotaoPerfil4: UIButton!
    
    
    var arrayImagemBotaoPerfis: [UIButton]!
    var arrayNomePerfil: [UITextView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        storage = Storage.storage()
        firestore = Firestore.firestore()
        
        imagePicher.delegate = self
        
        arrayImagemBotaoPerfis = [imagemBotaoPerfil1,imagemBotaoPerfil2,imagemBotaoPerfil3,imagemBotaoPerfil4]
        arrayNomePerfil = [nomePerfil1,nomePerfil2,nomePerfil3,nomePerfil4]
        
        
        if let usuarioLogado = auth.currentUser{
            self.idUsuario = usuarioLogado.uid
            
            recuperarDadosUsuarioPerfis()
        }
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //Mostra a barra de navegação
    }
    
    func recuperarDadosUsuarioPerfis(){
        let usuariosRef = self.firestore.collection("usuarios").document(self.idUsuario)
        usuariosRef.getDocument { (snapshot, erro) in
            
            if let dados = snapshot?.data(){
                self.campoNomeLogin.text = dados["nome"] as! String
                self.campoEmailLogin.text = dados["email"] as! String
                
                if let urlImagemLogin = dados["urlImagemLogin"] as? String{
                    self.imagemBotaoLogin.sd_setImage(with: URL(string: urlImagemLogin), for: .normal, completed: nil)
                }
                
            }else{
                print("Erro ao pegar os dados do usuario 50")
            }
            
        }
        
        let perfisRef = usuariosRef.collection("Perfis")
        for var i in 1..<5{
            var perfil_i = perfisRef.document("Perfil \(String(i))")
            perfil_i.getDocument { (snapshotPerfil, erro) in
                
                if let dadosPerfil = snapshotPerfil?.data(){
                    
                    self.arrayNomePerfil[i-1].text = dadosPerfil["dono"] as! String
                    
                    if let urlImagemPerfil = dadosPerfil["urlImagemPerfil"] as? String{
                        self.arrayImagemBotaoPerfis[i-1].sd_setImage(with: URL(string: urlImagemPerfil), for: .normal, completed: nil)
                    }
                    
                    
                }else{
                    print("erro ao pegar perfil \(i)")
                }
                
            }
        }
        
        
    }
    
    
    @IBAction func escolherImagemPerfil1(_ sender: Any) {
        
        self.tipoImagemModificada = 1
        
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
        
    }
    
    @IBAction func escolherImagemPerfil2(_ sender: Any) {
        
        self.tipoImagemModificada = 2
        
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
        
    }
    
    @IBAction func escolherImagemPerfil3(_ sender: Any) {
        
        self.tipoImagemModificada = 3
        
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
        
    }
    @IBAction func escolherImagemPerfil4(_ sender: Any) {
        
        self.tipoImagemModificada = 4
        
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
        
    }
    
    
    @IBAction func entrarPerfil1(_ sender: Any) {
        
        
    }
    
    //Funcao para deslogar o usuario
    @IBAction func deslogar(_ sender: Any) {
        
        do {
            try auth.signOut() //Desloga o usuario
        } catch  {
            print("Erro ao deslogar usuário!")
        }
        
    }
    
    
    @IBAction func escolherImagemLogin(_ sender: Any) {
        
        self.tipoImagemModificada = 0
    
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
    
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //fecha a selecao de imagem ao clicar em alguma foto
        imagePicher.dismiss(animated: true) {
            self.alterarImagens()
        }
        
    }
    
    func alterarImagens(){
        
        let imagens = storage.reference().child("imagens")
        
        if let imagemUpload = self.imagemRecuperada.jpegData(compressionQuality: 0.3){
                
                switch tipoImagemModificada {
                    case 0:
                                        
                                        let imagemLoginRef = imagens.child(idUsuario).child("login.jpg")
                                        imagemLoginRef.putData(imagemUpload, metadata: nil) { (metaData, erro) in
                                                
                                                if erro != nil{
                                                    //Criar um alerta para erro ao fazer upload da imagem do usuario
                                                }else{
                                                    imagemLoginRef.downloadURL { (url, erro) in
                                                        if let urlImagem = url?.absoluteString{
                                                            self.firestore.collection("usuarios").document(self.idUsuario).updateData([
                                                                                                                                    "urlImagemLogin":urlImagem])
                                                        }
                                                    }
                                                }
                                                
                                            }
                                    
                                
                                
                                        self.imagemBotaoLogin.setImage(imagemRecuperada, for: .normal)
                        
                        
                        
                    default:
                        
                        if let tipo = tipoImagemModificada{
                            let imagemPerfisRef = imagens.child(idUsuario).child("Perfil \(String(describing: tipo))").child("perfil\(String(describing: tipo)).jpg")
                            imagemPerfisRef.putData(imagemUpload, metadata: nil) { (metaData, erro) in
                                    
                                    if erro != nil{
                                        //Criar um alerta para erro ao fazer upload da imagem do usuario
                                    }else{
                                        imagemPerfisRef.downloadURL { (url, erro) in
                                            if let urlImagem = url?.absoluteString{
                                                let perfil = "Perfil \(tipo)"
                                                self.firestore.collection("usuarios").document(self.idUsuario).collection("Perfis").document(perfil).updateData([
                                                                                                                        "urlImagemPerfil":urlImagem])
                                            }
                                        }
                                    }
                                    
                                }
                        
                            self.arrayImagemBotaoPerfis[tipo-1].setImage(imagemRecuperada, for: .normal)
                        }
                        
                     
                }
                
            
            
            
            
        }
        
    }

}
