//
//  ProjectFileArray.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public typealias ProjectFileArray = [AnyObject]

public extension ProjectFileArray {
    public func int(forIndex index: Int) -> Int? {
        if index < self.count {
            if let value = self[index] as? String {
                return Int(value)
            }
        }
        return nil
    }

    public func string(forIndex index: Int) -> String? {
        if index < self.count {
            return self[index] as? String
        }
        return nil
    }

    public func array(forIndex index: Int) -> ProjectFileArray? {
        if index < self.count {
            return self[index] as? ProjectFileArray
        }
        return nil
    }

    public func dictionary(forIndex index: Int) -> ProjectFileDictionary? {
        if index < self.count {
            return self[index] as? ProjectFileDictionary
        }
        return nil
    }
}
