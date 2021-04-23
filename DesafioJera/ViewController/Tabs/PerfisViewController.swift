//
//  PerfisViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class PerfisViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var auth: Auth!
    var storage: Storage!
    var imagePicher = UIImagePickerController()
    var imagemRecuperada: UIImage!
    var tipoImagemModificada: Int!
    
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
    
    
    var arrayTextView: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        storage = Storage.storage()
        
        imagePicher.delegate = self
        
        arrayTextView = [imagemBotaoPerfil1,imagemBotaoPerfil2,imagemBotaoPerfil3,imagemBotaoPerfil4]

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
            
            if let usuarioLogado = auth.currentUser{
                let idUsuario = usuarioLogado.uid
                
                switch tipoImagemModificada {
                    case 0:
                                        
                                        imagens.child(idUsuario).child("login.jpg")
                                            .putData(imagemUpload, metadata: nil) { (metaData, erro) in
                                                
                                                if erro != nil{
                                                    //Criar um alerta para erro ao fazer upload da imagem do usuario
                                                }
                                                
                                            }
                                    
                                
                                
                                        self.imagemBotaoLogin.setImage(imagemRecuperada, for: .normal)
                        
                        
                        
                    default:
                        
                        if let tipo = tipoImagemModificada{
                            imagens.child(idUsuario).child("Perfil \(String(describing: tipo))").child("perfil\(String(describing: tipo)).jpg")
                                .putData(imagemUpload, metadata: nil) { (metaData, erro) in
                                    
                                    if erro != nil{
                                        //Criar um alerta para erro ao fazer upload da imagem do usuario
                                    }
                                    
                                }
                        
                            self.arrayTextView[tipo-1].setImage(imagemRecuperada, for: .normal)
                        }
                        
                     
                }
                
            }
            
            
            
        }
        
    }

}
