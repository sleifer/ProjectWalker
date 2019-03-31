//
//  PBXSourcesBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXSourcesBuildPhase: ProjectObject {
    var buildActionMask: Int
    var files: [Reference]
    var runOnlyForDeploymentPostprocessing: Bool

    override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask") ?? 0
        self.files = items.stringArray(forKey: "files") ?? []
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing") ?? false

        super.init(items: items)
    }
}
