//
//  PBXFrameworksBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXFrameworksBuildPhase: PBXBuildPhase {
    public override var openStepComment: String {
        return "Frameworks"
    }

    public override init() {
        super.init()
    }

    public required init(items: ProjectFileDictionary) {
        super.init(items: items)
    }
}
