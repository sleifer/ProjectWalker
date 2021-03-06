//
//  PBXNativeTarget.swift
//
//
//  Created by Simeon Leifer on 2/23/20.
//

import Foundation

public class PBXNativeTarget: PBXTarget {
    public override var openStepComment: String {
        return name ?? "PBXNativeTarget"
    }

    public override init() {
        super.init()
        self.isa = "PBXNativeTarget"
    }

    public required init(items: ProjectFileDictionary) {
        super.init(items: items)
    }
}
