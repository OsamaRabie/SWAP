//
//  Menodag+Array.swift
//  menodag
//
//  Created by Osama Rabie on 02/07/2023.
//

import Foundation



extension Array where Element == Card {
    func removeDuplicates() -> [Card] {
        var uniqueArray:[Card] = []
        self.forEach { card in
            if let _ = uniqueArray.first(where: { $0.firebaseKey == card.firebaseKey }) {
                // This means, it is added already move
            }else{
                uniqueArray.append(card)
            }
        }
        return uniqueArray
    }
}
