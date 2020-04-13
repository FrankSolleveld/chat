//
//  K.swift
//  Flash Chat iOS13
//
//  Created by Frank Solleveld on 11/04/2020.
//

struct K {
    // MARK: - App Title
    static let appTitle = "GeoChat"
    
    // MARK: - Segues
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let loginListenerSegue = "welcomeToChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCel"

    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
    struct GeoFence {
        static let defaultsLatKey = "geoLatitude"
        static let defaultsLongKey = "geoLongitude"
        
        static let isInRegionKey = "isInRegion"
        
        static let geoAlertEnteredTitle = "You Entered the Region."
        static let geoAlertEnteredBody = "You can now use GeoChat."
        
        static let geoAlertExitTitle = "You Left the Region."
        static let geoAlertExitBody = "You can't use GeoChat until you have returned."
    }
}

/*
 
 If you’re reading this, you are in your setted region and the connection to the database was succesful. 
 This app is made by Frank Solleveld, and is intended for educational purposes only.
 
 */
