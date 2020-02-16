//
//  PBXFileReference.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXFileReference: PBXFileElement {
    public var fileEncoding: Int?
    public var explicitFileType: String?
    public var lastKnownFileType: String?
    public var name: String?
    public var path: String?
    public var sourceTree: String?

    public override init(items: ProjectFileDictionary) {
        self.fileEncoding = items.int(forKey: "fileEncoding")
        self.explicitFileType = items.string(forKey: "explicitFileType")
        self.lastKnownFileType = items.string(forKey: "lastKnownFileType")
        self.name = items.string(forKey: "name")
        self.path = items.string(forKey: "path")
        self.sourceTree = items.string(forKey: "sourceTree")

        super.init(items: items)
    }
}
