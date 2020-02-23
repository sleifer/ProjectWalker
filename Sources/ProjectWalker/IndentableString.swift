//
//  IndentableString.swift
//  
//
//  Created by Simeon Leifer on 2/17/20.
//

import Foundation

class IndentableString {
    private(set) var text: String
    private(set) var indentLevel: Int {
        didSet {
            makeIndentString()
        }
    }
    private var indentString: String

    init() {
        text = ""
        indentLevel = 0
        indentString = ""
    }

    func indent() {
        indentLevel += 1
    }

    func outdent() {
        indentLevel -= 1
    }

    private func makeIndentString() {
        indentString = String(repeating: "\t", count: indentLevel)
    }

    func appendLine(_ line: String, ignoreIndent: Bool = false) {
        if ignoreIndent == true {
            text.append("\(line)\n")
        } else {
            text.append("\(indentString)\(line)\n")
        }
    }

    func append(_ inText: String, ignoreIndent: Bool = false) {
        if ignoreIndent == true {
            text.append("\(inText)")
        } else {
            text.append("\(indentString)\(inText)")
        }
    }
}
