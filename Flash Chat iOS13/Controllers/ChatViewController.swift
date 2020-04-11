
import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    // MARK: - Variables
    var messages: [Message] = [
        Message(sender: "123@@123.com", body: "Hello!"),
        Message(sender: "a@b.com", body: "Hi."),
        Message(sender: "123@123.com", body: "What's up?")
    ]
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appTitle
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - @IBActions
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "\(messages[indexPath.row].body)"
        return cell
    }
}


