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
    public var settings: ProjectFileDictionary?

    public required init(items: ProjectFileDictionary) {
        self.fileRef = items.string(forKey: "fileRef")
        self.settings = items.dictionary(forKey: "settings")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("fileRef")
        keys.remove("settings")

        super.removeRead(keys: &keys)
    }

    public func getFileRef() -> PBXFileReference? {
        if let objects = project?.objects, let key = fileRef {
            return objects[key] as? PBXFileReference
        }
        return nil
    }
}
