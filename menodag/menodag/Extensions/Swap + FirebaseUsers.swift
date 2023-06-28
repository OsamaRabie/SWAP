//
//  Swap + FirebaseUsers.swift
//  menodag
//
//  Created by Osama Rabie on 10/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase

/// A class that contains the functions needed to access the user database on Firebase
class SwapFirebaseUsers {
    /// Reference to the current user card data if any
    static var currentUserCard:Card?
    
    /// Reference to the app users database
    static let userDatabaseReference: DatabaseReference = Database.database(url: "https://menodag-b32f3-4303d.firebaseio.com/").reference()
    
    /// Get a user if any with the phone
    /// - Parameter phone: The phone string you want to fetch the user with
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onNotFound: The user was not found
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchUser(phone:String, onFetched:@escaping(Card)->(), onNotFound:@escaping()->(), onError:@escaping(String)->()) {
        fetchUser(by: phone, in: "ContactData/phone", onFetched: onFetched, onNotFound:onNotFound, onError: onError)
    }
    
    /// Get a user if any with the email
    /// - Parameter email: The email string you want to fetch the user with
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onNotFound: The user was not found
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchUser(email:String, onFetched:@escaping(Card)->(), onNotFound:@escaping()->(), onError:@escaping(String)->()) {
        fetchUser(by: email, in: "ContactData/email", onFetched: onFetched, onNotFound:onNotFound, onError: onError)
    }
    
    
    /// Get a user if any with the key
    /// - Parameter key: The key string you want to fetch the user with
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onNotFound: The user was not found
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchUser(key:String, onFetched:@escaping(Card)->(), onNotFound:@escaping()->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrderedByKey().queryEqual(toValue: key).queryLimited(toFirst: 1).getData { error, snapshot in
            // Check if no error happened during the query itself
            if let _ = error {
                onError("An error happened, please try again later")
            }else{
                // Check if there is a user with the provided key
                guard let cardModel:Card = Card.createCardFrom(snapShot: snapshot) else {
                    // Tell that we didn;t get a match
                    onNotFound()
                    return
                }
                // Return the user we found with the provided key
                onFetched(cardModel)
            }
        }
    }
    
    
    /// Get a user if any with the value
    /// - Parameter by keyword: The value string you want to fetch the user with
    /// - Parameter in path: The path you want to compare the provided keyword with
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onNotFound: The user was not found
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    fileprivate static func fetchUser(by keyword:String, in path:String, onFetched:@escaping(Card)->(),onNotFound:@escaping()->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrdered(byChild: path).queryEqual(toValue : keyword).queryLimited(toFirst: 1).getData { error, snapshot in
            // Check if no error happened during the query itself
            if let _ = error {
                onError("An error happened, please try again later")
            }else{
                // Check if there is a user with the provided value
                guard let cardModel:Card = Card.createCardFrom(snapShot: snapshot) else {
                    // Tell that we didn;t get a match
                    onNotFound()
                    return
                }
                // Return the user we found with the provided value
                onFetched(cardModel)
            }
        }
    }
    
    /// Will check if the current user has valid data regarding his sections
    /// - Returns: Bool,Bool -> for Contact & Personal info sections
    static func currentUserHasValidData() -> (Bool, Bool) {
        // First make sure we have a current user card
        guard let nonNullCard:Card = currentUserCard else { return (false,false) }
        
        // Now let us return back his sections' validations
        return (nonNullCard.hasValidContactData(), nonNullCard.hasValidPersonalData())
    }
}
