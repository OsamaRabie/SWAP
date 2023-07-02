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
    let personalInfoScreen: PersonalInfoScreen
    let buttonTitles: ButtonTitles
    let textFieldPlaceHolders: TextFieldPlaceHolders
    let languagePicker: LanguagePicker
    let errors: Errors
    let emptyTable: EmptyTable
    let smsMailPicker: SmsMailPicker
    let connectAlert: ConnectAlert
    let createProfileForCardAlert: CreateProfileForCardAlert
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
        otpScreen: OtpScreen? = nil,
        personalInfoScreen: PersonalInfoScreen? = nil,
        buttonTitles: ButtonTitles? = nil,
        textFieldPlaceHolders: TextFieldPlaceHolders? = nil,
        languagePicker: LanguagePicker? = nil,
        errors: Errors? = nil,
        emptyTable: EmptyTable? = nil,
        smsMailPicker: SmsMailPicker? = nil,
        connectAlert: ConnectAlert? = nil,
        createProfileForCardAlert: CreateProfileForCardAlert? = nil
    ) -> Ar {
        return Ar(
            getStarted: getStarted ?? self.getStarted,
            otpScreen: otpScreen ?? self.otpScreen,
            personalInfoScreen: personalInfoScreen ?? self.personalInfoScreen,
            buttonTitles: buttonTitles ?? self.buttonTitles,
            textFieldPlaceHolders: textFieldPlaceHolders ?? self.textFieldPlaceHolders,
            languagePicker: languagePicker ?? self.languagePicker,
            errors: errors ?? self.errors,
            emptyTable: emptyTable ?? self.emptyTable,
            smsMailPicker: smsMailPicker ?? self.smsMailPicker,
            connectAlert: connectAlert ?? self.connectAlert,
            createProfileForCardAlert: createProfileForCardAlert ?? self.createProfileForCardAlert
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
    let buttonTitlesContinue, cancel, complete, ok, skip, delete: String
    
    enum CodingKeys: String, CodingKey {
        case buttonTitlesContinue = "continue"
        case cancel, complete, ok, skip, delete
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
        cancel: String? = nil,
        complete: String? = nil,
        ok: String? = nil,
        skip: String? = nil,
        delete: String? = nil
    ) -> ButtonTitles {
        return ButtonTitles(
            buttonTitlesContinue: buttonTitlesContinue ?? self.buttonTitlesContinue,
            cancel: cancel ?? self.cancel,
            complete: complete ?? self.complete,
            ok: ok ?? self.ok,
            skip: skip ?? self.skip,
            delete: delete ?? self.delete
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
    let signWithPhoneError,firstNameError,userNameError,phoneError,emailError,jobError,companyError: String
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
        signWithPhoneError: String? = nil,
        firstNameError: String?     = nil,
        userNameError: String?      = nil,
        phoneError: String?         = nil,
        emailError: String?         = nil,
        jobError: String?         = nil,
        companyError: String?         = nil
    ) -> Errors {
        return Errors(
            signWithPhoneError: signWithPhoneError ?? self.signWithPhoneError,
            firstNameError: firstNameError ?? self.firstNameError,
            userNameError:  userNameError ?? self.userNameError,
            phoneError:     phoneError ?? self.phoneError,
            emailError:     emailError ?? self.emailError,
            jobError:     jobError ?? self.jobError,
            companyError:     companyError ?? self.companyError
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - EmptyTable
struct EmptyTable: Codable {
    let searchHistoryLabel,searchHistoryMessage,exchangeHistoryLabel,exchangeHistoryMessage,productHistoryLabel,productHistoryMessage: String
}

// MARK: Errors convenience initializers and mutators

extension EmptyTable {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EmptyTable.self, from: data)
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
        searchHistoryLabel: String? = nil,
        searchHistoryMessage: String? = nil,
        exchangeHistoryLabel: String? = nil,
        exchangeHistoryMessage: String? = nil,
        productHistoryLabel: String? = nil,
        productHistoryMessage: String? = nil
    ) -> EmptyTable {
        return EmptyTable(
            searchHistoryLabel: searchHistoryLabel ?? self.searchHistoryLabel,
            searchHistoryMessage: searchHistoryMessage ?? self.searchHistoryMessage,
            exchangeHistoryLabel: exchangeHistoryLabel ?? self.exchangeHistoryLabel,
            exchangeHistoryMessage: exchangeHistoryMessage ?? self.exchangeHistoryMessage,
            productHistoryLabel: productHistoryLabel ?? self.productHistoryLabel,
            productHistoryMessage: productHistoryMessage ?? self.productHistoryMessage
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



// MARK: - ConnectAlert
struct ConnectAlert: Codable {
    let title, subTitle: String
}

// MARK: connectAlert convenience initializers and mutators

extension ConnectAlert {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ConnectAlert.self, from: data)
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
        subTitle: String? = nil
    ) -> ConnectAlert {
        return ConnectAlert(
            title: title ?? self.title,
            subTitle: subTitle ?? self.subTitle
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - ConnectAlert
struct CreateProfileForCardAlert: Codable {
    let title, subTitle: String
}

// MARK: connectAlert convenience initializers and mutators

extension CreateProfileForCardAlert {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreateProfileForCardAlert.self, from: data)
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
        subTitle: String? = nil
    ) -> CreateProfileForCardAlert {
        return CreateProfileForCardAlert(
            title: title ?? self.title,
            subTitle: subTitle ?? self.subTitle
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - SmsMailPicker
struct SmsMailPicker: Codable {
    let title, subTitle, sms, email: String
}

// MARK: SmsMailPicker convenience initializers and mutators

extension SmsMailPicker {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SmsMailPicker.self, from: data)
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
        sms: String? = nil,
        email: String? = nil
    ) -> SmsMailPicker {
        return SmsMailPicker(
            title: title ?? self.title,
            subTitle: subTitle ?? self.subTitle,
            sms: sms ?? self.sms,
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

// MARK: - PersonalInfoScreen
struct PersonalInfoScreen: Codable {
    let header, subHeader, footer: String
}

// MARK: PersonalInfoScreen convenience initializers and mutators

extension PersonalInfoScreen {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PersonalInfoScreen.self, from: data)
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
        footer: String? = nil
    ) -> PersonalInfoScreen {
        return PersonalInfoScreen(
            header: header ?? self.header,
            subHeader: subHeader ?? self.subHeader,
            footer: footer ?? self.footer
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
    var email, phone, userName, firstName, lastName, password, job, company, search: String
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
        firstName: String? = nil,
        lastName: String? = nil,
        password: String? = nil,
        userName: String? = nil,
        job: String? = nil,
        company: String? = nil,
        search: String? = nil
    ) -> TextFieldPlaceHolders {
        return TextFieldPlaceHolders(
            email: email ?? self.email,
            phone: phone ?? self.phone,
            userName: userName ?? self.userName,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            password: password ?? self.password,
            job: job ?? self.job,
            company: company ?? self.company,
            search:  search ?? self.search
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
