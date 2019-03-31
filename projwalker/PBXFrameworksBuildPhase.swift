//
//  PBXFrameworksBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXFrameworksBuildPhase: ProjectObject {
    var buildActionMask: Int?
    var file: [Reference]?
    var runOnlyForDeploymentPostprocessing: Bool?

    override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.file = items.stringArray(forKey: "file")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")

        super.init(items: items)
    }
}
