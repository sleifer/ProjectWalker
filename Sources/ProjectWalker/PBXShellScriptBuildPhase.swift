//
//  PBXShellScriptBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXShellScriptBuildPhase: PBXBuildPhase {
    public var inputPaths: [String]?
    public var inputFileListPaths: [String]?
    public var outputPaths: [String]?
    public var outputFileListPaths: [String]?
    public var shellPath: String?
    public var shellScript: String?

    public override var openStepComment: String {
        return "ShellScript"
    }

    public required init(items: ProjectFileDictionary) {
        self.inputPaths = items.stringArray(forKey: "inputPaths")
        self.inputFileListPaths = items.stringArray(forKey: "inputFileListPaths")
        self.outputPaths = items.stringArray(forKey: "outputPaths")
        self.outputFileListPaths = items.stringArray(forKey: "outputFileListPaths")
        self.shellPath = items.string(forKey: "shellPath")
        self.shellScript = items.string(forKey: "shellScript")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("inputPaths")
        keys.remove("inputFileListPaths")
        keys.remove("outputPaths")
        keys.remove("outputFileListPaths")
        keys.remove("shellPath")
        keys.remove("shellScript")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = buildActionMask {
            fileText.appendLine("buildActionMask = \(value);")
        }
        if let value = files {
            fileText.appendLine("files = (")
            fileText.indent()
            for oneFile in value {
                if let file = project?.object(withKey: oneFile) {
                    fileText.appendLine("\(oneFile) /* \(file.openStepComment) */,")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = inputFileListPaths {
            fileText.appendLine("inputFileListPaths = (")
            fileText.indent()
            for item in value {
                fileText.appendLine("\(item.openStepQuoted()),")
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = inputPaths {
            fileText.appendLine("inputPaths = (")
            fileText.indent()
            for item in value {
                fileText.appendLine("\(item.openStepQuoted()),")
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = outputFileListPaths {
            fileText.appendLine("outputFileListPaths = (")
            fileText.indent()
            for item in value {
                fileText.appendLine("\(item.openStepQuoted()),")
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = outputPaths {
            fileText.appendLine("outputPaths = (")
            fileText.indent()
            for item in value {
                fileText.appendLine("\(item.openStepQuoted()),")
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = runOnlyForDeploymentPostprocessing {
            fileText.appendLine("runOnlyForDeploymentPostprocessing = \(value ? 1 : 0);")
        }
        if let value = shellPath {
            fileText.appendLine("shellPath = \(value.openStepQuoted());")
        }
        if let value = shellScript {
            fileText.appendLine("shellScript = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }
}
