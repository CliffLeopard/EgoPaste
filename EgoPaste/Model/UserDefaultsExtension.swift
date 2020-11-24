//
//  UserDefaultsExtension.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/13.
//

import Foundation

extension UserDefaults {
    
    public struct Keys {
        static let ignoreEvents = "ignoreEvents"
        static let ignoredPasteboardTypes = "ignoredPasteboardTypes"
        static let playSounds = "playSounds"
    }
    
    public struct Values {
        static let ignoredPasteboardTypes: [String] = []
        static let size = 200
    }
    
    @objc dynamic public var ignoreEvents: Bool {
        get { bool(forKey: Keys.ignoreEvents) }
        set { set(newValue, forKey: Keys.ignoreEvents) }
    }
    
    public var ignoredPasteboardTypes: Set<String> {
        get { Set(array(forKey: Keys.ignoredPasteboardTypes) as? [String] ?? Values.ignoredPasteboardTypes) }
        set { set(Array(newValue), forKey: Keys.ignoredPasteboardTypes) }
    }
    
    public var playSounds: Bool {
        get { bool(forKey: Keys.playSounds) }
        set { set(newValue, forKey: Keys.playSounds) }
    }
}
