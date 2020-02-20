//
//  PBXCopyFilesBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXCopyFilesBuildPhase: PBXBuildPhase {
    public var dstPath: String?
    public var dstSubfolderSpec: Int?

    public override var openStepComment: String {
        return "CopyFiles"
    }

    public override init() {
        super.init()
        self.isa = "PBXCopyFilesBuildPhase"
    }

    public required init(items: ProjectFileDictionary) {
        self.dstPath = items.string(forKey: "dstPath")
        self.dstSubfolderSpec = items.int(forKey: "dstSubfolderSpec")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("dstPath")
        keys.remove("dstSubfolderSpec")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = buildActionMask {
            fileText.appendLine("buildActionMask = \(value);")
        }
        if let value = dstPath {
            fileText.appendLine("dstPath = \(value.openStepQuoted());")
        }
        if let value = dstSubfolderSpec {
            fileText.appendLine("dstSubfolderSpec = \(value);")
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
        if let value = runOnlyForDeploymentPostprocessing {
            fileText.appendLine("runOnlyForDeploymentPostprocessing = \(value ? 1 : 0);")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }
}
