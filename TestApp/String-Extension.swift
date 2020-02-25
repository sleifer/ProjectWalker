//
//  String-Extension.swift
//  project-tool
//
//  Created by Simeon Leifer on 10/10/17.
//  Copyright © 2017 droolingcat.com. All rights reserved.
//

import Foundation

public extension String {
    var fullPath: String {
        let normal = self.expandingTildeInPath.standardizingPath
        if normal.hasPrefix("/") {
            return normal
        }
        return FileManager.default.currentDirectoryPath.appendingPathComponent(normal)
    }

    var expandingTildeInPath: String {
        return NSString(string: self).expandingTildeInPath
    }

    var abbreviatingWithTildeInPath: String {
        return NSString(string: self).abbreviatingWithTildeInPath
    }

    var deletingLastPathComponent: String {
        return NSString(string: self).deletingLastPathComponent
    }

    var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }

    func replacingOccurrences(of target: String, with replacement: String) -> String {
        return NSString(string: self).replacingOccurrences(of: target, with: replacement)
    }

    func appendingPathExtension(_ str: String) -> String? {
        return NSString(string: self).appendingPathExtension(str)
    }

    func hasFileSuffix(_ str: String) -> Bool {
        return self.deletingPathExtension.hasSuffix(str)
    }

    func changeFileSuffix(from: String, to: String) -> String {
        let ext = self.pathExtension
        let base = self.deletingPathExtension
        if base.hasSuffix(from) {
            if let newStr = base.prefix(upTo: base.count - from.count).appending(to).appendingPathExtension(ext) {
                return newStr
            }
        }
        return self
    }

    func changeFileExtension(to: String) -> String {
        if let newStr = self.deletingPathExtension.appendingPathExtension(to) {
            return newStr
        }
        return self
    }

    func changeFileExtension(from: String, to: String) -> String {
        if self.pathExtension == from {
            if let newStr = self.deletingPathExtension.appendingPathExtension(to) {
                return newStr
            }
        }
        return self
    }

    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }

    var pathExtension: String {
        return NSString(string: self).pathExtension
    }

    var standardizingPath: String {
        return NSString(string: self).standardizingPath
    }

    var isAbsolutePath: Bool {
        return NSString(string: self).isAbsolutePath
    }

    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func appendingPathComponent(_ str: String) -> String {
        return NSString(string: self).appendingPathComponent(str)
    }

    subscript (idx: Int) -> Character {
        return self[index(startIndex, offsetBy: idx)]
    }

    subscript(range: Range<Int>) -> String {
        let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upper = self.index(self.startIndex, offsetBy: range.upperBound)
        let substr = self[lower..<upper]
        return String(substr)
    }

    subscript(range: ClosedRange<Int>) -> String {
        let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upper = self.index(self.startIndex, offsetBy: range.upperBound)
        let substr = self[lower...upper]
        return String(substr)
    }

    func prefix(through position: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: position)
        return String(self.prefix(through: index))
    }

    func prefix(upTo end: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: end)
        return String(self.prefix(upTo: index))
    }

    func suffix(from start: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: start)
        return String(self.suffix(from: index))
    }

    func regex(_ pattern: String) -> [[String]] {
        var matches: [[String]] = []
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            for result in results {
                var submatches: [String] = []
                for idx in 0..<result.numberOfRanges {
                    let range = result.range(at: idx)
                    if range.location != NSNotFound {
                        let substr = self[range.location..<(range.length + range.location)]
                        submatches.append(substr)
                    }
                }
                matches.append(submatches)
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
        }
        return matches
    }

    func components(separatedBy separator: CharacterSet) -> [String] {
        return NSString(string: self).components(separatedBy: separator)
    }

    func components(separatedBy separator: String) -> [String] {
        return NSString(string: self).components(separatedBy: separator)
    }

    func lines(skippingBlanks: Bool = true) -> [String] {
        var lines = self.components(separatedBy: CharacterSet.newlines)
        if skippingBlanks == true {
            lines = lines.filter { (str: String) -> Bool in
                if str.count > 0 {
                    return true
                }
                return false
            }
        }
        return lines
    }

    // swiftlint:disable cyclomatic_complexity

    func quoteSafeWords() -> [String] {
        let text = self
        var words: [String] = []
        var lastIndex: Int = 0
        var inSingleQuote: Bool = false
        var inDoubleQuote: Bool = false
        var needSingleTrim: Bool = false
        var needDoubleTrim: Bool = false
        let singleTrimCharacters = CharacterSet(charactersIn: "' ")
        let doubleTrimCharacters = CharacterSet(charactersIn: "\" ")
        let spaceTrimCharacters = CharacterSet(charactersIn: " ")
        for index in 0..<text.count {
            let achar = text[index]
            if achar == "\"" && inSingleQuote == false {
                inDoubleQuote = !inDoubleQuote
                if inDoubleQuote == true {
                    needDoubleTrim = true
                }
            } else if achar == "'" && inDoubleQuote == false {
                inSingleQuote = !inSingleQuote
                if inSingleQuote == true {
                    needSingleTrim = true
                }
            } else if achar == " " {
                if inSingleQuote == false && inDoubleQuote == false && lastIndex != index {
                    let word: String
                    if needDoubleTrim == true {
                        word = text[lastIndex..<index].trimmingCharacters(in: doubleTrimCharacters)
                    } else if needSingleTrim == true {
                        word = text[lastIndex..<index].trimmingCharacters(in: singleTrimCharacters)
                    } else {
                        word = text[lastIndex..<index].trimmingCharacters(in: spaceTrimCharacters)
                    }
                    needDoubleTrim = false
                    needSingleTrim = false
                    if word.count > 0 {
                        words.append(word)
                    }
                    lastIndex = index + 1
                }
            }
        }
        let index = text.count
        if inSingleQuote == false && inDoubleQuote == false && lastIndex != index {
            let word: String
            if needDoubleTrim == true {
                word = text[lastIndex..<index].trimmingCharacters(in: doubleTrimCharacters)
            } else if needSingleTrim == true {
                word = text[lastIndex..<index].trimmingCharacters(in: singleTrimCharacters)
            } else {
                word = text[lastIndex..<index].trimmingCharacters(in: spaceTrimCharacters)
            }
            needDoubleTrim = false
            needSingleTrim = false
            if word.count > 0 {
                words.append(word)
            }
        }
        return words
    }

    // swiftlint:enable cyclomatic_complexity
}

public extension Collection where Element == String {
    func maxCount() -> Int {
        var maxCount = 0
        for item in self {
            let count = item.count
            if count > maxCount {
                maxCount = count
            }
        }
        return maxCount
    }

    func equalLengthPad(onLeft: Bool = false, with padChar: String = " ") -> [String] {
        var result: [String] = []
        let maxLength = self.maxCount()
        let pad = String(repeating: padChar, count: maxLength)
        for item in self {
            let count = maxLength - item.count
            let index = pad.index(pad.startIndex, offsetBy: count)
            let onePad = String(pad.prefix(upTo: index))
            let newItem: String
            if onLeft == true {
                newItem = onePad + item
            } else {
                newItem = item + onePad
            }
            result.append(newItem)
        }
        return result
    }
}
