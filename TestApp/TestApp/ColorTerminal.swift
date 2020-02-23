//
//  ColorTerminal.swift
//  CommandLineCore
//
//  Created by Simeon Leifer on 10/6/18.
//  Copyright © 2018 droolingcat.com. All rights reserved.
//

import Foundation

public enum ANSIColor: String, CaseIterable {
    case black = "\u{001B}[30m"
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"
    case brightBlack = "\u{001B}[30;1m"
    case brightRed = "\u{001B}[31;1m"
    case brightGreen = "\u{001B}[32;1m"
    case brightYellow = "\u{001B}[33;1m"
    case brightBlue = "\u{001B}[34;1m"
    case brightMagenta = "\u{001B}[35;1m"
    case brightCyan = "\u{001B}[36;1m"
    case brightWhite = "\u{001B}[37;1m"

    case backgroundBlack = "\u{001B}[40m"
    case backgroundRed = "\u{001B}[41m"
    case backgroundGreen = "\u{001B}[42m"
    case backgroundYellow = "\u{001B}[43m"
    case backgroundBlue = "\u{001B}[44m"
    case backgroundMagenta = "\u{001B}[45m"
    case backgroundCyan = "\u{001B}[46m"
    case backgroundWhite = "\u{001B}[47m"
    case backgroundBrightBlack = "\u{001B}[40;1m"
    case backgroundBrightRed = "\u{001B}[41;1m"
    case backgroundBrightGreen = "\u{001B}[42;1m"
    case backgroundBrightYellow = "\u{001B}[43;1m"
    case backgroundBrightBlue = "\u{001B}[44;1m"
    case backgroundBrightMagenta = "\u{001B}[45;1m"
    case backgroundBrightCyan = "\u{001B}[46;1m"
    case backgroundBrightWhite = "\u{001B}[47;1m"

    case bold = "\u{001B}[1m"
    case underline = "\u{001B}[4m"
    case reversed = "\u{001B}[7m"

    case reset = "\u{001B}[0m"
}

public var haveANSIColor: Bool = {
    let istty = isatty(fileno(stdout))
    let xcode = ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"]
    return istty == 1 && xcode == nil
}()

public func + (left: ANSIColor, right: ANSIColor) -> String {
    if haveANSIColor == false {
        return ""
    }
    return left.rawValue + right.rawValue
}

public func + (left: ANSIColor, right: String) -> String {
    if haveANSIColor == false {
        return right
    }
    return left.rawValue + right
}

public func + (left: String, right: ANSIColor) -> String {
    if haveANSIColor == false {
        return left
    }
    return left + right.rawValue
}
