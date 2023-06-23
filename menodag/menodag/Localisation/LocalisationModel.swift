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
    let otpScreen: OtpScreen
    let buttonTitles: ButtonTitles
    let textFieldPlaceHolders: TextFieldPlaceHolders
    let languagePicker: LanguagePicker
    let errors: Errors
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
        otpScreen: OtpScreen?  = nil,
        buttonTitles: ButtonTitles? = nil,
        textFieldPlaceHolders: TextFieldPlaceHolders? = nil,
        languagePicker: LanguagePicker? = nil,
        errors: Errors? = nil
    ) -> Ar {
        return Ar(
            getStarted: getStarted ?? self.getStarted,
            otpScreen: otpScreen ?? self.otpScreen,
            buttonTitles: buttonTitles ?? self.buttonTitles,
            textFieldPlaceHolders: textFieldPlaceHolders ?? self.textFieldPlaceHolders,
            languagePicker: languagePicker ?? self.languagePicker,
            errors: errors ?? self.errors
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
    let buttonTitlesContinue, cancel: String
    
    enum CodingKeys: String, CodingKey {
        case buttonTitlesContinue = "continue"
        case cancel
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
        buttonTitlesContinue: String? = nil,
        cancel: String? = nil
    ) -> ButtonTitles {
        return ButtonTitles(
            buttonTitlesContinue: buttonTitlesContinue ?? self.buttonTitlesContinue,
            cancel: cancel ?? self.cancel
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Errors
struct Errors: Codable {
    let signWithPhoneError: String
}

// MARK: Errors convenience initializers and mutators

extension Errors {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Errors.self, from: data)
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
        signWithPhoneError: String? = nil
    ) -> Errors {
        return Errors(
            signWithPhoneError: signWithPhoneError ?? self.signWithPhoneError
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - OtpScreen
struct OtpScreen: Codable {
    let header, title, message, resend: String
    let actionButton: String
}

// MARK: OtpScreen convenience initializers and mutators

extension OtpScreen {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OtpScreen.self, from: data)
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
        title: String? = nil,
        message: String? = nil,
        resend: String? = nil,
        actionButton: String? = nil
    ) -> OtpScreen {
        return OtpScreen(
            header: header ?? self.header,
            title: title ?? self.title,
            message: message ?? self.message,
            resend: resend ?? self.resend,
            actionButton: actionButton ?? self.actionButton
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
    let termsConditions, orContinueWith: String
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
        loginWithOptions: String? = nil,
        termsConditions: String? = nil,
        orContinueWith: String? = nil
    ) -> GetStarted {
        return GetStarted(
            header: header ?? self.header,
            subHeader: subHeader ?? self.subHeader,
            forgorPassword: forgorPassword ?? self.forgorPassword,
            loginWithOptions: loginWithOptions ?? self.loginWithOptions,
            termsConditions: termsConditions ?? self.termsConditions,
            orContinueWith: orContinueWith ?? self.orContinueWith
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - LanguagePicker
struct LanguagePicker: Codable {
    let title, subTitle, english, arabic: String
}

// MARK: LanguagePicker convenience initializers and mutators

extension LanguagePicker {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LanguagePicker.self, from: data)
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
        title: String? = nil,
        subTitle: String? = nil,
        english: String? = nil,
        arabic: String? = nil
    ) -> LanguagePicker {
        return LanguagePicker(
            title: title ?? self.title,
            subTitle: subTitle ?? self.subTitle,
            english: english ?? self.english,
            arabic: arabic ?? self.arabic
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
    let email, phone, password: String
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
        phone: String? = nil,
        password: String? = nil
    ) -> TextFieldPlaceHolders {
        return TextFieldPlaceHolders(
            email: email ?? self.email,
            phone: phone ?? self.phone,
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
