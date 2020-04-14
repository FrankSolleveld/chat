
import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    
    let locationManager = LocationManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserListener()
        titleLabel.text = ""
        var characterIndex = 0.0
        let titleText = K.appTitle
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("[WelcomeViewController] UNUserNotificationCenter: User granted permission.")
            } else if let err = error {
                print("[WelcomeViewController] UNUserNotificationCenter: An error occured \(err)")
            }
        }
    }
    
    func addUserListener() {
        let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
               return
            } else {
                self.performSegue(withIdentifier: K.loginListenerSegue, sender: auth)
            }
      }
    
}

}

