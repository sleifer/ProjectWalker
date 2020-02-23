//
//  PBXHeadersBuildPhase.swift
//  
//
//  Created by Simeon Leifer on 2/23/20.
//

import Foundation

public class PBXHeadersBuildPhase: PBXBuildPhase {
    public override var openStepComment: String {
        return "Headers"
    }

    public override init() {
        super.init()
        self.isa = "PBXHeadersBuildPhase"
    }

    public required init(items: ProjectFileDictionary) {
        super.init(items: items)
    }
}
