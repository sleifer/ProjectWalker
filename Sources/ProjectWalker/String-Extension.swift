//
//  String-Extension.swift
//  
//
//  Created by Simeon Leifer on 2/17/20.
//

import Foundation

let quotingCharacterSet = CharacterSet(charactersIn: "\\\"=@+-$:< >")

extension String {
    func openStepQuoted() -> String {
        let nsStr = NSString(string: self)
        let range = nsStr.rangeOfCharacter(from: quotingCharacterSet)
        if range.location == NSNotFound && self.count > 0 {
            return self
        }
        var new = self.replacingOccurrences(of: "\\", with: "\\\\")
        new = new.replacingOccurrences(of: "\"", with: "\\\"")
        new = new.replacingOccurrences(of: "\n", with: "\\n")
        return "\"\(new)\""
    }
}
