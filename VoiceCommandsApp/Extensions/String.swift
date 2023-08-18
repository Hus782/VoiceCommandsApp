//
//  String.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/18/23.
//

import Foundation

extension String {
    var isNumber: Bool {
        return self.allSatisfy { character in
            character.isNumber

        }
    }
    
    func convertDigitsToSpelledOut() -> String {
         let components = self.split(separator: " ")
//        var results: String = ""
//        for component in components {
//            if let number = Int(component) {
//                results += spelledOut
//            } else {
//                results += component
//            }
//        }
        
         let convertedComponents = components.map { component -> String in
             if Int(component) != nil {
                 return String(component).spelledOut
             } else {
                 return String(component)
             }
         }
        
        
         return convertedComponents.joined(separator: " ")
     }
    func spelledOutDigits(for number: Int) -> String {
           let digits = String(number)
           let formatter = NumberFormatter()
           formatter.numberStyle = .spellOut
           
           let spelledOutDigits = digits.compactMap { Int(String($0)) }
                                        .compactMap { formatter.string(for: $0) }
                                        .joined(separator: " ")
           
           return spelledOutDigits
       }
       
       var spelledOut: String {
           guard let number = Int(self) else {
               return ""
           }
           
           return spelledOutDigits(for: number)
       }
}
