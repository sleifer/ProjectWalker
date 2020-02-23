//
//  PBXAggregateTarget.swift
//  
//
//  Created by Simeon Leifer on 2/23/20.
//

import Foundation

public class PBXAggregateTarget: PBXTarget {
    public override var openStepComment: String {
        return name ?? "PBXAggregateTarget"
    }

    public override init() {
        super.init()
        self.isa = "PBXAggregateTarget"
    }

    public required init(items: ProjectFileDictionary) {
        super.init(items: items)
    }
}
