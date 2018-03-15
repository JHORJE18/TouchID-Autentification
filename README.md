# TouchID Autentification
Proyecto para probar la integración del TouchID para Iniciar Sesión (Realmente solo muestra un mensaje jajaj)

## Metodo clave
```swift
    func autentificarUsuario() {
        //Obtiene contexto actual y prepara gestor de errores
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Iniciar Sesión!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        //Identificación correcta!
                        print("Correcto Login")
                    } else {
                        //Identificación incorrecta
                        let ac = UIAlertController(title: "Error!", message: "Se ha producido un error durante la validación de tu Huella, por favor vuelve a intentarlo más tarde.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            //Dispositivo no compatible o no preparado para usar TouchID
            // En el caso de iPhone X usara FaceID en vez de TouchID
            let ac = UIAlertController(title: "Touch ID no dispondible", message: "Tu dispositivo no soporta TouchID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

```
