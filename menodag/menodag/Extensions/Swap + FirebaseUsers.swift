//
//  Swap + FirebaseUsers.swift
//  menodag
//
//  Created by Osama Rabie on 10/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import UIKit
/// A class that contains the functions needed to access the user database on Firebase
class SwapFirebaseUsers {
    /// Reference to the current user card data if any
    static var currentUserCard:Card? {
        didSet{
            postCurrentUserCardChanged()
        }
    }
    
    /// Reference to the app users database
    static let userDatabaseReference: DatabaseReference = Database.database(url: "https://menodag-b32f3-4303d.firebaseio.com/").reference()
    
    /// Reference to the app users storage
    static let userStorageReference: StorageReference = Storage.storage(url: "gs://menodag-b32f3.appspot.com/").reference().child("images")
    
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
    
    /// Delete the data for the current user
    /// - Parameter onDeleted: The callback to call when the user is deleted
    /// - Parameter onError: The callback to call when an error occured
    static func deleteUser(onDeleted:@escaping()->(), onError:@escaping(String)->()) {
        guard let firebaseKey:String = currentUserCard?.firebaseKey else {
            onError("Couldn't be achieved now.")
            return
        }
        userDatabaseReference.child("users").child(firebaseKey).removeValue { error, ref in
            if let error = error {
                onError(error.localizedDescription)
            }else{
                SwapFirebaseUsers.currentUserCard = nil
                onDeleted()
            }
        }
    }
    
