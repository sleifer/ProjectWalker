//
//  ProjectFileDictionary.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public typealias ProjectFileDictionary = [String: AnyObject]

let isaSorter: (String, String) -> Bool = { lhs, rhs in
    if lhs == "isa" {
        return true
    } else if rhs == "isa" {
        return false
    } else if lhs < rhs {
        return true
    }
    return false
}

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

    internal func write(to fileText: IndentableString, oneLine: Bool = false) throws {
        let sortedKeys = self.keys.sorted(by: isaSorter)
        if oneLine == true {
            for key in sortedKeys {
                if let value = self[key] as? String {
                    fileText.append("\(key.openStepQuoted()) = \(value.openStepQuoted()); ", ignoreIndent: true)
                } else if let value = self[key] as? ProjectFileDictionary {
                    fileText.append("\(key) = {", ignoreIndent: true)
                    try value.write(to: fileText, oneLine: true)
                    fileText.append("};", ignoreIndent: true)
                } else if let value = self[key] as? ProjectFileArray {
                    fileText.append("\(key) = (", ignoreIndent: true)
                    for item in value {
                        if let stringValue = item as? String {
                            fileText.append("\(stringValue.openStepQuoted()), ", ignoreIndent: true)
                        } else {
                            fileText.append("\(item), ", ignoreIndent: true)
                        }
                    }
                    fileText.append("); ", ignoreIndent: true)
                } else if let value = self[key] {
                    fileText.append("\(key) = \(value); ", ignoreIndent: true)
                }
            }
        } else {
            for key in sortedKeys {
                if let value = self[key] as? String {
                    fileText.appendLine("\(key.openStepQuoted()) = \(value.openStepQuoted());")
                } else if let value = self[key] as? ProjectFileDictionary {
                    fileText.appendLine("\(key) = {")
                    fileText.indent()
                    try value.write(to: fileText)
                    fileText.outdent()
                    fileText.appendLine("};")
                } else if let value = self[key] as? ProjectFileArray {
                    fileText.appendLine("\(key) = (")
                    fileText.indent()
                    for item in value {
                        if let stringValue = item as? String {
                            fileText.appendLine("\(stringValue.openStepQuoted()),")
                        } else {
                            fileText.appendLine("\(item),")
                        }
                    }
                    fileText.outdent()
                    fileText.appendLine(");")
                } else if let value = self[key] {
                    fileText.appendLine("\(key) = \(value);")
                }
            }
        }
    }
}
