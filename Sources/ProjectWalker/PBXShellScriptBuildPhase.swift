//
//  PBXShellScriptBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXShellScriptBuildPhase: PBXBuildPhase {
    public var buildActionMask: Int?
    public var files: [Reference]?
    public var inputPaths: [String]?
    public var outputPaths: [String]?
    public var runOnlyForDeploymentPostprocessing: Bool?
    public var shellPath: String?
    public var shellScript: String?

    public override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.files = items.stringArray(forKey: "files")
        self.inputPaths = items.stringArray(forKey: "inputPaths")
        self.outputPaths = items.stringArray(forKey: "outputPaths")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")
        self.shellPath = items.string(forKey: "shellPath")
        self.shellScript = items.string(forKey: "shellScript")

        super.init(items: items)
    }

    public func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = files {
            return files.compactMap({ (key) -> PBXBuildFile? in
                return objects[key] as? PBXBuildFile
            })
        }
        return nil
    }
}
