
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // MARK: - TODO: - iCloud Keychain
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                    self.errorLabel.text = err.localizedDescription
                } else if let result = authResult {
                    print("Authentication successfully with result: \(result)")
                }
                Timer.scheduledTimer(withTimeInterval: 4.0 , repeats: false) { (timer) in
                    self.errorLabel.text = ""
                }
            }
        }
    }
    
}
