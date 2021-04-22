//
//  LoginViewController.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 22/04/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Utilizado para esconder a barra de navegacao.
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) //Esconde a barra de navegação
    }

}
