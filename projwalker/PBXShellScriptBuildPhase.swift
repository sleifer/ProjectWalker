//
//  PBXShellScriptBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXShellScriptBuildPhase: ProjectObject {
    var buildActionMask: Int
    var files: [String]
    var inputPaths: [String]
    var outputPaths: [String]
    var runOnlyForDeploymentPostprocessing: Bool
    var shellPath: String
    var shellScript: String

    override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask") ?? 0
        self.files = items.stringArray(forKey: "files") ?? []
        self.inputPaths = items.stringArray(forKey: "inputPaths") ?? []
        self.outputPaths = items.stringArray(forKey: "outputPaths") ?? []
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing") ?? false
        self.shellPath = items.string(forKey: "shellPath") ?? ""
        self.shellScript = items.string(forKey: "shellScript") ?? ""

        super.init(items: items)
    }
}
