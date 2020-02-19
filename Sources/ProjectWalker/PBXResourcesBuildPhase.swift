//
//  PBXVariantGroup.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class PBXResourcesBuildPhase: PBXBuildPhase {
    public override var openStepComment: String {
        return "Resources"
    }

    public override init() {
        super.init()
        self.isa = "PBXResourcesBuildPhase"
    }

    public required init(items: ProjectFileDictionary) {
        super.init(items: items)
    }
}
