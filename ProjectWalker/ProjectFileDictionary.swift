//
//  ProjectFileDictionary.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public typealias ProjectFileDictionary = [String: AnyObject]

public extension ProjectFileDictionary {
    func int(forKey key: String) -> Int? {
        if let value = self[key] as? String {
            return Int(value)
        }
        return nil
    }

    func string(forKey key: String) -> String? {
        return self[key] as? String
    }

    func array(forKey key: String) -> ProjectFileArray? {
        return self[key] as? ProjectFileArray
    }

    func dictionary(forKey key: String) -> ProjectFileDictionary? {
        return self[key] as? ProjectFileDictionary
    }

    func bool(forKey key: String) -> Bool? {
        if let value = self[key] as? String {
            if let intValue = Int(value) {
                if intValue == 0 {
                    return false
                }
                return true
            }
        }
        return nil
    }

    func stringArray(forKey key: String) -> [String]? {
        if let value = self[key] as? [String] {
            return value
        }
        return nil
    }
}
