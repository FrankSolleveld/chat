
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var characterIndex = 0.0
        let titleText = "FlashChat"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
    }
    
}



