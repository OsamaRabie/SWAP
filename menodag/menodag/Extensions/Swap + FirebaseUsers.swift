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
    /// Reference to the app users database
    static let userDatabaseReference: DatabaseReference = Database.database(url: "https://menodag-b32f3-4303d.firebaseio.com/").reference()
    
    /// Get a user if any with the phone or email provided
    static func fetchUser(by phone:String = "", or email:String = "") {
        userDatabaseReference.child("users").queryOrdered(byChild: "createdAt").queryEqual(toValue : "Today").queryLimited(toFirst: 1).getData { error, snapshot in
            if let error = error {
                print("ERROR \(error)")
            }else{
                guard let snapshot = snapshot,
                let user = snapshot.value as? [String:Any] else {
                    print("No snapshot")
                    return
                }
                print(user)
            }
        }
    }
}