    /// Get users matching certain phone number
    /// - Parameter phone: The phone prefix you want to look for
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchMatchingUsersBy(phone:String, onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrdered(byChild: "ContactData/phone").queryStarting(atValue: phone).queryEnding(atValue: "\(phone)\\uf8ff").getData { error, snapshot in
            // Check if no error happened during the query itself
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                onFetched(cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) })
            }else{
                onFetched([])
            }
        }
    }
    
    
    /// Get users matching certain phone number
    /// - Parameter phone: The phone prefix you want to look for
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchMatchingUsersBy(company:String, onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrdered(byChild: "ProfessionalData/company").queryStarting(atValue: company).queryEnding(atValue: "\(company)\\uf8ff").getData { error, snapshot in
            // Check if no error happened during the query itself
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                onFetched(cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) })
            }else{
                onFetched([])
            }
        }
    }
    
    
    /// Get users matching certain phone number
    /// - Parameter phone: The phone prefix you want to look for
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchMatchingUsersBy(title:String, onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrdered(byChild: "ProfessionalData/title").queryStarting(atValue: title).queryEnding(atValue: "\(title)\\uf8ff").getData { error, snapshot in
            // Check if no error happened during the query itself
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                onFetched(cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) })
            }else{
                onFetched([])
            }
        }
    }
    
    
    /// Get users matching certain phone number
    /// - Parameter phone: The phone prefix you want to look for
    /// - Parameter onFetched: The callback to call when the user is fetched
    /// - Parameter onError: The callback to call when an error occured or user wasn't found
    static func fetchMatchingUsersBy(name:String, onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").queryOrdered(byChild: "PersonalData/fistName").queryStarting(atValue: name.capitalized).queryEnding(atValue: "\(name.capitalized)\\uf8ff").getData { error, snapshot in
            // Check if no error happened during the query itself
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                var namesArray:[Card] = cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) }
                
                fetchMatchingUsersBy(company: name.capitalized) { companyResult in
                    namesArray.append(contentsOf: companyResult)
                    
                    fetchMatchingUsersBy(title: name.capitalized) { titleResults in
                        namesArray.append(contentsOf: titleResults)
                        onFetched(namesArray.removeDuplicates())
                    } onError: { error in
                        onFetched(namesArray.removeDuplicates())
                    }
                    
                } onError: { error in
                    onFetched(namesArray.removeDuplicates())
                }

            }else{
                onFetched([])
            }
        }
    }
    
    
    /// Will perform any logic needed after updatig the data of the current logged in user
    static func postCurrentUserCardChanged() {
        // Store the firebase key if any :)
        SwapKeyChain.updateFirebaseKeyForLoggedInUser(with: currentUserCard?.firebaseKey)
    }
    
    /// Get a product related to current user if any with the key
    /// - Parameter onFetched: The callback to call when the card is fetched
    static func fetchProduct(onFetched:@escaping(ProductHistory?)->()) {
        // make sure we have a valid user logged in
        guard let userID:String = currentUserCard?.firebaseKey else {
            onFetched(nil)
            return
        }
        
        // let us get this product details
        userDatabaseReference.child("productHistory").queryOrdered(byChild: "firebaseKey").queryEqual(toValue : userID).queryLimited(toFirst: 1).getData { error, snapshot in
            guard let snapshot = snapshot,
                  let productHistory:ProductHistory = ProductHistory.createProductHistoryFrom(snapShot: snapshot) else {
                onFetched(nil)
                return
            }
            onFetched(productHistory)
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
    /// - Returns: Bool,Bool,Bool -> for Contact & Personal info & Profession sections
    static func currentUserHasValidData() -> (Bool, Bool, Bool) {
        // First make sure we have a current user card
        guard let nonNullCard:Card = currentUserCard else { return (false,false, false) }
        
        // Now let us return back his sections' validations
        return (nonNullCard.hasValidContactData(), nonNullCard.hasValidPersonalData(), nonNullCard.hasValidProfessionData())
    }
    
    
    /// Will store/edit the data on Firebase database for the current user, as per the current set values
    /// - Parameter onUpdated: Will be fired once the data is stored/updated for the card.
    /// - Parameter onError: Will be fired if the data writing failed for a given reason
    static func storeUpdate(product:ProductHistory, onUpdated:@escaping(ProductHistory)->()) {
        guard let nonNullCard:Card = currentUserCard else { return }
        // Determine the user key to store/update it in Firebase
        guard let _:String = nonNullCard.firebaseKey,
              let dict:[String:Any] = product.jsonDictionary() else {
            onUpdated(product)
            return
        }
        userDatabaseReference.child("productHistory").child(randomString(length: 20)).setValue(dict, withCompletionBlock: { error, ref in
            if let _ = error {
                onUpdated(product)
            }else{
                onUpdated(product)
            }
        })
    }
    
    /// Will store/edit the data on Firebase database for the current user, as per the current set values
    /// - Parameter onUpdated: Will be fired once the data is stored/updated for the card.
    /// - Parameter onError: Will be fired if the data writing failed for a given reason
    static func storeUpdateCurrentUser(onUpdated:@escaping(Card)->(),onError:@escaping(String)->()) {
        guard let nonNullCard:Card = currentUserCard else { return }
        // Determine the user key to store/update it in Firebase
        let userKey:String = nonNullCard.firebaseKey ?? UUID().uuidString.stripped
        guard let nonNullCard:Card = SwapFirebaseUsers.currentUserCard,
              let dict:[String:Any] = nonNullCard.jsonDictionary() else {
            onError("Please try again later")
            return
        }
        userDatabaseReference.child("users").child(userKey).setValue(dict, withCompletionBlock: { error, ref in
            if let error = error {
                onError(error.localizedDescription)
            }else{
                onUpdated(nonNullCard)
            }
        })
    }
    
    /// Will update a given image to the firebase storage bucket
    /// - Parameter image: The image we want to store
    /// - Parameter onStored: Will fire when it is stored and will share the url to download the uploaded image
    static func upload(image:UIImage, onStored:@escaping(String)->()) {
        // get the data we will store
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        // let us generate a random name for the image
        let imageName:String = "\(UUID().uuidString.stripped).jpg"
        // let us store it
        // Upload the file to the path "images/imageName.jpg"
        // Create a reference to the file you want to upload
        let imageRef = userStorageReference.child(imageName)
        
        let _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
                return
            }
            
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                onStored(downloadURL.absoluteString)
            }
        }
    }
    
    
    static func fetchAllUsers(onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("users").getData { error, snapshot in
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                onFetched(cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) })
            }else{
                onFetched([])
            }
        }
    }
    
    static func fetchAllMenoDagUsers(onFetched:@escaping([Card])->(), onError:@escaping(String)->()) {
        userDatabaseReference.child("usersMenoDag").getData { error, snapshot in
            if let error = error {
                onError(error.localizedDescription)
            }else if let cards:[DataSnapshot] = snapshot?.children.allObjects as? [DataSnapshot] {
                onFetched(cards.compactMap{ Card.createCardFrom(snapShot: $0, key: $0.key) })
            }else{
                onFetched([])
            }
        }
    }
    
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
