//
//  K.swift
//  Flash Chat iOS13
//
//  Created by Frank Solleveld on 11/04/2020.
//

struct K {
    // MARK: - App Title
    static let appTitle = "FlashChat"
    
    // MARK: - Segues
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCel"

    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
