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
    
    @IBOutlet weak var campoNomeLogin: UILabel!
    @IBOutlet weak var campoEmailLogin: UILabel!
    @IBOutlet weak var imagemBotaoLogin: UIButton!
    
    
    
    @IBOutlet weak var nomePerfil1: UITextView!
    @IBAction func escolherImagemPerfil1(_ sender: Any) {
        
        
        
    }
    @IBAction func entrarPerfil1(_ sender: Any) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        storage = Storage.storage()
        
        imagePicher.delegate = self
        
        

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
        
        imagePicher.sourceType = .savedPhotosAlbum
        present(imagePicher, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let imagens = storage.reference().child("imagens")
        
        if let imagemUpload = imagemRecuperada.jpegData(compressionQuality: 0.3){
            
            if let usuarioLogado = auth.currentUser{
                let idUsuario = usuarioLogado.uid
                let nomeImagem = "\(idUsuario).jpg"
                
                imagens.child("imagemUsuario").child(nomeImagem)
                    .putData(imagemUpload, metadata: nil) { (metaData, erro) in
                        
                        if erro != nil{
                            //Criar um alerta para erro ao fazer upload da imagem do usuario
                        }
                        
                    }
            }
        }
        
        self.imagemBotaoLogin.setImage(imagemRecuperada, for: .normal)
        
        imagePicher.dismiss(animated: true, completion: nil) //fecha a selecao de imagem ao clicar em alguma foto
    }

}
