//
//  String+Extension.swift
//  GDCalendar
//
//  Created by Saeid on 12/30/18.
//  Copyright © 2018 Saeid Basirnia. All rights reserved.
//

import Foundation

extension String{
    public var convertNumbers: String{
        var locale: Locale!
        if let localeString = UserDefaults.standard.object(forKey: "current_locale") as? String{
            locale = Locale(identifier: localeString)
        }else{
            locale = Locale.current
        }
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = locale
        
        var finalStr: String = ""
        for t in self{
            if let n = Int(String(t)){
                finalStr += formatter.string(from: NSNumber(integerLiteral: n))!
            }else{
                finalStr += String(t)
            }
        }
        return finalStr
    }
}
