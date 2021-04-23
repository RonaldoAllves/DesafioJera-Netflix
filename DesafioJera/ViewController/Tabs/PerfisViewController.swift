//
//  PerfisViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit
import FirebaseAuth

class PerfisViewController: UIViewController {
    
    var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()

    }
    
    //Funcao para deslogar o usuario
    @IBAction func deslogar(_ sender: Any) {
        
        do {
            try auth.signOut() //Desloga o usuario
        } catch  {
            print("Erro ao deslogar usuário!")
        }
        
    }
    

}
