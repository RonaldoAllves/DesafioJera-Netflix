//
//  Alertas.swift
//  DesafioJera
//
//  Created by Ronaldo Allves on 26/04/21.
//

import UIKit

class Alertas: UIViewController {
    
    func alertas(titulo:String, erro: String) -> UIAlertController{
        let alertaController = UIAlertController(title: titulo, message: erro, preferredStyle: .alert)
        let okayAcao = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertaController.addAction(okayAcao)
        return alertaController
    }
    
}
