//
//  Menodag+String.swift
//  menodag
//
//  Created by Osama Rabie on 20/05/2023.
//

import Foundation


extension String {
    
    /// Checks if the current string is a valid email address or not
    func isValidEmailAddress() -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    /// Checks if the current string is a valid international phone number or not
    func isValidPhoneNumber() -> Bool {
        return self.allSatisfy{ $0.isNumber } && self.count == 8
    }
    
    /// removes anything not an alpha numeric
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    /// Decides if a given string is a whole number
    var isWholeNumber: Bool {
        return self.allSatisfy { character in
            character.isWholeNumber
            
        }
    }
}


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
