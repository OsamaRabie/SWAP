//
//  Menodag+Keychain.swift
//  menodag
//
//  Created by Osama Rabie on 02/07/2023.
//

import Foundation
import KeychainStore

/// A class that contains the functions needed to access the keychain
class SwapKeyChain {
    //MARK: - Constants
    /// key to access the string keychain
    static fileprivate let stringKeyChainKey:String = "SwapString"
    /// key to access the card keychain
    static fileprivate let cardKeyChainKey:String = "SwapCard"
    /// key to access the firebase user key for the logged in user
    static fileprivate let loggedInUserFirebaseKey:String = "loggedInUserFirebaseKey"
    /// key to access the hostoy
    static fileprivate let historyKey:String = "historyKey"
    
    //MARK: - Variables
    /// the string keychain
    static let stringKeyChain:KeychainStringStore = .init(account: "SwapString")
    /// the card keychain
    static let cardKeyChain:KeychainStore<[Card]> = .init(account: "SwapCard")
    
    
    /// Returns back the stored firebase key for the logged in user if any
    static func firebaseKeyForLoggedInUser() -> String? {
        return try? stringKeyChain.string(forKey: loggedInUserFirebaseKey)
    }
    
    /// Stores the new provided key as the firebase for the logged in user
    static func updateFirebaseKeyForLoggedInUser(with key:String?) {
        guard let key = key else {
            try? stringKeyChain.deleteItem(forKey: loggedInUserFirebaseKey)
            return
        }
        try? stringKeyChain.set(key, forKey: loggedInUserFirebaseKey)
    }
    
    
    static func getStoredCards() -> [Card] {
        guard let data:Data = try? cardKeyChain.data(forKey: historyKey) else { return [] }
        let decoder = JSONDecoder()
        guard let decoded:[Card] = try? decoder.decode([Card].self, from: data) else { return [] }
        return decoded
    }
    
    static func store(cards:[Card]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cards) {
            try? cardKeyChain.set(data: encoded, forKey: historyKey)
        }
    }
}
