//
//  User.swift
//  menodag
//
//  Created by Osama Rabie on 24/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
// MARK: - User
struct Card: Codable {
    var firebaseKey: String?
    var contactData: ContactData?
    var personalData: PersonalData?
    var professionalData: ProfessionalData?
    
    enum CodingKeys: String, CodingKey {
        case firebaseKey = "FireBaseKey"
        case contactData = "ContactData"
        case personalData = "PersonalData"
        case professionalData = "ProfessionalData"
    }
}

// MARK: User convenience initializers and mutators

extension Card {
    
    /// Creates a card model from a given firebase snapshot
    /// - Parameter snapShot: The snapshot you get from firebase query
    /// - Returns: The card data if correcly parsed and nil otherwise
    static func createCardFrom(snapShot: DataSnapshot?) -> Card? {
        // Check if there is a user with the provided value
        guard let snapshot = snapShot,
              let user = snapshot.value as? [String:Any],
              let userKey:String = user.keys.first,
              let userValues:[String:Any] = user[userKey] as? [String:Any],
              let userData:Data = try? JSONSerialization.data(withJSONObject: userValues, options: JSONSerialization.WritingOptions.prettyPrinted),
              let cardModel:Card = try? .init(data: userData, fireBaseKey: userKey) else { return nil }
        // Return the user we found with the provided value
        return cardModel
    }
    
    /// Updates the card field
    /// - Parameter for field: The field to be updated
    /// - Parameter with value: The value to update the field with
    func updateCurrentUserCard(for field:UserCardField, with value:String) {
        
        var nonNullCard:Card = self
        
        switch field {
            
        case .firstName:
            nonNullCard.personalData?.fistName = value
        case .lastName:
            nonNullCard.personalData?.lastName = value
        case .emailAddress:
            nonNullCard.contactData?.email = value
        case .phone:
            nonNullCard.contactData?.phone = value
        case .userName:
            nonNullCard.personalData?.userName = value
        case .photo:
            nonNullCard.personalData?.photo = value
        case .company:
            nonNullCard.professionalData?.company = value
        case .title:
            nonNullCard.professionalData?.title = value
        case .linkedIn:
            nonNullCard.professionalData?.linkedIn = value
        case .faceBook:
            nonNullCard.professionalData?.faceBook = value
        case .twitter:
            nonNullCard.professionalData?.twitter = value
        case .dribble:
            nonNullCard.professionalData?.dribble = value
        case .gitHub:
            nonNullCard.professionalData?.gitHub = value
        }
        
        SwapFirebaseUsers.currentUserCard = nonNullCard
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Card.self, from: data)
    }
    
    init(data: Data, fireBaseKey:String) throws {
        self = try newJSONDecoder().decode(Card.self, from: data)
        self.firebaseKey = fireBaseKey
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        firebaseKey: String?? = nil,
        contactData: ContactData?? = nil,
        personalData: PersonalData?? = nil,
        professionalData: ProfessionalData?? = nil
    ) -> Card {
        return Card(
            firebaseKey: firebaseKey ?? self.firebaseKey,
            contactData: contactData ?? self.contactData,
            personalData: personalData ?? self.personalData,
            professionalData: professionalData ?? self.professionalData
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    /// Will decide if the user has valid email and phone data attached to its profile
    /// - Returns: True, if the current user has correct ohone and email data
    func hasValidContactData() -> Bool {
        guard let phone:String = self.contactData?.phone,
              phone.isValidPhoneNumber(),
              let email:String = self.contactData?.email,
              email.isValidEmailAddress() else { return false }
        return true
    }
    
    /// Will decide if the user has valid personal data including first name and username
    /// - Returns: True, if the current user has correct ohone and email data
    func hasValidPersonalData() -> Bool {
        guard let firstName:String = self.personalData?.fistName,
              !firstName.isEmpty,
              firstName.count > 3,
              let userName:String = self.personalData?.userName,
              !userName.isEmpty,
              userName.count > 3 else { return false }
        return true
    }
    
    /// Will check i fthe passed field is valid or not
    /// - Parameter field: The field type you want to validate
    /// - Parameter value: The value you want to validate
    /// - Returns (isValid,errorMessage) : Couple to tell if it is valid and if there an error message to show
    static func validate(field:UserCardField,value:String?) -> (Bool,String) {
        var isValid:Bool = true
        var errorMessage:String = ""
        
        switch field {
        case .firstName:
            isValid = value?.count ?? 0 > 3
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.firstNameError
        case .lastName:
            // Not required
            return(true,"")
        case .emailAddress:
            isValid = value?.isValidEmailAddress() ?? false
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.emailError
        case .phone:
            isValid = value?.isValidPhoneNumber() ?? false
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.phoneError
        case .userName:
            isValid = value?.count ?? 0 > 3
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.userNameError
        case .photo:
            // Not required
            return(true,"")
        case .company:
            // Not required
            return(true,"")
        case .title:
            // Not required
            return(true,"")
        case .linkedIn:
            // Not required
            return(true,"")
        case .faceBook:
            // Not required
            return(true,"")
        case .twitter:
            // Not required
            return(true,"")
        case .dribble:
            // Not required
            return(true,"")
        case .gitHub:
            // Not required
            return(true,"")
        }
        
        return (isValid, errorMessage)
    }
}

// MARK: - ContactData
struct ContactData: Codable {
    var phone, email: String?
}

// MARK: ContactData convenience initializers and mutators

extension ContactData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ContactData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        phone: String?? = nil,
        email: String?? = nil
    ) -> ContactData {
        return ContactData(
            phone: phone ?? self.phone,
            email: email ?? self.email
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PersonalData
struct PersonalData: Codable {
    var fistName, lastName, userName, photo: String?
}

// MARK: PersonalData convenience initializers and mutators

extension PersonalData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PersonalData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        fistName: String?? = nil,
        lastName: String?? = nil,
        userName: String?? = nil,
        photo: String?? = nil
    ) -> PersonalData {
        return PersonalData(
            fistName: fistName ?? self.fistName,
            lastName: lastName ?? self.lastName,
            userName: userName ?? self.userName,
            photo: photo ?? self.photo
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ProfessionalData
struct ProfessionalData: Codable {
    var company, title, linkedIn, faceBook: String?
    var twitter, dribble, gitHub: String?
}

// MARK: ProfessionalData convenience initializers and mutators

extension ProfessionalData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProfessionalData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        company: String?? = nil,
        title: String?? = nil,
        linkedIn: String?? = nil,
        faceBook: String?? = nil,
        twitter: String?? = nil,
        dribble: String?? = nil,
        gitHub: String?? = nil
    ) -> ProfessionalData {
        return ProfessionalData(
            company: company ?? self.company,
            title: title ?? self.title,
            linkedIn: linkedIn ?? self.linkedIn,
            faceBook: faceBook ?? self.faceBook,
            twitter: twitter ?? self.twitter,
            dribble: dribble ?? self.dribble,
            gitHub: gitHub ?? self.gitHub
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

@propertyWrapper public struct NilOnFail<T: Codable>: Codable {
    
    public let wrappedValue: T?
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}


//MARK: - An enum to define which field in the card
enum UserCardField {
    case firstName
    case lastName
    case emailAddress
    case phone
    case userName
    case photo
    case company
    case title
    case linkedIn
    case faceBook
    case twitter
    case dribble
    case gitHub
}
