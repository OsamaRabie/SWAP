//
//  User.swift
//  menodag
//
//  Created by Osama Rabie on 24/06/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import ContactsUI
// MARK: - User
struct Card: Codable,Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.firebaseKey ?? "" == rhs.firebaseKey ?? ""
    }
    
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
    
    
    func valueFor(socialMediaType:SocialMediaType) -> String {
        switch socialMediaType {
            
        case .Facebook:
            return professionalData?.faceBook ?? ""
        case .Linkedin:
            return professionalData?.linkedIn ?? ""
        case .Github:
            return professionalData?.github ?? ""
        case .Twitter:
            return professionalData?.twitter ?? ""
        case .Dribble:
            return professionalData?.dribble ?? ""
        }
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
    
    
    /// Creates a card model from a given firebase snapshot
    /// - Parameter snapShot: The snapshot you get from firebase query
    /// - Parameter key: The key if we know it already
    /// - Returns: The card data if correcly parsed and nil otherwise
    static func createCardFrom(snapShot: DataSnapshot?, key:String) -> Card? {
        // Check if there is a user with the provided value
        guard let snapshot = snapShot,
              let user = snapshot.value as? [String:Any],
              let userData:Data = try? JSONSerialization.data(withJSONObject: user, options: JSONSerialization.WritingOptions.prettyPrinted),
              let cardModel:Card = try? .init(data: userData, fireBaseKey: key) else { return nil }
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
            nonNullCard.professionalData?.github = value
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
    
    func jsonDictionary() -> [String: Any]? {
            do {
                return try JSONSerialization.jsonObject(with: jsonData(), options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        return nil
    }
    
    func toContact(imageData:Data?) -> CNMutableContact {
        let contact = CNMutableContact()
        contact.emailAddresses  = [CNLabeledValue(label:CNLabelWork , value: (self.contactData?.email ?? "") as NSString)]
        contact.phoneNumbers    = [CNLabeledValue(label:CNLabelWork , value: .init(stringValue:self.contactData?.phone ?? ""))]
        contact.givenName       = self.personalData?.fistName ?? ""
        contact.familyName      = self.personalData?.lastName ?? ""
        contact.imageData       = imageData
        contact.jobTitle        = self.professionalData?.title ?? ""
        contact.departmentName  = self.professionalData?.company ?? ""
        contact.socialProfiles  = [CNLabeledValue(label: "Facebook", value: CNSocialProfile(urlString: "", username: self.professionalData?.faceBook ?? "", userIdentifier: nil, service: CNSocialProfileServiceFacebook)), CNLabeledValue(label: "Linkedin", value: CNSocialProfile(urlString: "", username: self.professionalData?.linkedIn ?? "", userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)), CNLabeledValue(label: "Twitter", value: CNSocialProfile(urlString: "", username: self.professionalData?.twitter ?? "", userIdentifier: nil, service: CNSocialProfileServiceTwitter))]
        return contact
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
    
    /// Will decide if the user has valid profession data including job & company
    /// - Returns: True, if the current user has correct job & company
    func hasValidProfessionData() -> Bool {
        guard let job:String = self.professionalData?.company,
              !job.isEmpty,
              job.count > 3,
              let company:String = self.professionalData?.title,
              !company.isEmpty,
              company.count > 3 else { return false }
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
            isValid = value?.count ?? 0 > 3
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.companyError
        case .title:
            isValid = value?.count ?? 0 > 3
            errorMessage = isValid ? "" : sharedLocalisationManager.localization.errors.jobError
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
    var phone, email: String
    var url: String?
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
        phone:  String = "",
        email:  String = "",
        url:    String? = nil
    ) -> ContactData {
        return ContactData(
            phone: phone,
            email: email,
            url:   url
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
    var fistName, lastName, userName, photo: String
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
        fistName: String = "",
        lastName: String = "",
        userName: String = "",
        photo: String = ""
    ) -> PersonalData {
        return PersonalData(
            fistName: fistName,
            lastName: lastName,
            userName: userName,
            photo: photo
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
    var company, title, linkedIn, faceBook: String
    var twitter, dribble, github: String?
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
        company: String = "",
        title: String = "",
        linkedIn: String = "",
        faceBook: String = "",
        twitter: String = "",
        dribble: String = "",
        github: String? = ""
    ) -> ProfessionalData {
        return ProfessionalData(
            company: company,
            title: title,
            linkedIn: linkedIn,
            faceBook: faceBook,
            twitter: twitter,
            dribble: dribble,
            github: github
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
