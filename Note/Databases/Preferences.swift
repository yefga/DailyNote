//
//  Preferences.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import Foundation

struct Preferences {
    
    private init() {
        
    }
    
    static func setState(active:Bool, key: String) {
        UserDefaults.standard.set(active, forKey: key)
    }
    
    static func getState(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func removeState(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
