//
//  Date+Extensions.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import Foundation

extension Date {
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }
    
}
