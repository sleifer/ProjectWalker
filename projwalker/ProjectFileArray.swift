//
//  ProjectFileArray.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

typealias ProjectFileArray = [AnyObject]

extension ProjectFileArray {
    func int(forIndex index: Int) -> Int? {
        if index < self.count {
            if let value = self[index] as? String {
                return Int(value)
            }
        }
        return nil
    }

    func string(forIndex index: Int) -> String? {
        if index < self.count {
            return self[index] as? String
        }
        return nil
    }

    func array(forIndex index: Int) -> ProjectFileArray? {
        if index < self.count {
            return self[index] as? ProjectFileArray
        }
        return nil
    }

    func dictionary(forIndex index: Int) -> ProjectFileDictionary? {
        if index < self.count {
            return self[index] as? ProjectFileDictionary
        }
        return nil
    }
}
