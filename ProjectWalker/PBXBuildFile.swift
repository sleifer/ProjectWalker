//
//  PBXBuildFile.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXBuildFile: ProjectObject {
    public var fileRef: Reference?
    public var settings: [String: String]?

    public override init(items: ProjectFileDictionary) {
        self.fileRef = items.string(forKey: "fileRef")
        self.settings = items["settings"] as? [String: String]

        super.init(items: items)
    }

    public func getFileRef() -> PBXFileReference? {
        if let objects = project?.objects, let key = fileRef {
            return objects[key] as? PBXFileReference
        }
        return nil
    }
}
