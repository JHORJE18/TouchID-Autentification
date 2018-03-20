//
//  ViewController.swift
//  TouchID Autentification
//
//  Created by Aeol Service on 15/3/18.
//  Copyright © 2018 JHORJE18. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    // Variables Especificas
    @IBOutlet weak var labelPrincipal: UILabel!
    @IBOutlet weak var labelTiempo: UILabel!
    @IBOutlet weak var selector: UISlider!
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

    // Metodos Botones
    @IBAction func btnAcceder(_ sender: UIButton) {
        if (textUsuario.text?.elementsEqual(""))! {
            labelPrincipal.textColor = UIColor.black
            labelPrincipal.text = "Usuario " + textUsuario.text! + " no existe"
        } else {
            if (textPassword.text?.elementsEqual(""))!{
                labelPrincipal.textColor = UIColor.red
                labelPrincipal.text = "Contraseña incorrecta!"
            } else {
                labelPrincipal.textColor = UIColor.green
                labelPrincipal.text = "Hola " + textUsuario.text!
            }
        }
    }
    
    @IBAction func selectorChanged(_ sender: UISlider) {
        labelTiempo.text = String( Int(selector.value * 100))
    }
    
    // Enviar nueca notificación
    @IBAction func btnNuevaNotificacion(_ sender: UIButton) {
        let alertaNotificacion = UIAlertController(title: "Notificación solicitada", message: "Se ha solicitado una notificación para dentro de " + String(Int(selector.value * 100)) + " segundos", preferredStyle: .alert)
        alertaNotificacion.addAction(UIAlertAction(title: "Aceptar", style: .default))
        alertaNotificacion.addAction(UIAlertAction(title: "Cancelar", style: .destructive))
        
        self.present(alertaNotificacion, animated: true)
    }
    
    @IBAction func btnAccederTouchID(_ sender: Any) {
        self.autentificarUsuario()
    }
    
    // Metodo Autentificar mediante TouchID
    func autentificarUsuario() {
        // Obtiene contexto actual y prepara gestor de errores
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Iniciar Sesión en AEOL Cloud!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        // Identificación correcta!
                        print("Correcto Login")
                        self.labelPrincipal.text = "Login Correcto"
                        self.labelPrincipal.textColor = UIColor.green
                    } else {
                        // Identificación incorrecta
                        let ac = UIAlertController(title: "Error!", message: "Se ha producido un error durante la validación de tu Huella, por favor vuelve a intentarlo más tarde.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        self.labelPrincipal.text = "Se ha producido un error"
                        self.labelPrincipal.textColor = UIColor.red
                    }
                }
            }
        } else {
            // Dispositivo no compatible o no preparado para usar TouchID
            //  En el caso de iPhone X usara FaceID en vez de TouchID
            let ac = UIAlertController(title: "Touch ID no dispondible", message: "Tu dispositivo no soporta TouchID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}
