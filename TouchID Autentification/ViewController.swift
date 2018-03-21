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
        // Inicio de la aplicación
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
        
        // Declara este archivo para recibir las reacciones de las notificaciones
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Metodos Botones
    @IBAction func btnAcceder(_ sender: UIButton) {
        // Cualquier usuario es valido (Excepto el vacio)
        if (textUsuario.text?.elementsEqual(""))! {
            labelPrincipal.textColor = UIColor.black
            labelPrincipal.text = "Usuario " + textUsuario.text! + " no existe"
        } else {
            //
            if (textPassword.text?.elementsEqual(""))!{
                labelPrincipal.textColor = UIColor.red
                labelPrincipal.text = "Contraseña incorrecta!"
            } else {
                labelPrincipal.textColor = UIColor.green
                labelPrincipal.text = "Hola " + textUsuario.text!
            }
        }
    }
    
    // Control de botones de Notificación
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Gestiona la acción que ha seleccionado en la notificcacion
        switch response.actionIdentifier {
        case "rememberAction":
            print("Vale, le avisare más tarde")
            solicitarNotificacion()
            break
        case "deleteAction":
            print("Vale, elimino la notificación")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["cocoacasts_local_notification"])
            break
        default:
            print("No se de donde ha venido")
            break
        }
    }
    
    // Refrescar contador del selector
    @IBAction func selectorChanged(_ sender: UISlider) {
        labelTiempo.text = String( Int(selector.value * 100))
    }
    
    // Solicita, crea y envia una notificación
    func solicitarNotificacion(){
        let notificacionBurbuja = UNMutableNotificationContent()
        notificacionBurbuja.title = "Se ha acabado!"
        notificacionBurbuja.body = "Ya era hora de terminar esta pesadilla, " + textUsuario.text!
        
        if let path = Bundle.main.path(forResource: "steve_jobs", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "zelda", url: url, options: nil)
                notificacionBurbuja.attachments = [attachment]
            } catch {
                print("La imagen no se ha cargado")
            }
        }
        
        // Añadimos acciones de la notificación
            // Al reaccionar sobre una acción se redirigie al metodo ' userNotificationCenter ' , el cual se encarga de gesttionar de que evento ha venido y definir que debe realizar o que metodos debe ejecutar
        
        //1. Creamos la acción de Recordar
        let rememberAction = UNNotificationAction(identifier: "rememberAction", title: "Recordar más tarde", options: [])
        
        //2. Creamos la acción de Eliminar
        let deleteAction = UNNotificationAction(identifier: "deleteAction", title: "Eliminar Notificación", options: [])
        
        //3. Creamos la categoría que agrupa las acciones
        let category = UNNotificationCategory(identifier: "cocoacasts_local_notification_category", actions: [rememberAction, deleteAction], intentIdentifiers: [], options: [])
        
        // Asigna la cateogira de la notificación actual
        notificacionBurbuja.categoryIdentifier = "cocoacasts_local_notification_category"
        
        //4. Añadimos la categoría al Centro de Notificaciones
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Crear disparador de la notificación
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Int(selector.value * 100)), repeats: false)
        
        // Creamos la Request con su identificador, contenido de la notificación y el disparador de la notificacion
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
    
    // Enviar nueca notificación
    @IBAction func btnNuevaNotificacion(_ sender: UIButton) {
        let alertaNotificacion = UIAlertController(title: "Notificación solicitada", message: "Se ha solicitado una notificación para dentro de " + String(Int(selector.value * 100)) + " segundos", preferredStyle: .alert)
        alertaNotificacion.addAction(UIAlertAction(title: "Aceptar", style: .default))
        alertaNotificacion.addAction(UIAlertAction(title: "Cancelar", style: .destructive))
        
        self.present(alertaNotificacion, animated: true)
        
        // Creamos notificación
        solicitarNotificacion()
    }
    
    // Boton acceder mediante TouchID
    @IBAction func btnAccederTouchID(_ sender: Any) {
        if (textUsuario.text?.isEqual(""))!{
            let alertUser = UIAlertController(title: "Error!", message: "No has introducido ningun Usuario con el que Iniciar Sesión.", preferredStyle: .alert)
            alertUser.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertUser, animated: true)
        } else {
            self.autentificarUsuario()
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
            // En el caso de iPhone X usara FaceID en vez de TouchID
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
