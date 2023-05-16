//
//  MenodagFont.swift
//  menodag
//
//  Created by Osama Rabie on 13/05/2023.
//

import UIKit
import MOLH
/// Defines the list of font names used by the app in both languages
enum MenodagFont:String, CaseIterable {
    
    case PoppinsBlack = "Poppins-Black"
    case PoppinsBold = "Poppins-Bold"
    case PoppinsExtraBold = "Poppins-ExtraBold"
    case PoppinsExtraLight = "Poppins-ExtraLight"
    case PoppinsLight = "Poppins-Light"
    case PoppinsMedium = "Poppins-Medium"
    case PoppinsRegular = "Poppins-Regular"
    
    case TajawalBlack = "Tajawal-Black"
    case TajawalBold = "Tajawal-Bold"
    case TajawalExtraBold = "Tajawal-ExtraBold"
    case TajawalExtraLight = "Tajawal-ExtraLight"
    case TajawalLight = "Tajawal-Light"
    case TajawalMedium = "Tajawal-Medium"
    case TajawalRegular = "Tajawal-Regular"
}

extension MenodagFont {
    /// Will create a localized font
    /// - Parameter for englishFont: The original english fonr
    /// - Parameter with size: The required size for the font
    /// - returns : The localized font based on the locale & the required size
    static func localizedFont(for englishFont:MenodagFont, with size:CGFloat) -> UIFont {
        
        // compute the correct font name based on the locale
        var correctFontName:String = englishFont.rawValue
        if MOLHLanguage.isArabic() {
            // This means it is arabic and we need to get the arabic font name from the english font name
            correctFontName = MenodagFont.mapArabicFont(from: englishFont).rawValue
        }
        
        // Time to create the font :)
        return UIFont(name: correctFontName, size: size) ?? .systemFont(ofSize: size)
    }
    
    /// Will map the english font to the arabic version
    /// - Parameter from englishFont: The english fonr you want to map
    /// - returns: The arabic version of the provided english font
    static func mapArabicFont(from englishFont:MenodagFont) -> MenodagFont {
        switch englishFont {
            
        case .PoppinsBlack:
            return .TajawalBlack
        case .PoppinsBold:
            return .TajawalBold
        case .PoppinsExtraBold:
            return .TajawalExtraBold
        case .PoppinsExtraLight:
            return .TajawalExtraLight
        case .PoppinsLight:
            return .TajawalLight
        case .PoppinsMedium:
            return .TajawalMedium
        case .PoppinsRegular:
            return .TajawalRegular
        default:
            return englishFont
        }
    }
}
