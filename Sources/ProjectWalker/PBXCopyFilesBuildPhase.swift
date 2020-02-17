//
//  PBXCopyFilesBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXCopyFilesBuildPhase: PBXBuildPhase {
    public var buildActionMask: Int?
    public var dstPath: String?
    public var dstSubfolderSpec: Int?
    public var files: [Reference]?
    public var runOnlyForDeploymentPostprocessing: Bool?

    public required init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.dstPath = items.string(forKey: "dstPath")
        self.dstSubfolderSpec = items.int(forKey: "dstSubfolderSpec")
        self.files = items.stringArray(forKey: "files")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("buildActionMask")
        keys.remove("dstPath")
        keys.remove("dstSubfolderSpec")
        keys.remove("files")
        keys.remove("runOnlyForDeploymentPostprocessing")

        super.removeRead(keys: &keys)
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
