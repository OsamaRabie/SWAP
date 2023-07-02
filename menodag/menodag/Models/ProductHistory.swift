//
//  ProductHistory.swift
//  menodag
//
//  Created by Osama Rabie on 01/07/2023.
//

import Foundation
import Firebase
import FirebaseDatabase

// MARK: - ProductHistory
struct ProductHistory: Codable {
    var firebaseKey: String?
    var events: [Event]?
}

// MARK: ProductHistory convenience initializers and mutators

extension ProductHistory {
    
    /// Creates a default shipping history once you ask for producing an NFC card
    static func createDefaultCard() -> ProductHistory {
        // let us get the user key
        guard let userKey:String = SwapFirebaseUsers.currentUserCard?.firebaseKey else { return .init() }
        // let us get the current day/month
        let today:String = Date().getFormattedDate(format: "dd/MM")
        let submitEvent:Event = .init(status: "done", date: today, title: "Submission", message: "We received the request.", image: "checkmark.circle.fill")
        let verifyEvent:Event = .init(status: "progress", date: today, title: "Verification", message: "We will call you to choose your card design.", image: "checklist")
        let uiEvent:Event = .init(status: "pending", date: "NA", title: "Design", message: "Your card is being printed.", image: "clock.badge.checkmark.fill")
        let processEvent:Event = .init(status: "pending", date: "NA", title: "Manufacturing", message: "We received the request.", image: "clock.badge.checkmark.fill")
        let deliveryEvent:Event = .init(status: "pending", date: "NA", title: "Delivery", message: "Your card is delivered.", image: "clock.badge.checkmark.fill")
        
        return .init(firebaseKey: userKey, events: [submitEvent, verifyEvent, uiEvent, processEvent, deliveryEvent])
    }
    
    /// Creates a card model from a given firebase snapshot
    /// - Parameter snapShot: The snapshot you get from firebase query
    /// - Returns: The card data if correcly parsed and nil otherwise
    static func createProductHistoryFrom(snapShot: DataSnapshot?) -> ProductHistory? {
        // Check if there is a user with the provided value
        guard let snapshot = snapShot,
              let user = snapshot.value as? [String:Any],
              let userKey:String = user.keys.first,
              let userValues:[String:Any] = user[userKey] as? [String:Any],
              let userData:Data = try? JSONSerialization.data(withJSONObject: userValues, options: JSONSerialization.WritingOptions.prettyPrinted),
              let productHistoryModel:ProductHistory = try? .init(data: userData) else { return nil }
        // Return the user we found with the provided value
        return productHistoryModel
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductHistory.self, from: data)
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
        events: [Event]?? = nil
    ) -> ProductHistory {
        return ProductHistory(
            firebaseKey: firebaseKey ?? self.firebaseKey,
            events: events ?? self.events
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
    
}

// MARK: - Event
struct Event: Codable {
    var status, date, title, message: String?
    var image: String?
}

// MARK: Event convenience initializers and mutators

extension Event {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Event.self, from: data)
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
        status: String?? = nil,
        date: String?? = nil,
        title: String?? = nil,
        message: String?? = nil,
        image: String?? = nil
    ) -> Event {
        return Event(
            status: status ?? self.status,
            date: date ?? self.date,
            title: title ?? self.title,
            message: message ?? self.message,
            image: image ?? self.image
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Event:Equatable {
    
}
