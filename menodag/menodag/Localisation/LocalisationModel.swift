//
//  LocalisationModel.swift
//  menodag
//
//  Created by Osama Rabie on 15/05/2023.
//

import Foundation
import MOLH
// MARK: - Localisation
let sharedLocalisationManager = Localisation(fromURL:URL(fileURLWithPath: Bundle.main.path(forResource: "localisation", ofType: "json")!))


struct Localisation: Codable {
    let en, ar: Ar
    
    var localization:Ar {
        return MOLHLanguage.isArabic() ? ar : en
    }
}

// MARK: Localisation convenience initializers and mutators

extension Localisation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Localisation.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) {
        try! self.init(data: try! Data(contentsOf: url))
    }
    
    func with(
        en: Ar? = nil,
        ar: Ar? = nil
    ) -> Localisation {
        return Localisation(
            en: en ?? self.en,
            ar: ar ?? self.ar
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Ar
struct Ar: Codable {
    let getStarted: GetStarted
    let buttonTitles: ButtonTitles
    let textFieldPlaceHolders: TextFieldPlaceHolders
}

// MARK: Ar convenience initializers and mutators

extension Ar {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Ar.self, from: data)
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
        getStarted: GetStarted? = nil,
        buttonTitles: ButtonTitles? = nil,
        textFieldPlaceHolders: TextFieldPlaceHolders? = nil
    ) -> Ar {
        return Ar(
            getStarted: getStarted ?? self.getStarted,
            buttonTitles: buttonTitles ?? self.buttonTitles,
            textFieldPlaceHolders: textFieldPlaceHolders ?? self.textFieldPlaceHolders
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ButtonTitles
struct ButtonTitles: Codable {
    let buttonTitlesContinue: String
    
    enum CodingKeys: String, CodingKey {
        case buttonTitlesContinue = "continue"
    }
}

// MARK: ButtonTitles convenience initializers and mutators

extension ButtonTitles {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ButtonTitles.self, from: data)
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
        buttonTitlesContinue: String? = nil
    ) -> ButtonTitles {
        return ButtonTitles(
            buttonTitlesContinue: buttonTitlesContinue ?? self.buttonTitlesContinue
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - GetStarted
struct GetStarted: Codable {
    let header, subHeader, forgorPassword, loginWithOptions: String
}

// MARK: GetStarted convenience initializers and mutators

extension GetStarted {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetStarted.self, from: data)
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
        header: String? = nil,
        subHeader: String? = nil,
        forgorPassword: String? = nil,
        loginWithOptions: String? = nil
    ) -> GetStarted {
        return GetStarted(
            header: header ?? self.header,
            subHeader: subHeader ?? self.subHeader,
            forgorPassword: forgorPassword ?? self.forgorPassword,
            loginWithOptions: loginWithOptions ?? self.loginWithOptions
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - TextFieldPlaceHolders
struct TextFieldPlaceHolders: Codable {
    let email, password: String
}

// MARK: TextFieldPlaceHolders convenience initializers and mutators

extension TextFieldPlaceHolders {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TextFieldPlaceHolders.self, from: data)
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
        email: String? = nil,
        password: String? = nil
    ) -> TextFieldPlaceHolders {
        return TextFieldPlaceHolders(
            email: email ?? self.email,
            password: password ?? self.password
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

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
