//
//  PBXBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXBuildPhase: ProjectObject {
    public var buildActionMask: Int?
    public var files: [Reference]?
    public var runOnlyForDeploymentPostprocessing: Bool?

    public override var openStepComment: String {
        return "<build phase>"
    }

    public required init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.files = items.stringArray(forKey: "files")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("buildActionMask")
        keys.remove("files")
        keys.remove("runOnlyForDeploymentPostprocessing")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(openStepComment) */ = {")
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
        if let value = runOnlyForDeploymentPostprocessing {
            fileText.appendLine("runOnlyForDeploymentPostprocessing = \(value ? 1 : 0);")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = files {
            return files.compactMap { (key) -> PBXBuildFile? in
                objects[key] as? PBXBuildFile
            }
        }
        return nil
    }
}
