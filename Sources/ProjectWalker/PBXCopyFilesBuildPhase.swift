//
//  PBXCopyFilesBuildPhase.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXCopyFilesBuildPhase: PBXBuildPhase {
    public var dstPath: String?
    public var dstSubfolderSpec: Int?

    public override var openStepComment: String {
        return "Copy Files"
    }

    public required init(items: ProjectFileDictionary) {
        self.dstPath = items.string(forKey: "dstPath")
        self.dstSubfolderSpec = items.int(forKey: "dstSubfolderSpec")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("dstPath")
        keys.remove("dstSubfolderSpec")

        super.removeRead(keys: &keys)
    }
}
