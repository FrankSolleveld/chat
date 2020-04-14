
import UIKit
import FirebaseAuth
import Firebase
import MapKit
import CoreLocation

class ChatViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Variables
    var messages: [Message] = [
        Message(sender: K.appTitle, body: "You might wonder why you can't see the live messages."),
        Message(sender: K.appTitle, body: "It's because you're not in your setted region. Or you haven't set one yet."),
        Message(sender: K.appTitle, body: "Log out and tap on Geofencing to start a region. To do this, zoom in on your desired location and hold. A green circle will appear. If you already set a region, go back to your region or change it to your current location to be able to chat again.")
    ]
    
    let locationManager = LocationManager.shared
    let db = Firestore.firestore()
    let mapView = MapViewController()
    let defaults = UserDefaults.standard
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        let isUserInRegion = defaults.bool(forKey: K.GeoFence.isInRegionKey)
        if isUserInRegion == true {
            messages = []
            loadMessages()
            self.messageTextfield.isHidden = false
            self.sendButton.isHidden = false
        } else {
            self.messageTextfield.isHidden = true
            self.sendButton.isHidden = true
        }
    }
    
    // MARK: - @IBActions
    @IBAction func sendPressed(_ sender: UIButton) {
            if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                guard !messageBody.isEmptyOrWhitespace() else { return }
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("[Firestore]: Successfully saved data.")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
            }
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: false) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Functions
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let err = error {
                print("[Firestore]: There was an issue retrieving from Firestore: \(err)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCel
        cell.messageBody.text = message.body
        cell.userLabel.text = message.sender
        
        // Message from current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.userLabel.text = "Me"
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "GreenColor")
            cell.messageBody.textColor = .white
        }
        // Message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "GreenColor")
            cell.messageBody.textColor = .white
        }
        return cell
    }
}

extension String {
    func isEmptyOrWhitespace() -> Bool {

        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
