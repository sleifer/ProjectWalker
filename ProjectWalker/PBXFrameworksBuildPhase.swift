//
//  PBXFrameworksBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXFrameworksBuildPhase: PBXBuildPhase {
    var buildActionMask: Int?
    var files: [Reference]?
    var runOnlyForDeploymentPostprocessing: Bool?

    override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.files = items.stringArray(forKey: "file")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")

        super.init(items: items)
    }

    func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = files {
            return files.compactMap({ (key) -> PBXBuildFile? in
                return objects[key] as? PBXBuildFile
            })
        }
        return nil
    }
}
