//
//  DateFormatter.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/28/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import Foundation
extension String {
    static func formattedDate(str: String) -> String {
        var formattedString = str
        // DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // create a Date()
        if let date = dateFormatter.date(from: formattedString) {
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            formattedString = dateFormatter.string(from: date)
        } else {
            print("formattedDate: invalid date")
        }
        return formattedString
    }
}
