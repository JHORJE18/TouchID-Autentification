//
//  ViewController.swift
//  TouchID Autentification
//
//  Created by Aeol Service on 15/3/18.
//  Copyright © 2018 JHORJE18. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // # Variables Especificas
    @IBOutlet weak var labelPrincipal: UILabel!
    @IBOutlet weak var textUsuario: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // # Metodos Botones
    @IBAction func btnAcceder(_ sender: UIButton) {
        if (textUsuario.text?.elementsEqual("JORGE"))! {
            if (textPassword.text?.elementsEqual("0000"))!{
                labelPrincipal.textColor = UIColor.green
                labelPrincipal.text = "Hola JORGE"
            } else {
                labelPrincipal.textColor = UIColor.red
                labelPrincipal.text = "Contraseña incorrecta!"
            }
        } else {
            labelPrincipal.textColor = UIColor.black
            labelPrincipal.text = "Usuario " + textUsuario.text! + " no existe"
        }
    }
    
    @IBAction func btnAccederTouchID(_ sender: Any) {
        
    }
    
}

