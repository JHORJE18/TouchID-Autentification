//
//  ViewController.swift
//  TouchID Autentification
//
//  Created by Aeol Service on 15/3/18.
//  Copyright © 2018 JHORJE18. All rights reserved.
//

import UIKit
import LocalAuthentication
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    // Variables Especificas
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var labelPrincipal: UILabel!
    @IBOutlet weak var labelTiempo: UILabel!
    @IBOutlet weak var selector: UISlider!
    @IBOutlet weak var textUsuario: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Solicita permiso notificaciones
        let options: UNAuthorizationOptions = [.alert, .sound];
        
        //Check si se ha concedido permiso por primera vez
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        //Checkea si se tiene permiso (No es la primera solicitud)
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
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
        
        // Creamos notificación
        let notificacionBurbuja = UNMutableNotificationContent()
        notificacionBurbuja.title = "Se ha acabado!"
        notificacionBurbuja.body = "Ya era hora de terminar de esta pesadilla"
        
        if let path = Bundle.main.path(forResource: "steve_jobs", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "zelda", url: url, options: nil)
                notificacionBurbuja.attachments = [attachment]
            } catch {
                print("La imagen no se ha cargado")
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Int(selector.value * 100)), repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificacionBurbuja, trigger: trigger)
        
        print("Cargando notificacion para dentro de " , (trigger.timeInterval))
        // Elimina todas las notificaciones que quedaron pendientes
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // Añadir notificación al Centro de Control (De Notificaciones)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    @IBAction func btnAccederTouchID(_ sender: Any) {
        if (!textUsuario.isEqual("")){
            self.autentificarUsuario()
        } else {
            let alertUser = UIAlertController(title: "Error!", message: "No has introducido ningun Usuario con el que Iniciar Sesión.", preferredStyle: .alert)
            alertUser.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertUser, animated: true)
        }
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
    
    // Metodo que confirma que debe mostrar notificaciones estando dentro de la app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert])
    }

    
}
